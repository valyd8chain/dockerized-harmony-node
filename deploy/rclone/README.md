## RClone Setup
1) Pull the RClone Docker Image:
    ```
    docker pull rclone/rclone:latest
    ```
2) Verify RClone is install correctly:
    - With Docker Compose: `docker-compose run --rm get_version`
    - With Docker CLI: `docker run --rm rclone/rclone:latest version`

3) Create the data directory: `mkdir ./data`

4) Verify RClone Config
    - The `rclone.conf` file is already created in `./config`. You can edit it or generate a new one via Harmony's validator setup [guide](https://docs.harmony.one/home/network/validators/node-setup/syncing-db#2.-configuring-rclone)
    - Test to make sure your config file is setup properly:
        - With Docker Compose: `docker-compose run --rm list_remotes`
        - With Docker CLI: 
            ```
            docker run --rm \
                --volume {PATH_TO}/harmony_node/deploy/rclone/config:/config/rclone \
                --volume {PATH_TO}/harmony_node/deploy/rclone/data:/data:shared \
                rclone/rclone \
                listremotes
            ```

## Cloning the Harmony DB
1) Create your `.env` file from the `.env_example` file provided: `cp .env_example .env`
2) Edit your `.env` file to your desired Shard and network.
3) Clone the Harmony DB:
    - With Docker Compose: `docker-compose run --rm clone_harmony_db`
    - WIth Docker CLI: Compose is easier just do that trust me
4) Repeat Steps 2-3 for any additional Harmony DBs needed