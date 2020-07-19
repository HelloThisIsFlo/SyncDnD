import os
import paho.mqtt.client as mqtt


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


TOPIC = 'dnd'
PORT = 6789  # TODO: Remove hardcoding
DOMAIN = 'floriankempenich.com'
USER = 'syncdnd'
PASS = 'pass'


class MQTTClient:
    def __init__(self, cmd_handler):
        self.cmd_handler = cmd_handler
        self.paho_client = mqtt.Client(client_id='DnD-Local-Wrapper')
        self.paho_client.on_connect = self._on_connect
        self.paho_client.on_message = self.on_message
        self.paho_client.tls_set(ca_certs='/etc/ssl/cert.pem')
        self.paho_client.username_pw_set(USER, PASS)

    def connect_and_start_listening(self):
        self.paho_client.connect(host=DOMAIN, port=PORT)
        self.paho_client.loop_forever()

    @staticmethod
    def _on_connect(client, _userdata, _flags, _rc):
        print('Connected to MQTT')
        client.subscribe(TOPIC)
        print(f'Subscribed to {TOPIC}')

    def on_message(self, _client, _userdata, msg):
        command = msg.payload.decode()
        print(f"Just received: '{command}' on '{msg.topic}'")
        self.cmd_handler(command)


def sandbox():
    def on_connect(client, _userdata, _flags, _rc):
        print('Connected to MQTT')
        client.subscribe(TOPIC)
        print(f'Subscribed to {TOPIC}')

    def on_message(_client, _userdata, msg):
        command = msg.payload.decode()
        print(f"Just received: '{command}' on '{msg.topic}'")

    paho_client = mqtt.Client(client_id='DnD-Local-Wrapper')
    paho_client.on_connect = on_connect
    paho_client.on_message = on_message
    paho_client.tls_set(ca_certs='/etc/ssl/cert.pem')
    paho_client.username_pw_set(USER, PASS)

    paho_client.connect(host=DOMAIN, port=PORT)
    paho_client.loop_forever()


def handle_cmd_from_mqtt(cmd):
    if cmd == 'ON':
        print('Turning DnD ON')
        DnD.turn_on()
    elif cmd == 'OFF':
        print('Turning DnD OFF')
        DnD.turn_off()
    else:
        print(f"Unknown command '{cmd}' - IGNORING")


# mqtt_client = MQTTClient(cmd_handler=handle_cmd_from_mqtt)
# mqtt_client.connect_and_start_listening()

def debug_daemon():
    from datetime import datetime

    def timestamp():
        now = datetime.now()
        return now.strftime("[%H:%M:%S]")

    print(timestamp() + " <== There should be a 20 sec interval between 2 lines")
    print(os.system('pwd'))
    print(os.system('ls -la'))

    print('turning on dnd')
    os.system(
        'defaults -currentHost write ~/Library/Preferences/ByHost/com.apple.notificationcenterui doNotDisturb -boolean true')
    os.system('defaults -currentHost write ~/Library/Preferences/ByHost/com.apple.notificationcenterui doNotDisturbDate -date "`date -u +\"%Y-%m-%d %H:%M:%S +0000\"`"')
    os.system('killall NotificationCenter')


debug_daemon()
