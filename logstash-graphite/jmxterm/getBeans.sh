#!/bin/bash  

date > jmxdump.txt
for OUTPUT in $(cat beans.txt)
do
  echo "-------------------------------------------------------------------------------" >> jmxdump.txt
  echo "Bean: $OUTPUT" >> jmxdump.txt  
	echo "get -i -b $OUTPUT *" | java -jar jmxterm-1.0-alpha-4-uber.jar -l service:jmx:rmi:///jndi/rmi://127.0.0.1:50500/alfresco/jmxrmi -u controlRole -p change_asap -n >> jmxdump.txt
done

echo "-------------------------------------------------------------------------------" >> jmxdump.txt
date >> jmxdump.txt
 
# Remove blank lines
sed '/^$/d' jmxdump.txt > jmxdump.txt.noBlankLines
mv jmxdump.txt.noBlankLines  jmxdump.txt
exit
