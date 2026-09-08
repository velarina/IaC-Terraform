# "C:\Program Files\Git\bin\bash.exe" ./hello_world_test.sh
#!/bin/bash
set -euo pipefail

# change dirrectory to example
cd ../../examples/hello-world

# create the resource
terraform init
terraform apply -auto-approve

# wait while the instance boots up
# (could also use a provisioner in the TF config to do this)
sleep 60

# query the output, extract the IP and make a request
terraform output -json |\
jq -r '.instance_ip_address.value' |\
xargs -I {} curl http://{}:8080 -m 10

# if request succeeds, destroy the resources
terraform destroy -auto-approve