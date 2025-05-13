docker compose \
  -f docker-compose-ubuntu.yml \
  down
docker compose \
  -f docker-compose-ubuntu.yml \
  up
  #\ we commented it out
  #--scale btcpayserver=0   