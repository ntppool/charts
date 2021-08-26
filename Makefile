.PHONY: test

PUSH=helm push --username "$$HELM_USERNAME" --password="$$HELM_PASSWORD" --dependency-update --debug 

.PHONY: publish
publish:
	@echo run helm push
	@helm plugin install https://github.com/chartmuseum/helm-push.git
	helm repo add ntppool ${HELM_URL}
	${PUSH} charts/splash  ntppool
	${PUSH} charts/ntppool ntppool
