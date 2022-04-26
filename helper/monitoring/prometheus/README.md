# Prometheus
Prometheus is a systems monitoring and alerting service that queries metrics endpoints and stores time series data. You can read more about Prometheus [here](https://prometheus.io/docs/introduction/overview/)

## Setup
1) Make a copy of the `prometheus_example.yml` file and name it `prometheus.yml`.
    ```
    cp prometheus_example.yml prometheus.yml
    ```
2) Change `harmony-node` job static config targets to the IP address of your Harmony Node:
    ```
    - job_name: "harmony-node"
        # metrics_path defaults to '/metrics'
        # scheme defaults to 'http'.
        static_configs:
        - targets: ["{your_node_ip}:9900", "{your_node_ip}:5000"]
    ```
3) Run `docker-compose up -d` to start your Prometheus and Grafana instance.

4) Test your Prometheus instance by following the steps in this [section](https://docs.harmony.one/home/network/validators/monitoring/prometheus-and-grafana#check-metrics-1) of the Harmony Prometheus setup docs.