# Show all container statuses
docker ps -a

# Show only failed containers
docker ps -a --filter "status=exited"

# Quick logs for all failed containers
for container in $(docker ps -a --filter "status=exited" --format "{{.Names}}"); do
    echo "==== Logs for $container ===="
    docker logs --tail 20 "$container"
    echo ""
done
