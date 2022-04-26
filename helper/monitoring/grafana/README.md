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

3) Grafana needs to be configured once up and running. To do this, follow the steps [here](https://docs.harmony.one/home/network/validators/monitoring/prometheus-and-grafana#add-prometheus-datasource) from the Harmony Grafana setup docs.

4) Add any additional charts and metrics as you see fit!