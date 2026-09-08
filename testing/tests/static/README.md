**Static checks**
**Built In**
Format : enforces style rules for your configurations.
terraform fmt -check # checks if formatter would make changes
terraform fmt # applies those changes

validate : checks the configuration are valid
Terraform init is required to use validate. if not working with a remote backend, terraform init -backend=false can be used
terraform validate

plan :
