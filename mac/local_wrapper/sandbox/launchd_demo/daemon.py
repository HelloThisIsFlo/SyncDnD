from datetime import datetime

# POC to make sure it it using the correct installation
# of python 😃
import paho.mqtt.client as mqtt

def timestamp():
    now = datetime.now()
    return now.strftime("[%H:%M:%S]")


print(timestamp() + " <== There should be a 20 sec interval between 2 lines");