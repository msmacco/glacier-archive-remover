# glacier-archive-remover
Amazon Glacier Vault Remover. Allows you to delete multiple amazon archives in a glacier vault using AWS Command Line Interface.
As long as you cannot delete Non-Empty Vaults in AWS Glacier, this is necessary step to empty the vault.


Requirements:
- aws cli (https://docs.aws.amazon.com/cli/latest/userguide/install-bundle.html#install-bundle-other)
- jq (https://stedolan.github.io/jq/download/)

Usage:

"bash delete_archive.sh -a AWS_ACCOUNT_ID -r AWS_REGION -v AWS_VAULT_NAME
