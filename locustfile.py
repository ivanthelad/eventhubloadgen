from locust import HttpLocust, TaskSet, task, between
import random
import string
import time
import urllib
import hmac
import hashlib
import base64
import os
from faker import Faker
#from faker import Faker
sb_name= os.getenv('EVENTHUB_NAMESPACE')
eh_name= os.getenv('EVENTHUB')
sas_name= os.getenv('SAS_NAME')
sas_value= os.getenv('SAS_VALUE')

print(eh_name)
url_post= "/" + eh_name + "/messages"
print(url_post)
faker = Faker()

def random_string_generator(str_size, allowed_chars):
    return ''.join(random.choice(allowed_chars) for x in range(str_size))
chars = string.ascii_letters + string.punctuation
size = 12

#print(chars)
#print('Random String of length 12 =', random_string_generator(size, chars))

def get_auth_token(sb_name, eh_name, sas_name, sas_value):
    """
    Returns an authorization token dictionary 
    for making calls to Event Hubs REST API.
    """
    uri = urllib.parse.quote_plus("https://{}.servicebus.windows.net/{}" \
                                  .format(sb_name, eh_name))
    sas = sas_value.encode('utf-8')
    expiry = str(int(time.time() + 10000))
    string_to_sign = (uri + '\n' + expiry).encode('utf-8')
    signed_hmac_sha256 = hmac.HMAC(sas, string_to_sign, hashlib.sha256)
    signature = urllib.parse.quote(base64.b64encode(signed_hmac_sha256.digest()))
    return  {"sb_name": sb_name,
             "eh_name": eh_name,
             "token":'SharedAccessSignature sr={}&sig={}&se={}&skn={}' \
                     .format(uri, signature, expiry, sas_name)
            }



counter=0
class CallAPI(TaskSet):
    @task
    def my_task(self):

        print("executing my_task")
        token = get_auth_token(sb_name, eh_name, sas_name, sas_value)
        
        post_id = faker.random_int(min=1, max=10000000, step=1)
        data = {
            "postId": post_id,
            "name": faker.name(),
            "email": faker.email(),
            "body": faker.paragraph(100)
        }
    
        auth_val=get_auth_token(sb_name,eh_name,sas_name,sas_value)
        headers = {'Authorization': auth_val['token'],'Content-Type':'application/json','Accept':'application/json' }
        self.client.post(url_post, json=data,  headers=headers)
        counter=counter+1
        print(counter)

class User(HttpLocust):
    print("###################################")
    task_set = CallAPI
    wait_time = between(5, 15)
