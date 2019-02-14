# glacier-archive-remover
Amazon Glacier Vault Remover. Allows you to delete multiple amazon archives in a glacier vault using AWS Command Line Interface.


Requirements:
- aws cli (https://docs.aws.amazon.com/cli/latest/userguide/install-bundle.html#install-bundle-other)
- jq (https://stedolan.github.io/jq/download/)
- JSON Output file of the vaults inventory. Create one using follwing steps
  - "aws configure" (enter credentials)
  - "aws glacier initiate-job --account-id - --vault-name YOUR_VAULT_NAME --job-parameters '{"Type": "inventory-retrieval"}'"
  - "aws glacier list-jobs --account-id - --vault-name YOUR_VAULT_NAME" (return status of inventory job and its ID, wait until its completed. This may take a while)
  - "aws glacier get-job-output --account-id - --vault-name YOUR_VAULT_NAME --job-id THE_JOB_ID output.json" (creates an output file with list of archives)

Usage:

"bash deletearchive.sh -a AWS_ACCOUNT_ID -r AWS_REGION -v AWS_VAULT_NAME -f PATH_TO_FILE"
