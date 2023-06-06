.PHONY: publish
publish:
	./publish.pl

sign:
	drone sign --save ntppool/charts

.PHONY:
