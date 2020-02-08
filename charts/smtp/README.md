# smtp

This chart installs [namshi/smtp](https://hub.docker.com/r/namshi/smtp/) in kubernetes to work as a mail relay.

The recommended approach is to configure it with authentication
to a mail service and then from other applications within the cluster (or namespace) send mail to this relay.

## Configuration

Add a `config:` key to your values.yaml override (or helm `--set` parameters) with the necessary values (without the # prefix for the
values you set):

```
config:
  #SMARTHOST_ADDRESS: mail.example.com
  #SMARTHOST_PORT: "587"
  #SMARTHOST_USER: myuser
  #SMARTHOST_PASSWORD: secret
  #SMARTHOST_ALIASES: "*.example.com"
```

One quirk is that for authentication to work, the name of the mail
server in SMARTHOST_ADDRESS has to be covered/included in the SMARTHOST_ALIASES setting.

You can also use Gmail or Amazon SES with less configuration using the
configuration values documented in [namshi/smtp](https://hub.docker.com/r/namshi/smtp/).
