# key SAS
export SAS_VALUE="xxx"
export SAS_NAME="xxx"
#The eventhub hub topic
export EVENTHUB="xxx"
## the eventhub namepace
export EVENTHUB_NAMESPACE="xxx"
## the eventhub to target 
TARGET_URL="https://$EVENTHUB_NAMESPACE.servicebus.windows.net"
## Resource group where it should all live
RG="locusteventhub"
##location 
LOCATION="centralus"
#name of the master ACI instance 
MASTER_NAME="locustmaster"
# prefix name of the slaves 
SLAVE_NAME="locustslave"
## the dns prefix of the master
DNS_LABEL="eventhublocustmaster3"
##the fqdn that is generated 
MASTER_FQDN="$DNS_LABEL.$LOCATION.azurecontainer.io"

echo Spinning up master 
## create group
az group create -n $RG  -l $location
#create master with public ip 
az container create   -g $RG --image  ivmckinl/eventhubloggenerator:v1 --ports 8089 5557 -l $LOCATION --name $MASTER_NAME  --ip-address public  --dns-name-label $DNS_LABEL --secure-environment-variables SAS_VALUE=$SAS_VALUE  -e LOCUST_MODE="master" TARGET_URL=$TARGET_URL SAS_NAME=$SAS_NAME EVENTHUB_NAMESPACE=$EVENTHUB_NAMESPACE EVENTHUB=$EVENTHUB
if [ $? -eq 0 ]
then
    echo "Success"
else
    echo "Could not create master container"
    exit -1;
fi

##slaves 
for i in {0..5}; do  echo spinning up slave $i; az container create   -g $RG --image  ivmckinl/eventhubloggenerator:v1 --name $SLAVE_NAME-$i  -l centralus  --secure-environment-variables SAS_VALUE=$SAS_VALUE -e LOCUST_MASTER_HOST=$MASTER_FQDN LOCUST_MASTER_PORT=5557 LOCUST_MODE="slave" TARGET_URL=$TARGET_URL SAS_NAME=$SAS_NAME EVENTHUB_NAMESPACE=$EVENTHUB_NAMESPACE EVENTHUB=$EVENTHUB --no-wait; echo spinning up slave; done


#for i in {0..20}; do az container delete   -g locusteventhub --name locustslave-$i -y; done


