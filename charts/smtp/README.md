# smtp

This chart installs an [smtp daemon](https://gitlab.com/egos-tech/smtp) in
kubernetes to work as a mail relay.

The recommended approach is to configure it with authentication to a
mail service and then from other applications within the cluster (or
namespace) send mail to this relay.

## Configuration

Add a `config:` key to your values.yaml override (or helm `--set` parameters) with the necessary values (without the # prefix for the
values you set):

```yml
config:
  # See documentation at https://gitlab.com/egos-tech/smtp#smtp
  #SMARTHOST_ADDRESS: mail.example.com
  #SMARTHOST_PORT: "587"
  #SMARTHOST_USER: myuser
  #SMARTHOST_PASSWORD: secret
  #SMARTHOST_ALIASES: "*.example.com"

  # colon separated, must start with : !
  RELAY_NETWORKS: :10.42.0.0/16

```

One quirk is that for authentication to work, the name of the mail
server in SMARTHOST_ADDRESS has to be covered/included in the
SMARTHOST_ALIASES setting.

You can also use Gmail or Amazon SES with just a couple of
configuration values as described in the
[egos-tech/smtp](https://gitlab.com/egos-tech/smtp#smtp) documentation.
