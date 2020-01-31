# dnsdist for kubernetes

This chart helps configure dnsdist to run under Kubernetes.

## Example config

The following `values.yaml` override will setup a basic DOH server forwarding
requests to Google DNS and Quad9.

    config:
      dnsdist.conf: |
        addDOHLocal("0.0.0.0:8053", nil, nil, "/dns-query", { reusePort=true })
        newServer({address="8.8.8.8:53", qps=10})
        newServer({address="9.9.9.11:53", qps=100})
        setServerPolicy(firstAvailable)
        webserver("0.0.0.0:8083", "secret", "secret")
        addLocal("0.0.0.0:5300", { reusePort=true })

    healthCheckHeaders: {}
    - name: Authorization
      value: Basic aGVsbG86c2VjcmV0

Add an `ingress:` key to enable an ingress for the service (see values.yaml).

## TODO

- Support non-DOH use-cases
- UDP service
