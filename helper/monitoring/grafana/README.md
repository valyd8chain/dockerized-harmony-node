# Grafana
Grafana is a great tool for data visualization of your Prometheus metrics. To learn more about Grafana, check out their [documentation](https://grafana.com/docs/grafana/latest/introduction/)

## Setup
1) Make a copy of the example file:
    ```
    cp docker-compose-example.yml docker-compose.yml
    ```
2) Start Grafana
    ```
    docker-compose up -d
    ```
3) Add Prometheus as a Data Source
    - Go to `http://{YOUR_GRAFANA_IP:3000}/datasources` and add your Prometheus instance as a data source.

4) Add some Dashboards! Here are a couple that I am using:
    - [Harmony Node Dashboard](https://docs.harmony.one/home/network/validators/monitoring/prometheus-and-grafana#add-prometheus-datasource)
    - [Node Exporter Full Dashboard](https://grafana.com/grafana/dashboards/1860)
    - Have a dashboard you really like using to monitor your node? Create a PR and add it to this list!