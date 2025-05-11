docker compose \
  -f Generated/docker-compose-megalith-dev.yml \
  up -d \
  --scale btcpayserver=0   