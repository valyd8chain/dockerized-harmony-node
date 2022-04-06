

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

# Setup

### Dump a Harmony config file
With Docker CLI: `docker run --rm rclone/rclone:latest version`
`docker run --rm valyd8chain/harmony-node:latest 

`docker volume create harmony_dbs`

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

1) Create a Docker volume for our Harmony DBs:
    ```
    docker volume create harmony_dbs
    ```

2) Pull the RClone Docker Image
    ```
    docker pull rclone/rclone:latest
    ```

3) 