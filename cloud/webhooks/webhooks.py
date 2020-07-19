import paho.mqtt.client as mqtt
from flask import Flask
import json


def load_config():
    with open('./config.json') as config_file:
        return json.loads(config_file.read())

class MQTTClient:
    def __init__(self):
        self.paho_client = mqtt.Client(client_id='DnD-Webhooks')
        self.paho_client.on_connect = self._on_connect
        self.paho_client.tls_set()
        self.paho_client.username_pw_set(
            config['mqtt']['user'], config['mqtt']['pass'])

    def connect(self):
        print('Connecting to MQTT')
        self.paho_client.connect(
            host=config['mqtt']['domain'], 
            port=config['mqtt']['port'])
        self.paho_client.loop_start()

    @staticmethod
    def _on_connect(client, _userdata, _flags, _rc):
        logger.info('Connected to MQTT')

    def send_ON(self):
        self._send_msg('ON')

    def send_OFF(self):
        self._send_msg('OFF')

    def _send_msg(self, msg):
        self.paho_client.publish(config['mqtt']['topic'], msg)



config = load_config()
app = Flask(__name__)
mqtt_client = MQTTClient()
mqtt_client.connect()

@app.route('/dnd/on', methods=['POST'])
def dnd_turn_on():
    mqtt_client.send_ON()
    return 'DnD turned ON'

@app.route('/dnd/off', methods=['POST'])
def dnd_turn_off():
    mqtt_client.send_OFF()
    return 'DnD turned OFF'
