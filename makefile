.PHONY: build save

NAME:=fedora-cccd

#  --no-cache
build: Dockerfile offline/ scripts/ data/ testing/
	docker build --tag "$(NAME)" --file Dockerfile .

# https://docs.docker.com/engine/reference/commandline/save/
save: build
	@echo "saving (this may take some time)"
	docker save "$(NAME):latest" | gzip > "$(NAME).tar.gz"
	@echo "saved to: \"$(NAME).tar.gz\""