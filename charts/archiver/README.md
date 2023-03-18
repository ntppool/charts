# ntppool archiver

Archiver tool for NTP Pool monitoring data

## Source Code

* <https://github.com/ntppool/archiver>

## Requirements

Kubernetes: `>=1.16.0-0`

## Dependencies
## TL;DR

```console
helm repo add ntppool https://chart.ntppool.org/
helm repo update
helm install archiver ntppool/archiver
```


## Configuration

Read through the [values.yaml](./values.yaml) file. It has several commented out suggested values.


```console
helm install archiver \
  --set env.TZ="America/New York" \
    ntppool/archiver
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart.

```console
helm install archiver ntppool/archiver -f values.yaml
```
