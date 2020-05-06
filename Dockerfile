FROM locustio/locust
## can be master, slace, standalone
ENV LOCUST_MODE="standalone"
ENV LOCUSTFILE_PATH="/locustfile.py"

EXPOSE 5557 8089
## tell the slace how to connect
#ENV LOCUST_MASTER_HOST=
ENV LOCUST_MASTER_PORT="5557"
### include the urls
ENV LOCUST_OPTS=""
ENV TARGET_URL=""

ENV SAS_VALUE="xxxxx"
ENV SAS_NAME="simple"

# topic name
ENV EVENTHUB="xxx"
# Eventhub namespace name. this ends being used "https://{EVENTHUB_NAMESPACE}.servicebus.windows.net/{EVENTHUB}
ENV EVENTHUB_NAMESPACE="xxxx"

RUN pip install Faker
ADD locustfile.py locustfile.py