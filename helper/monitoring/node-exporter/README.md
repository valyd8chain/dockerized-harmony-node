# Node Exporter
Node Exporter is built by the Prometheus team and exposes a wide variety of hardware and kernel-related metrics. Node Exporter only works on Unix based systems (Ubuntu, MacOS). If you run on Windows, the Prometheus team also has made Windows Exporter.

Node Exporter should run on whatever machine you want to monitor the hardware of. In the context of this repo, that means the same machine your Harmony Node is running on.

If you've cloned this repo on your machine to run your Harmony node, starting up Node Exporter is as simple as running `cd helper/monitoring/node-exporter` and then:

```
cp docker-compose-example.yml docker-compose.yml
docker-compose up -d
```

If you are not running Prometheus on the same machine as your node, be sure to make sure you have opened port 9100 so Prometheus can scrape Node Exporter's data. If your two machines are not on the same local network, be sure to restrict the IP addresses that can access port 9100.