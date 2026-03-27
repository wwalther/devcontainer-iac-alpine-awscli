.PHONY: all
all: build test

.PHONY: build
build:
	docker build . --file Dockerfile --tag devcontainer-iac-alpine-awscli:local $(shell cat Dockerfile.args | xargs -I {} echo --build-arg {})

.PHONY: lint
lint:
	@tools/lint.sh

.PHONY: test
test:
	docker run --rm --interactive devcontainer-iac-alpine-awscli:local --version

.PHONY: versioncheck-awscli
versioncheck-awscli:
	@curl -s "https://api.github.com/repos/aws/aws-cli/tags?per_page=100" | jq -r '[.[] | select(.name | test("^2[.][0-9]+[.][0-9]+$$"))][0].name'
