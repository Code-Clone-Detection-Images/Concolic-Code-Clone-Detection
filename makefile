.PHONY: build

#  --no-cache

build: Dockerfile setup-fedora.sh
	docker build --tag fedora-cccd --file Dockerfile .