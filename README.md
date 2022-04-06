

```
generate_conf:
    container_name: generate_conf
    build: ../../
    volumes:
      - ./:/harmony_node/config
    entrypoint: 
      - ./harmony
      - "config"
      - "dump"
      - "./config/harmony.conf"
```
# Prerequistes
- Docker
- Docker Compose
- 

# Setup
## Create BLS Keys:
1) Create a Docker volume to persist our BLS Keys:
    ```
    docker volume create blskeys
    ```
2) Start a bash session with a temporary container the harmony-node image so we can create BLS Keys and write them to our `blskeys` volume.
    ```
    docker run -rm -t -i -v blskeys:/harmony_node/.hmy/blskeys valyd8chain/harmony-node:latest /bin/bash
    ```

3) Now in container, either

    a) Follow the Harmony docs [steps for creating BLS keys](https://docs.harmony.one/home/network/validators/node-setup/generating-a-bls-key#configuring-the-bls-keys)

    b) Use the helper script provided with the image to create BLS Keys:
        ```
        ./create_bls_keys.sh
        ```

4) Type `exit` to exit the container.

5) Verify your blskeys have persistented in the `blskeys` volume by running the command in Step 2 again to create a new container with our `blskeys` volume. Once in the container, run `ls .hmy/blskeys/`. If you see your keys, everything is working as expected!

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
    1) `docker run -rm -t -i -v harmony_dbs:/harmony_node/dbs valyd8chain/harmony-node:latest /bin/bash`
    2) Now in the container run `ls dbs/`. You should see directories for each Harmony DB that you cloned.

## Generate Harmony Config File

