docker compose \
  -f docker-compose-ubuntu-caddy.yml \
  down
docker compose \
  -f docker-compose-ubuntu-caddy.yml \
  up
  #\ we commented it out
  #--scale btcpayserver=0   