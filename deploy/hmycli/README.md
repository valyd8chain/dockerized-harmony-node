## HMYCLI

### Node Setup
1) Generate BLS Keys:
    - With Docker Compose: `docker-compose run --rm create_bls_key`
        - When prompted for blskey filepath, enter `/harmony_node/.hmy/blskeys/{your-bls-key-name}.key
            - We recommend a naming convention such as `shard1_key1.key` so your keys are easier to manage.
        - After the command successfully runs, you still need to create your password file for your new BLS key:
            ```
            echo '[replace_with_your_passphrase]' > .hmy/blskeys/[replace_with_BLS_without_.key].pass
            ```
