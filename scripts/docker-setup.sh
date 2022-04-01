#!/bin/bash

docker_install() {
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  sudo curl -L "https://github.com/docker/compose/releases/download/1.28.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
}

docker_hub_push() {
  if [[ "${PWD##*/}" == "bitcoin-computer-node" ]]
  then
    docker tag bitcoin-computer-node-secret:latest $(grep DOCKER_ID .docker.config | cut -d '=' -f2)/bitcoin-computer-node-secret:$(grep IMAGE_VERSION .docker.config | cut -d '=' -f2)
    docker login -u $(grep DOCKER_ID .docker.config | cut -d '=' -f2) -p $(grep DOCKER_PASSWORD .docker.config | cut -d '=' -f2)
    docker push $(grep DOCKER_ID .docker.config | cut -d '=' -f2)/bitcoin-computer-node-secret:$(grep IMAGE_VERSION .docker.config | cut -d '=' -f2)
  else
    echo "Present directory is not bitcoin-computer-node"
  fi
}

docker_volume_remove_aws() {
  CONTEXT_TYPE=$(docker context ls | grep '*' | awk '{print $3}')
  CONTEXT_NAME=$(docker context ls | grep '*' | awk '{print $1}')
  echo "Using context name '$CONTEXT_NAME', context type '$CONTEXT_TYPE'."
  if [[ $CONTEXT_TYPE == "ecs" ]]; then
    if [[ $# -le 0 ]]; then
      echo "Error: volume id needed. Usage: 'yarn docker-volume-rm-aws <fs_id>'"
      exit 1
    else
      read -p "[!] Using context '$CONTEXT_NAME'. Removing volume '$1' Continue? (Y/N): " prompt
      if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]] ;
      then

        . ./scripts/aws-config.sh && aws_secret_export
        docker volume rm $1
      fi
    fi
  else
    echo "Error: the current context is not an ecs-type one."
    echo "Please, switch to the ecs context: list the contexts running 'docker context ls'. Pick the ecs-type context name. Run: 'yarn docker-context-use <ecs-context-name>'"
  fi

}

docker_volume_remove_local() {
  CONTEXT_NAME=$(docker context ls | grep '*' | awk '{print $1}')
  CONTEXT_TYPE=$(docker context ls | grep '*' | awk '{print $3}')
  echo "Using context name '$CONTEXT_NAME', context type '$CONTEXT_TYPE'."
  if [[ "$CONTEXT_NAME" == "default" ]]; then
    docker volume rm $(docker volume ls -q)
  else
    echo "Error: Using context other than default (context name '$CONTEXT_NAME', context type '$CONTEXT_TYPE'). Removing all the volumes can be dangerous."
    echo "Please, switch to the default context running: 'docker context use default'."
    exit 1
  fi
}
