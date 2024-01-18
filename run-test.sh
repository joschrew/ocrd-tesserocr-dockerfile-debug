#!/usr/bin/bash
docker-compose down --remove-orphans
./clean-data.sh
sleep 1
docker-compose up -d --wait
sleep 10
res=`curl -v -X POST "localhost:8000/workflow/run?mets_path=/data/vd18test/mets.xml&page_wise=True" -H "Content-type: multipart/form-data" -F "workflow=@test-workflow.txt"`
#echo "res:>$res<"
job_id=`echo $res | jq -r '.job_id'`
#echo "job_id:>$job_id<"
echo ""
echo "run following command to see the workflow status:"
echo "curl \"localhost:8000/workflow/job/$job_id\" | jq"
