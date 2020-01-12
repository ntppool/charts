build:
	helm package charts/* --destination .deploy	

push:
	cr upload --config config.yaml

index:
	git checkout gh-pages
	cr index -i ./index.yaml --config ./config.yaml
