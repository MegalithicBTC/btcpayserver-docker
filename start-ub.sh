docker compose \
  -f Generated/docker-compose-ubuntu.yml \
  down
docker compose \
  -f Generated/docker-compose-ubuntu.yml \
  up
  #\ we commented it out
  #--scale btcpayserver=0   