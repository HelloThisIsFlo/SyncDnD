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
![Concept](https://raw.githubusercontent.com/FlorianKempenich/SyncDnD/master/README/Concept.png)

- ### On the iPhone
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



## Installation

### Prerequisite
#### Configuration
Before doing any of the following steps, you must first create a `config.ENV` file at the root of the project, with the following content:
```bash
# Contents of './config.env'

MQTT_PORT=XXX     # Port on which you'd like to run the MQTT instance
MQTT_PASS=XXX     # A password to ensure secure connection to the MQTT instance
DOMAIN=XXX.com    # Domain where the cloud part will be hosted
WEBHOOKS_PORT=XXX # Post on which you'd like to run the webhooks
```
The `./config.env` file will be needed both on the machine running in the Cloud and on the Mac.

#### Dependencies
Required for both the server in the Cloud and the Mac
- Docker
- Docker Compose


### 1. iPhone
- **Shortcuts:** Create manually. Use the following urls:
    - `http://DOMAIN:WEBHOOKS_PORT/dnd/on`
    - `http://DOMAIN:WEBHOOKS_PORT/dnd/off`

  <p float="left">
    <img src="https://raw.githubusercontent.com/FlorianKempenich/SyncDnD/master/README/shortcut1.jpeg" width="250" />
    <img src="https://raw.githubusercontent.com/FlorianKempenich/SyncDnD/master/README/shortcut2.jpeg" width="250" /> 
    <img src="https://raw.githubusercontent.com/FlorianKempenich/SyncDnD/master/README/shortcut3.jpeg" width="250" />
  </p>

### 2. Cloud
**The following steps must be performed on a server remotely accessible via the domain configured in `DOMAIN`**
1. SSH in your server
1. Checkout the project
1. Create the [configuration file](#Configuration)
1. [Generate a LetsEncrypt certificate with certbot](https://certbot.eff.org/instructions) for the domain configured in `DOMAIN`  
   _Certificates must be available at:_
   ```shell
   /etc/letsencrypt/live/DOMAIN/cert.pem
   /etc/letsencrypt/live/DOMAIN/chain.pem
   /etc/letsencrypt/live/DOMAIN/privkey.pem
   ```
1. **Start the MQTT and the Webhooks with:** `./cloud/start_cloud.sh`

### 3. Mac
**The following steps should be performed on the Mac**
1. Open a shell on your mac
1. Checkout the project
1. Create the [configuration file](#Configuration)
1. **Start the local wrapper with:** `./mac/install_local_wrapper.sh`

### 4. Done 😃🎉


## Uninstallation
1. **iPhone:** Remove the shortcuts
2. **Cloud:** Run `./cloud/stop_cloud.sh`
3. **Mac:** Run `./mac/uninstall_local_wrapper.sh`