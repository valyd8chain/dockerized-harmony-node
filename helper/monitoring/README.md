# Monitoring Your Node
Monitoring your node is easy with Docker and the Prometheus, Node Exporter, and Grafana Docker Images.

There are 3 different tools to monitor your node.
1) [Prometheus](./prometheus/README.md)
2) [Node Exporter](./node-exporter/README.md)
3) [Grafana](./grafana/README.md)

How you configure the 3 will depend a lot on your individual setup. For example, you could run your Harmony Node, Prometheus, Node Exporter and Grafana all on the same machine. Or you could have just your Harmony Node and Node Exporter on one machine, then Prometheus and Grafana on a different one. Since these setups can really vary, we have provided 3 separate `docker-compose-example.yml` files for each service. Any of them will work as is after you run 
```
cp docker-compose-example.yml docker-compose.yml
```

You also combine the contents of these 3 example files as needed for your situation.

If you are running these across multiple machines and the machines are not on the same local network, make sure set up your firewall accordingly and only allow connections from your IP addresses on the needed ports. That way, no one on the internet can scrape your node metrics data and/or potentially DDOS your node.

