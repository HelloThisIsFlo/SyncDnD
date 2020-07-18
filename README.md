# Sync DnD

Sync Do Not Disturb between the iPhone and the Mac.

## Usage

**Turn DnD ON**

1. Turn DnD ON on the iPhone
1. Done 😃 _DnD will automatically be turned on on the Mac_

**Turn DnD OFF**

1. Turn DnD OFF on the iPhone
1. Done 😃 _DnD will automatically be turned off on the Mac_


## Concept
- #### On the iPhone
  **2 Shortcuts**
    - **When DnD turned on:** Send request to `https://my_domain.com/dnd/on`
    - **When DnD turned off:** Send request to `https://my_domain.com/dnd/off`
- ### On the Cloud
  **1 MQTT**: With a `/dnd` topic.  
  **2 Webhook**:
    - `https://my_domain.com/dnd/on` => Send `ON` to the `/dnd` MQTT Topic
    - `https://my_domain.com/dnd/off` => Send `OFF` to the `/dnd` MQTT Topic

- ### On the Mac
  **1 Local Wrapper**: Listen to the `/dnd` MQTT Topic
    - On `ON` message, enable DnD with:
    ```bash
    defaults -currentHost write ~/Library/Preferences/ByHost/com.apple.notificationcenterui doNotDisturb -boolean true
    defaults -currentHost write ~/Library/Preferences/ByHost/com.apple.notificationcenterui doNotDisturbDate -date "`date -u +\"%Y-%m-%d %H:%M:%S +0000\"`"
    killall NotificationCenter
    ```
    
    - On `OFF` message, disable DnD with:
    ```bash
    defaults -currentHost write ~/Library/Preferences/ByHost/com.apple.notificationcenterui doNotDisturb -boolean false
    killall NotificationCenter
    ```

### In Picture

![Concept](https://raw.githubusercontent.com/FlorianKempenich/SyncDnD/master/README/Concept.png)


## Deployment

### Prerequisite
#### Configuration
Before doing any of the following steps, you must first create a `config.ENV` file at the root of the project, with the following content:
```bash
# Contents of './config.env'

MQTT_PORT=XXX # Port on which you'd like to run the MQTT instance
MQTT_PASS=XXX # Password to ensure secure connection to the MQTT instance
DOMAIN=XXX.com # Domain where the cloud part will be hosted
```
The `./config.env` file will be needed both on the machine running in the Cloud and on the Mac.

#### Dependencies
Required for both the server in the Cloud and the Mac
- Docker
- Docker Compose


### 1. iPhone
- **Shortcuts:** Create manually
  <p float="left">
    <img src="https://raw.githubusercontent.com/FlorianKempenich/SyncDnD/master/README/shortcut1.jpeg" width="250" />
    <img src="https://raw.githubusercontent.com/FlorianKempenich/SyncDnD/master/README/shortcut2.jpeg" width="250" /> 
    <img src="https://raw.githubusercontent.com/FlorianKempenich/SyncDnD/master/README/shortcut3.jpeg" width="250" />
  </p>

### 2. Cloud
**You must be on a server remotely accessible via the domain configured in `DOMAIN` when performing these steps**
- SSH in your server
- Checkout the project
- Create the [configuration file](#Configuration)
- [Generate a LetsEncrypt certificate with certbot](https://certbot.eff.org/instructions) for the domain configured in `DOMAIN`  
  _Certificates must be available at:_
  ```shell
  /etc/letsencrypt/live/DOMAIN/cert.pem
  /etc/letsencrypt/live/DOMAIN/chain.pem
  /etc/letsencrypt/live/DOMAIN/privkey.pem
  ```
- **Start the MQTT server with:** `./cloud/start_mqtt.sh`
- **Start the webhooks with:** `./cloud/start_webhooks.sh`

### 3. Mac
**This step should be performed on the Mac**
- Open a shell on your mac
- Checkout the project
- Create the [configuration file](#Configuration)
- **Start the local wrapper with:** `./mac/start_local_wrapper.sh`

### 4. Done 😃🎉
