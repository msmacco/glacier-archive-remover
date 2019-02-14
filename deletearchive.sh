#!/bin/bash

while getopts a:r:v:f: option
	do
		case "${option}"
			in
			a) AWS_ACCOUNT_ID=${OPTARG};;
			r) AWS_REGION=${OPTARG};;
			v) AWS_VAULT_NAME=${OPTARG};;
			f) FILE=$OPTARG;;
	esac
done


if [[ -z $AWS_ACCOUNT_ID ]] || [[ -z $AWS_REGION ]] || [[ -z $AWS_VAULT_NAME ]] || [[ -z $FILE ]]; then
	echo "Please set the following input variables: "
	echo "AWS_ACCOUNT_ID (-a)"
	echo "AWS_REGION (-r)"
	echo "AWS_VAULT_NAME (-v)"
	echo "FILE (-f)"
	exit 1
fi

archive_ids=($(jq .ArchiveList[].ArchiveId < $FILE))

current_archive_number=0
total_archive_number=${#archive_ids[@]}

for archive_id in ${archive_ids[@]}; do
	current_archive_number=$((${current_archive_number}+1))
    echo ${current_archive_number}/${total_archive_number} Deleting Archive: ${archive_id}
    aws glacier delete-archive --archive-id=${archive_id} --vault-name ${AWS_VAULT_NAME} --account-id ${AWS_ACCOUNT_ID} --region ${AWS_REGION}
done

echo "Finished deleting archives"
