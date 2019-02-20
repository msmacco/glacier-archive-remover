#!/bin/bash

while getopts a:r:v: option
	do
		case "${option}"
			in
			a) AWS_ACCOUNT_ID=${OPTARG};;
			r) AWS_REGION=${OPTARG};;
			v) AWS_VAULT_NAME=${OPTARG};;
	esac
done


if [[ -z $AWS_ACCOUNT_ID ]] || [[ -z $AWS_REGION ]] || [[ -z $AWS_VAULT_NAME ]]; then
	echo "Please set the following input variables: "
	echo "AWS_ACCOUNT_ID (-a)"
	echo "AWS_REGION (-r)"
	echo "AWS_VAULT_NAME (-v)"
	exit 1
fi

######
echo "initiate inventory-retrieval"
echo "Job startet: $(date)"
aws glacier initiate-job --account-id - --vault-name ${AWS_VAULT_NAME} --job-parameters '{"Type": "inventory-retrieval"}' > temp.json

job_id=$( jq -r '.jobId' ./temp.json)
echo "inventory-retrieval Job ID: ${job_id}"

echo "retrieving job_status"

while 
    aws glacier list-jobs --account-id - --vault-name ${AWS_VAULT_NAME} > temp.json
	job_status=$( jq -r '.JobList[0].StatusCode' ./temp.json)
	echo ${job_status}
	sleep 60
    [[ ${job_status} == "InProgress" ]]
do
    :
done

echo "inventory-retrieval status: ${job_status}"

if [[ ${job_status} != 'Succeeded' ]]; then
	echo "inventory-retrieval was not Succeeded. Exit script"
	exit 1
fi

aws glacier get-job-output --account-id - --vault-name ${AWS_VAULT_NAME} --job-id ${job_id} temp.json


######
archive_ids=($(jq .ArchiveList[].ArchiveId < ./temp.json))

current_archive_number=0
total_archive_number=${#archive_ids[@]}

for archive_id in ${archive_ids[@]}; do
	current_archive_number=$((${current_archive_number}+1))
    echo ${current_archive_number}/${total_archive_number} Deleting Archive: ${archive_id}
    aws glacier delete-archive --archive-id=${archive_id} --vault-name ${AWS_VAULT_NAME} --account-id ${AWS_ACCOUNT_ID} --region ${AWS_REGION}
done

echo "Finished deleting archives"
echo "Deleting Files"
rm temp.json
echo "Job Finished: $(date)"