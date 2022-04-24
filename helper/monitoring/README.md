# Monitoring Your Node

Monitoring your node is easy with Docker and the Prometheus and Grafana Docker Images.

## Setup
#### **Preface:** 
This guide assumes you are running your Prometheus and Grafana Docker containers on the same local network as your Harmony node. If this is not your case, you will need to do addtional setup with your node's firewall to open the ports 5000 and 9900 to make them accessible. You will also want to your node only allow connections from your Prometheus host machine's IP address on those ports. That way, no one on the interent can scrape your node metrics data and potentially DDOS your node. If you have gone through this process, please consider submitting a PR with the steps to take to improve this guide.

### Prometheus
1) Make a copy of the `prometheus_example.yml` file and name it `prometheus.yml`.
    ```
    cp prometheus_example.yml prometheus.yml
    ```
2) Then change `harmony-node` job static config targets to the IP address of your Harmony Node:
    ```
    - job_name: "harmony-node"
        # metrics_path defaults to '/metrics'
        # scheme defaults to 'http'.
        static_configs:
        - targets: ["{your_node_ip}:9900", "{your_node_ip}:5000"]
    ```
3) Run `docker-compose up -d` to start your Prometheus and Grafana instance.

4) Test your Prometheus instance by following the steps in this [section](https://docs.harmony.one/home/network/validators/monitoring/prometheus-and-grafana#check-metrics-1) of the Harmony Prometheus setup docs.


### Grafana
1) Grafana needs to be configured once up and running. To do this, follow the steps [here](https://docs.harmony.one/home/network/validators/monitoring/prometheus-and-grafana#add-prometheus-datasource) from the Harmony Grafana setup docs.

2) Add any additional charts and metrics as you see fit!

