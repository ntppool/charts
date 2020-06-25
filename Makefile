.PHONY: test

.PHONY: publish
publish:
	@echo run helm push
	@helm plugin install https://github.com/chartmuseum/helm-push.git
	helm repo add ntppool ${HELM_URL}
	helm push --username "$$HELM_USERNAME" --password="$$HELM_PASSWORD" --dependency-update --debug charts/ntppool ntppool
