.PHONY: test

PUSH=helm cm-push --debug

.PHONY: publish
publish:
	@echo run helm push
	@helm plugin install https://github.com/chartmuseum/helm-push.git
	helm --username "$$HELM_USERNAME" --password="$$HELM_PASSWORD" repo add ntppool ${HELM_URL}
	helm repo update
	${PUSH} charts/splash  ntppool
	${PUSH} charts/ntppool ntppool
