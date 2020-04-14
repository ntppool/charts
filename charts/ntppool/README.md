# NTP Pool

This chart installs a test or development setup of the <a
href="https://www.ntppool.org/">NTP Pool</a> management system.

## Development environment

Run `helm install` with `--wait` so the [post-install hooks don't run
until](https://github.com/helm/helm/issues/3282) the development MySQL
installation is running.

    helm -n ntpdev install --wait ntppool -f dev-values.yaml ntppool/ntppool



## Overriding the image registry


image:
  repository: ...
  tag: ...

or

image:
  image: ...