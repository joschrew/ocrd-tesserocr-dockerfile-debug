#!/usr/bin/env bash
DOCKER_COMPOSE=${1:-docker-compose}
$DOCKER_COMPOSE down --remove-orphans
./clean-data.sh
sleep 1
$DOCKER_COMPOSE up -d --wait
sleep 20
res=`curl -v -X POST "localhost:8000/workflow/run?mets_path=/data/pudbtest/mets.xml&page_wise=True" -H "Content-type: multipart/form-data" -F "workflow=@test-pudb-workflow.txt"`
#echo "res:>$res<"
job_id=`echo $res | jq -r '.job_id'`
#echo "job_id:>$job_id<"
echo ""
echo "run following command to see the workflow status:"
echo "curl \"localhost:8000/workflow/job/$job_id\" | jq"
