package main

import (
	"encoding/json"
	"fmt"
	"strconv"
	"strings"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

// VotingContract provides functions for managing e-voting
type VotingContract struct {
	contractapi.Contract
}

// Election represents an election configuration
type Election struct {
	ElectionID  string   `json:"electionId"`
	Candidates  []string `json:"candidates"`
	StartTime   int64    `json:"startTime"`
	EndTime     int64    `json:"endTime"`
	Description string   `json:"description"`
}

// Vote represents a cast vote (minimal data stored on-chain)
type Vote struct {
	ElectionID   string `json:"electionId"`
	CandidateID  string `json:"candidateId"`
	VoterProof   string `json:"voterProof"` // Combined hash of Aadhaar+VoterID
	Timestamp    int64  `json:"timestamp"`
	Location     string `json:"location"`
	FaceVerified bool   `json:"faceVerified"`
	TxID         string `json:"txId"`
}

// VoteResult represents election results
type VoteResult struct {
	ElectionID string         `json:"electionId"`
	Results    map[string]int `json:"results"`
	TotalVotes int            `json:"totalVotes"`
	Candidates []string       `json:"candidates"`
}

// InitElection initializes a new election
func (vc *VotingContract) InitElection(ctx contractapi.TransactionContextInterface,
	electionID string, candidates []string, startTime int64, endTime int64, description string) error {

	// Check if election already exists
	existingElection, err := ctx.GetStub().GetState("election:" + electionID)
	if err != nil {
		return fmt.Errorf("failed to read election: %v", err)
	}
	if existingElection != nil {
		return fmt.Errorf("election %s already exists", electionID)
	}

	// Validate time window
	if startTime >= endTime {
		return fmt.Errorf("start time must be before end time")
	}

	// Create election
	election := Election{
		ElectionID:  electionID,
		Candidates:  candidates,
		StartTime:   startTime,
		EndTime:     endTime,
		Description: description,
	}

	electionBytes, err := json.Marshal(election)
	if err != nil {
		return fmt.Errorf("failed to marshal election: %v", err)
	}

	// Store election configuration
	err = ctx.GetStub().PutState("election:"+electionID, electionBytes)
	if err != nil {
		return fmt.Errorf("failed to store election: %v", err)
	}

	// Initialize candidate counters
	for _, candidate := range candidates {
		counterKey := fmt.Sprintf("count:%s:%s", electionID, candidate)
		err = ctx.GetStub().PutState(counterKey, []byte("0"))
		if err != nil {
			return fmt.Errorf("failed to initialize counter for candidate %s: %v", candidate, err)
		}
	}

	// Emit event
	err = ctx.GetStub().SetEvent("ElectionInitialized", electionBytes)
	if err != nil {
		return fmt.Errorf("failed to emit event: %v", err)
	}

	return nil
}

// CastVote records a vote on the blockchain
func (vc *VotingContract) CastVote(ctx contractapi.TransactionContextInterface,
	electionID string, hashedAadhaar string, hashedVoterID string, hashedName string,
	faceVerified bool, candidateID string, location string) error {

	// Input validation
	if len(hashedAadhaar) != 64 || len(hashedVoterID) != 64 {
		return fmt.Errorf("invalid hash length: Aadhaar and Voter ID hashes must be 64 characters")
	}

	if len(hashedName) != 64 {
		return fmt.Errorf("invalid name hash length: must be 64 characters")
	}

	// Get transaction timestamp
	timestamp, err := ctx.GetStub().GetTxTimestamp()
	if err != nil {
		return fmt.Errorf("failed to get transaction timestamp: %v", err)
	}

	// Get election configuration
	electionBytes, err := ctx.GetStub().GetState("election:" + electionID)
	if err != nil {
		return fmt.Errorf("failed to read election: %v", err)
	}
	if electionBytes == nil {
		return fmt.Errorf("election %s does not exist", electionID)
	}

	var election Election
	err = json.Unmarshal(electionBytes, &election)
	if err != nil {
		return fmt.Errorf("failed to unmarshal election: %v", err)
	}

	// Check time window
	currentTime := timestamp.Seconds
	if currentTime < election.StartTime {
		return fmt.Errorf("voting has not started yet")
	}
	if currentTime > election.EndTime {
		return fmt.Errorf("voting has ended")
	}

	// Validate candidate
	candidateExists := false
	for _, candidate := range election.Candidates {
		if candidate == candidateID {
			candidateExists = true
			break
		}
	}
	if !candidateExists {
		return fmt.Errorf("invalid candidate: %s", candidateID)
	}

	// Basic location validation (check if it's in India - simplified)
	if !vc.isValidIndianLocation(location) {
		return fmt.Errorf("invalid location: voting only allowed from India")
	}

	// Require face verification
	if !faceVerified {
		return fmt.Errorf("face verification failed")
	}

	// Create composite voter proof (combines Aadhaar + Voter ID for uniqueness)
	voterProof := fmt.Sprintf("%s:%s", hashedAadhaar, hashedVoterID)

	// Check if already voted
	votedKey := fmt.Sprintf("voted:%s:%s", electionID, voterProof)
	existingVote, err := ctx.GetStub().GetState(votedKey)
	if err != nil {
		return fmt.Errorf("failed to check if already voted: %v", err)
	}
	if existingVote != nil {
		return fmt.Errorf("voter has already cast a vote in this election")
	}

	// Get transaction ID
	txID := ctx.GetStub().GetTxID()

	// Create vote record
	vote := Vote{
		ElectionID:   electionID,
		CandidateID:  candidateID,
		VoterProof:   voterProof,
		Timestamp:    currentTime,
		Location:     location,
		FaceVerified: faceVerified,
		TxID:         txID,
	}

	voteBytes, err := json.Marshal(vote)
	if err != nil {
		return fmt.Errorf("failed to marshal vote: %v", err)
	}

	// Mark as voted (prevents double voting)
	err = ctx.GetStub().PutState(votedKey, []byte(txID))
	if err != nil {
		return fmt.Errorf("failed to mark as voted: %v", err)
	}

	// Store vote record
	voteKey := fmt.Sprintf("vote:%s:%s", electionID, txID)
	err = ctx.GetStub().PutState(voteKey, voteBytes)
	if err != nil {
		return fmt.Errorf("failed to store vote: %v", err)
	}

	// Increment candidate counter
	counterKey := fmt.Sprintf("count:%s:%s", electionID, candidateID)
	counterBytes, err := ctx.GetStub().GetState(counterKey)
	if err != nil {
		return fmt.Errorf("failed to read counter: %v", err)
	}

	counter := 0
	if counterBytes != nil {
		counter, err = strconv.Atoi(string(counterBytes))
		if err != nil {
			return fmt.Errorf("failed to parse counter: %v", err)
		}
	}

	counter++
	err = ctx.GetStub().PutState(counterKey, []byte(strconv.Itoa(counter)))
	if err != nil {
		return fmt.Errorf("failed to update counter: %v", err)
	}

	// Emit vote cast event
	err = ctx.GetStub().SetEvent("VoteCast", voteBytes)
	if err != nil {
		return fmt.Errorf("failed to emit event: %v", err)
	}

	return nil
}

// HasVoted checks if a voter has already voted
func (vc *VotingContract) HasVoted(ctx contractapi.TransactionContextInterface,
	electionID string, hashedAadhaar string, hashedVoterID string) (bool, error) {

	voterProof := fmt.Sprintf("%s:%s", hashedAadhaar, hashedVoterID)
	votedKey := fmt.Sprintf("voted:%s:%s", electionID, voterProof)

	existingVote, err := ctx.GetStub().GetState(votedKey)
	if err != nil {
		return false, fmt.Errorf("failed to check voting status: %v", err)
	}

	return existingVote != nil, nil
}

// GetResults returns the current election results
func (vc *VotingContract) GetResults(ctx contractapi.TransactionContextInterface, electionID string) (*VoteResult, error) {
	// Get election configuration
	electionBytes, err := ctx.GetStub().GetState("election:" + electionID)
	if err != nil {
		return nil, fmt.Errorf("failed to read election: %v", err)
	}
	if electionBytes == nil {
		return nil, fmt.Errorf("election %s does not exist", electionID)
	}

	var election Election
	err = json.Unmarshal(electionBytes, &election)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal election: %v", err)
	}

	// Get results for each candidate
	results := make(map[string]int)
	totalVotes := 0

	for _, candidate := range election.Candidates {
		counterKey := fmt.Sprintf("count:%s:%s", electionID, candidate)
		counterBytes, err := ctx.GetStub().GetState(counterKey)
		if err != nil {
			return nil, fmt.Errorf("failed to read counter for candidate %s: %v", candidate, err)
		}

		counter := 0
		if counterBytes != nil {
			counter, err = strconv.Atoi(string(counterBytes))
			if err != nil {
				return nil, fmt.Errorf("failed to parse counter for candidate %s: %v", candidate, err)
			}
		}

		results[candidate] = counter
		totalVotes += counter
	}

	voteResult := &VoteResult{
		ElectionID: electionID,
		Results:    results,
		TotalVotes: totalVotes,
		Candidates: election.Candidates,
	}

	return voteResult, nil
}

// GetElection returns election configuration
func (vc *VotingContract) GetElection(ctx contractapi.TransactionContextInterface, electionID string) (*Election, error) {
	electionBytes, err := ctx.GetStub().GetState("election:" + electionID)
	if err != nil {
		return nil, fmt.Errorf("failed to read election: %v", err)
	}
	if electionBytes == nil {
		return nil, fmt.Errorf("election %s does not exist", electionID)
	}

	var election Election
	err = json.Unmarshal(electionBytes, &election)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal election: %v", err)
	}

	return &election, nil
}

// isValidIndianLocation performs basic validation for Indian locations
// This is a simplified check - in production, you'd use a proper geocoding service
func (vc *VotingContract) isValidIndianLocation(location string) bool {
	// Basic validation - check if location string contains latitude/longitude
	// and is within rough bounds of India (6°N to 37°N, 68°E to 97°E)
	if location == "" {
		return false
	}

	// For hackathon purposes, accept any non-empty location
	// In production, you'd parse coordinates and validate bounds
	parts := strings.Split(location, ",")
	if len(parts) < 2 {
		return false
	}

	// Could add more sophisticated validation here
	return true
}

func main() {
	contract := new(VotingContract)

	chaincode, err := contractapi.NewChaincode(contract)
	if err != nil {
		panic("Could not create chaincode from VotingContract." + err.Error())
	}

	err = chaincode.Start()
	if err != nil {
		panic("Failed to start chaincode. " + err.Error())
	}
}
