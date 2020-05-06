# eventhubloadgen
locust python script to push message to a eventhub


## to deploy 
modify the variables in the deployaci.sh
### key SAS and name
export SAS_VALUE="xxx"
export SAS_NAME="simple"
#The eventhub hub topic
export EVENTHUB="xxx"
### the eventhub namepace
export EVENTHUB_NAMESPACE="xxx"
### the eventhub to target 
TARGET_URL="https://$EVENTHUB_NAMESPACE.servicebus.windows.net"
### Resource group where it should all live
RG="locusteventhub"
### location 
LOCATION="centralus"
### name of the master ACI instance 
MASTER_NAME="locustmaster"
### prefix name of the slaves 
SLAVE_NAME="locustslave"
### the dns prefix of the master
DNS_LABEL="eventhublocustmaster3"
"