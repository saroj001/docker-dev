#!/bin/bash
\

# Check if docker is installed
which docker
if [ $? -eq 0 ]
then
    docker --version | grep "Docker version"
    if [ $? -eq 0 ]
    then
        echo "Great !! Docker is installed."
    else
        echo "Oops!, please install docker before proceeding."
    fi
else
    echo "Oops!, please install docker before proceeding." >&2
fi

echo "Please stop nginx, apache, mysql services running on your system"

echo Please give the full path where you want to clone all the projects.
read fullpath

sudo mkdir -p $fullpath
chown -R $(whoami):$(whoami) $fullpath
cd $fullpath

if [ ! "$(docker network ls | grep prios)" ]; then
  echo "Creating prios docker network ..."
  docker network create prios
else
  echo "docker prios network exists."
fi

if [ ! "$(docker volume ls | grep prios)" ]; then
  echo "Creating prios docker volume ..."
  docker volume create prios
else
  echo "docker prios volume exists."
fi

sudo usermod -aG docker $USER

for repo in $git_repos
do
	cd services	
	sudo docker-compose up -d
done
