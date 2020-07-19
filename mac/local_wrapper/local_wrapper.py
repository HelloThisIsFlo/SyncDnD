import logging
import sys
import os
import paho.mqtt.client as mqtt
from threading import Thread


TOPIC = 'dnd'
PORT = 6789  # TODO: Remove hardcoding
DOMAIN = 'floriankempenich.com'
USER = 'syncdnd'
PASS = 'pass'


def new_logger():
    logger = logging.getLogger()

    handler = logging.StreamHandler(sys.stdout)
    handler.setLevel(logging.INFO)
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    handler.setFormatter(formatter)

    logger.addHandler(handler)
    logger.setLevel(logging.INFO)
    return logger


class DnD:
    @staticmethod
    def turn_on():
        os.system(
            'defaults -currentHost write ~/Library/Preferences/ByHost/com.apple.notificationcenterui doNotDisturb -boolean true')
        os.system('defaults -currentHost write ~/Library/Preferences/ByHost/com.apple.notificationcenterui doNotDisturbDate -date "`date -u +\"%Y-%m-%d %H:%M:%S +0000\"`"')
        os.system('killall NotificationCenter')

    @staticmethod
    def turn_off():
        os.system('defaults -currentHost write ~/Library/Preferences/ByHost/com.apple.notificationcenterui doNotDisturb -boolean false')
        os.system('killall NotificationCenter')

class MQTTClient:
    def __init__(self, cmd_handler):
        self.cmd_handler = cmd_handler
        self.paho_client = mqtt.Client(client_id='DnD-Local-Wrapper')
        self.paho_client.on_connect = self._on_connect
        self.paho_client.on_message = self.on_message
        self.paho_client.tls_set(ca_certs='/etc/ssl/cert.pem')
        self.paho_client.username_pw_set(USER, PASS)

    def connect_and_start_listening(self):
        logger.info('Connecting to MQTT')
        self.paho_client.connect(host=DOMAIN, port=PORT)
        self.paho_client.loop_forever()

    @staticmethod
    def _on_connect(client, _userdata, _flags, _rc):
        logger.info('Connected to MQTT')
        client.subscribe(TOPIC)
        logger.info(f'Subscribed to {TOPIC}')

    def on_message(self, _client, _userdata, msg):
        command = msg.payload.decode()
        logger.info(f"Just received: '{command}' on '{msg.topic}'")
        self.cmd_handler(command)


def handle_cmd_from_mqtt(cmd):
    if cmd == 'ON':
        logger.info('Turning DnD ON')
        DnD.turn_on()
    elif cmd == 'OFF':
        logger.info('Turning DnD OFF')
        DnD.turn_off()
    else:
        logger.info(f"Unknown command '{cmd}' - IGNORING")


logger = new_logger()
logger.info("SyncDnD Local Wrapper is starting...")
mqtt_client = MQTTClient(cmd_handler=handle_cmd_from_mqtt)
mqtt_client.connect_and_start_listening()
