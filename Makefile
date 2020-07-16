all: compile

compile:
	docker-compose up

run:
	docker-compose run filebrowser ghci

clean:
	yes | docker container prune --filter "label=group=file"

reset:
	yes | docker container prune --filter "label=group=file"
	yes | docker image prune --filter "label=group=file"
	docker image rm --force haskell:8.6.5
	docker image rm --force file:1.0
	docker-compose up --build