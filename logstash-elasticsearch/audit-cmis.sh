#Script to get CMIS audit events
sleepTime=30

auditRoot=/opt/alfresco
lastId=

while [ 1 ]
do
  now=`date +"%Y-%m-%d-%T"`
  auditLog=./auditLog/audit-cmis-${now}.log
  parsedAuditLog=audit-cmis-${now}.parsed
  touch $auditLog
  fromTime=`date +"%s" -d -60seconds`000

  if [ ! -n "$lastId" ]; then
    echo "from Time: $fromTime" 
    curl -u admin:admin "http://localhost:8080/alfresco/service/api/audit/query/CMISChangeLog?verbose=true&limit=5000&fromTime=$fromTime" >> $auditLog
    lastId=`grep "\"id\":" $auditLog | tail -1 | sed s/,// | tr -d "\n" | tr -d "\r" | awk -F: '{print $2}'`
    echo "To Id = $lastId"
    if [ -n "$lastId" ]; then
      lastId=$((lastId + 1))
    fi
  else
    echo "From Id: $lastId"
    curl -u admin:admin "http://localhost:8080/alfresco/service/api/audit/query/CMISChangeLog?verbose=true&limit=5000&fromId=$lastId" >> $auditLog
    newId=`grep "\"id\":" $auditLog | tail -1 | sed s/,// | tr -d "\n" | tr -d "\r" | awk -F: '{print $2}'`
    echo "To Id = $lastId"
    if [ -n "$newId" ]; then
      lastId=$((newId + 1))
    fi
  fi

  if [ -n "$lastId" ]; then
    #Process the audit file
    java -jar ParseAuditFile.jar $auditLog > $auditRoot/$parsedAuditLog
  fi
  #Delete files older than 30 minutes
  find auditLog -maxdepth 1 -name "audit-cmis-*.log" -type f -mmin +30 -delete

  #Siesta time
  sleep $sleepTime
  #Delete files older than 30 minutes
  find $auditRoot/ -maxdepth 1 -name "audit-cmis-*.parsed" -type f -mmin +30 -delete
done
