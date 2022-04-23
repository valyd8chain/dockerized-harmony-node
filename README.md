
# Table of Contents
1) [Intro](#Intro)
2) [Prerequistes](#Prerequistes)
3) [Setup](#Setup)
4) Maintenance and Updating
5) [Disclaimer](#Disclaimer)
6) [Support](#Support)

# <a name="Intro">Intro</a>
Running apps in containers with Docker is awesome. All the app's dependencies come with and are isolated to the container and don't clutter up or damage the host machine. This makes installing and deploying very easy, which is ideal for decentralized blockchain technology as it allows more people to run nodes which in turn increases decentralization. Harmony One is absolutely awesome blockchain. It's wicked fast and transactions are cheap.


But Harmony One doesn't have a Docker image for their nodes because of the worry about the extra overhead associated with running the node binary in Docker. But what would it take to get a node up and running and validating in Docker? Answering that question is the purpose of this repo. And spoiler alert, it can be done. Keep reading to find out how.

# <a name="Prerequistes">Prerequistes</a>
### Hardware
Harmony's current requirements for running without Docker are as follows:
- 8 core CPU
- 16GB memory
- 1TB storage (if using pruned DB0)

However since Docker adds some overhead, these requirements are not sufficient. We are still in the experimental phase to determine the minimum hardware requirements. The table below is hardware we have tried:

| Hardware    | Host OS    | CPU      | Number of Cores | RAM  | Hard Drive | Shard0 Stays Synced | Shard0 Stays Synced with Pruning |
| ----------- |------------| ---------|-----------------| ----- | -------------- | :-----------------: | :-------------------------: |
| 2020 Mac Mini M1 | MacOS Monterey      | Apple M1        | 8 cores  | 16GB | 1 TB Flash SSD | ❌     | ❌     |
| Custom Build     | Ubuntu 20.04 Server | AMD Ryzen 5900X | 12 cores | 32GB | 2 TB Samsung Evo 970 (M2 NVMe) | ✅   | ✅   |

If you have hardware you would like try and run a node in Docker on, let us know how it goes! And please submit a PR to add your hardware configuration to the table above!

### Software:
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

### Network:
- Ports 6000 and 9000 open on host machine
- Router Fowarding Ports 6000 and 9000 to host machine

# <a name="Setup">Setup</a>
Note: All `docker` commands may need to prefaced with `sudo` if you are not the `root` user depending on your host OS.

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

Get your existing `.hmy/blskeys` direcotry onto your host machine with `scp` or other method of your choosing and place it in a directory `temp`. Then start a bash session in a temporary container with the `harmony-node` image mounting the `blskys` volume and using a binding for your `temp` directory:
```
docker run --rm -t -i -v blskeys:/harmony_node/.hmy/blskeys -v /{PATH_TO}/temp:/harmony_node/temp valyd8chain/harmony-node:latest /bin/bash
```
Once in the container bash session, just copy the files over:
```
cp /harmony_node/temp/blskeys/* /harmony_node/.hmy/blskeys/
```
Exit your container and then start a new one with the same command above then in the container run `ls /harmony_node/.hmy/blskeys` to verify your files have persisted in the volume.

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

### Importing Existing Wallet
This is basically the same process as importing your BLS Keys. Get your existing `.hmycli` direcotry onto your host machine with `scp` or other method of your choosing and place it in a directory `temp`. Then start a bash session in a temporary container with `harmony-node` image mounting the `hmycli` volume and using a binding for your `temp` directory:
```
docker run --rm -t -i -v hmycli:/root/.hmy_cli -v /{PATH_TO}/temp:/harmony_node/temp valyd8chain/harmony-node:latest /bin/bash
```
Once in the container bash session, just copy the files over:
```
cp -r /harmony_node/temp/.hmycli/* /root/.hmy_cli/
```
Exit your container and then start a new one with the same command above then in the container run `ls /root/.hmy_cli` to verify your files have persisted in the volume.

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

I don't consider myself a Docker pro by any means, so if you have ideas to better this project, please feel free to reach out and/or submit a issue or PR!

# <a name="Support">Support</a>
If you would like to support this project, there's a few things you can do:
1) Delegate to our Harmony ONE Validator [here](https://staking.harmony.one/validators/mainnet/one1f4ss7ekhd0jupg5w78s333ejw3ugrrumpjw6ja). Our validator node runs in Docker using this repository, so staking with us supports our validator node and thus supports this project.
2) Contribute your knowledge to this project by opening issues and pull requests to make it better

