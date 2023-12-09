.PHONY: fastly publish

publish:
	./publish.pl

fastly:
	@which fastly >& /dev/null || make fastly-install

# linux only; use homebrew for macos
fastly-install:
	mkdir -p /usr/local/bin
	curl -sLfo- https://github.com/fastly/cli/releases/download/v10.7.0/fastly_v10.7.0_linux-amd64.tar.gz | tar -C /usr/local/bin -xzf -

sign:
	drone sign --save ntppool/charts

.PHONY:
