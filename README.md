
# Table of Contents
1) [Intro](#Intro)
1) [Prerequistes](#Prerequistes)
2) [Setup](#Setup)
3) Maintenance and Updating
4) [Disclaimer](#Disclaimer)

# <a name="Intro">Intro</a>


# <a name="Prerequistes">Prerequistes</a>
### Hardware
Harmony's current requirements for running without Docker are as follows:
- 8 core CPU
- 16GB memory
- 1TB storage (if using pruned DB0)

It is uncertain how the requirements will change from using this repo and running node in Docker.

### Software:
- Docker
- Docker Compose

### Network:
- Ports 6000 and 9000 open on host machine
- Router Fowarding Ports 6000 and 9000 to host machine

# <a name="Setup">Setup</a>
## BLS Keys:

### Creating BLS Keys
1) Create a Docker volume to persist our BLS Keys:
    ```
    docker volume create blskeys
    ```
2) Start a bash session with a temporary container the harmony-node image so we can create BLS Keys and write them to our `blskeys` volume.
    ```
    docker run --rm -t -i -v blskeys:/harmony_node/.hmy/blskeys valyd8chain/harmony-node:latest /bin/bash
    ```

3) Now in container, either

    a) Follow the Harmony docs [steps for creating BLS keys](https://docs.harmony.one/home/network/validators/node-setup/generating-a-bls-key#configuring-the-bls-keys)

    b) Use the helper script provided with the image to create BLS Keys:
        ```
        ./create_bls_keys.sh
        ```

4) Type `exit` to exit the container.

5) Verify your blskeys have persistented in the `blskeys` volume by running the command in Step 2 again to create a new container with our `blskeys` volume. Once in the container, run `ls .hmy/blskeys/`. If you see your keys, everything is working as expected!

### Import Existing BLSKeys

TODO

## Clone Harmony DB:

### RClone Setup

1) Create a Docker volume for our Harmony DBs:
    ```
    docker volume create harmony_dbs
    ```

2) Pull the RClone Docker Image
    ```
    docker pull rclone/rclone:latest
    ```

3) Check that your RClone version is at least v1.53.2 per Harmony team [requirements](https://docs.harmony.one/home/network/validators/node-setup/syncing-db#1.-installing-rclone):
    - With Docker CLI:
        ```
        docker run --rm rclone/rclone version
        ```
    - With Docker Compose:
        ```
        cd helper/rclone
        docker-compose run --rm list_remotes
        ```


4) Verify RClone Configuration:
     - We've provided a precreated `rclone.conf` file in `helper/rclone/rclone.conf`.
        - The file should work as is, but if you need/want to make changes, feel free to edit it or generate a new one via Harmony's validator setup [guide](https://docs.harmony.one/home/network/validators/node-setup/syncing-db#2.-configuring-rclone)

    - Test to make sure your config file is setup properly:
        - With Docker Compose: 
            ```
            cd helper/rclone
            docker-compose run --rm list_remotes
            ```
        - With Docker CLI: 
            ```
            docker run --rm \
                --volume {PATH_TO}/helper/rclone/config:/config/rclone \
                --volume harmony_dbs:/data \
                rclone/rclone \
                listremotes
            ```

### Clone Harmony DBs
1) `cd helper/rclone`
2) Create your `.env` file from the `.env_example` file provided: `cp .env_example .env`
3) Edit your `.env` file to your desired Shard and network.
4) Clone the Harmony DB:
    - With Docker Compose: `docker-compose run --rm clone_harmony_db`
    - With Docker CLI: Docker Compose is easier just do that, trust me
5) Repeat Steps 3-4 for any additional Harmony DBs needed
6) Verify your `harmony_dbs` volume has persisted by running another bash session in temporary container from the `harmony-node` image.
    1) `docker run --rm -t -i -v harmony_dbs:/harmony_node/dbs valyd8chain/harmony-node:latest /bin/bash`
    2) Now in the container run `ls dbs/`. You should see directories for each Harmony DB that you cloned.

## Harmony Config File

### Generate Config File

First, create a directory to hold the config file: `mkdir config`

From here, there are 2 ways to generate the config file:

- Option A: Via Helper Docker Compose (easy way)
    1) Edit the `NETWORK` environment variable in `helper/harmony/.env` to your desired network
    2) `cd helper/harmony && docker-compose run --rm generate_conf && cd ../..`

- Option B. Via Temp Container Bash Session:
    1) Bind the config directory and start another temporary container bash session:
        ```
        docker run --rm -t -i -v {PATH_TO}/config:/harmony_node/config valyd8chain/harmony-node:latest /bin/bash`
        ```
    2) Dump a config into the binded config folder:
        ```
        ./harmony config dump --network {mainnet OR testnet} ./config/harmony.conf
        ```
    4) Exit the container with `exit`

Now just `ls config` and you should see your `harmony.conf` file.

### Edit the Config File

There is one required change the config file to get it working with our Docker setup:
1) Change the `DataDir` field to the `dbs` folder:
    ```
    [General]
    DataDir = "./dbs"
    ```

You can now make any additional changes to the config file relevant to your node such turning pruning on/off.

## Create the hmycli volume:
The `hmy` CLI will store your wallet keys in `/root/.hmy_cli` within the container. You probably don't want to lose those so let's create a volume for them:
```
docker volume create hmycli
```

## Create the Logging Volume (optional but recommended)
**Important**: If you skip this step, comment out the lines relevant to `harmony_logs` in `docker-compose.yml` when running your node

If you want your log files to persist across restarts and rebuilds, you will need to create another Docker volume to store them.

- `docker volume create harmony_logs`


## Running the Validator Node
if you have done everything correctly up to this point, then this is the easiest step:
```
docker-compose up -d
```

## Checking Your Node
Once you have your node container up and running, you can check on how things are working with `docker exec -it validator_node bin/bash`

# <a name="Disclaimer">Disclaimer</a>
Use this at your own risk! This project is a proof of concept and experiment. The Harmony Team does not recommend running containerized nodes on their network due to the additional computational overhead. Your node may underperform, lose blocks, or fall of of sync if you use this without sufficient hardware.
