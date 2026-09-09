#!/bin/bash
set -euo pipefail

cd ../../examples/hello-world

terraform init
terraform apply -auto-approve

sleep 60

IP=$(terraform output -json | jq -r '.instance_ip_address.value' | tr -d '\r')

# retry curl a few times instead of failing immediately
for i in {1..5}; do
  if curl -sf "http://${IP}:8080" -m 10; then
    echo "Success!"
    break
  fi
  echo "Not ready yet, retrying in 10s..."
  sleep 10
done

terraform destroy -auto-approve