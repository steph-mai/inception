name        = inception
COMPOSE_FILE = srcs/docker-compose.yml
DOCKER      = /usr/bin/docker

all:
	@mkdir -p /home/stmaire/data/wordpress
	@mkdir -p /home/stmaire/data/mariadb
	${DOCKER} compose -f ${COMPOSE_FILE} up --build -d

down:
	${DOCKER} compose -f ${COMPOSE_FILE} down

up:
	${DOCKER} compose -f ${COMPOSE_FILE} up -d

clean:
	${DOCKER} compose -f ${COMPOSE_FILE} down --rmi all -v

fclean: clean
	sudo rm -rf /home/stmaire/data/wordpress/*
	sudo rm -rf /home/stmaire/data/mariadb/*

re: fclean all

psa:
	${DOCKER} ps -a

logs:
	${DOCKER} compose -f ${COMPOSE_FILE} logs -f

logs-%:
	${DOCKER} compose -f ${COMPOSE_FILE} logs -f $*

in-%:
	${DOCKER} exec -it $* bash

upgrade:
	apt update && apt upgrade

.PHONY: all down up clean fclean re psa logs logs-% in-% upgrade
