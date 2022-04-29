# Node Exporter
Node Exporter is built by the Prometheus team and exposes a wide variety of hardware and kernel-related metrics. Node Exporter only works on Unix based systems (Ubuntu, MacOS). If you run on Windows, the Prometheus team also has made Windows Exporter.

Node Exporter should run on whatever machine you want to monitor the hardware of. In the context of this repo, that means the same machine your Harmony Node is running on.

If you've cloned this repo on your machine to run your Harmony node, starting up Node Exporter is as simple as running `cd helper/monitoring/node-exporter` and then:

```
cp docker-compose-example.yml docker-compose.yml
docker-compose up -d
```

If you are not running Prometheus on the same machine as your node, be sure to make sure you have opened port 9100 so Prometheus can scrape Node Exporter's data. If your two machines are not on the same local network, be sure to restrict the IP addresses that can access port 9100.

If you configure Grafana with the Node Exporter Dashboard, you get a nice view like this:
![Screen Shot 2022-04-29 at 8 55 04 AM](https://user-images.githubusercontent.com/92071766/165986915-a6c5d551-35fb-4a03-8bae-5f5ffd1a13ad.png)
