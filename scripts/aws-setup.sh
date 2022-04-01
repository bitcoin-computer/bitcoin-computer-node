#!/bin/bash

# Re-tags an image from CURRENT_TAG to NEW_TAG in REPOSITORY
aws_tag() {
  CURRENT_TAG=$1
  REPOSITORY=$2
  NEW_TAG=$3
  MANIFEST=$(aws ecr batch-get-image --repository-name $REPOSITORY --image-ids imageTag=$CURRENT_TAG --query 'images[].imageManifest' --output text);
  aws ecr put-image --repository-name $REPOSITORY --image-tag $NEW_TAG --image-manifest "$MANIFEST"
}

aws_ecr_login() {

  # Reads credentials from .env.aws
  AWS_ECR_ACCESS_KEY_ID=$(grep AWS_ECR_ACCESS_KEY_ID .env.aws | cut -d '=' -f2);
  AWS_ECR_SECRET_ACCESS_KEY=$(grep AWS_ECR_SECRET_ACCESS_KEY .env.aws | cut -d '=' -f2);
  AWS_ECR_DEFAULT_REGION=$(grep AWS_ECR_DEFAULT_REGION .env.aws | cut -d '=' -f2);
  AWS_ACCOUNT=$(grep AWS_ACCOUNT .env.aws | cut -d '=' -f2);

  if [[ ! $AWS_ECR_ACCESS_KEY_ID ]]
  then
    echo "[Error] AWS_ECR_ACCESS_KEY_ID variables not defined. Please, set the variables AWS_ECR_ACCESS_KEY_ID in .env.aws"
    exit 1
  fi

  if [[ ! $AWS_ECR_SECRET_ACCESS_KEY ]]
  then
    echo "[Error] ! AWS_ECR_SECRET_ACCESS_KEY variables not defined. Please, set the variables AWS_ECR_SECRET_ACCESS_KEY in .env.aws"
    exit 1
  fi

  if [[ ! $AWS_ECR_DEFAULT_REGION ]]
  then
    echo "[Error] AWS_ECR_DEFAULT_REGION variables not defined. Please, set the variables AWS_ECR_DEFAULT_REGION in .env.aws"
    exit 1
  fi

  if [[ ! $AWS_ACCOUNT ]]
  then
    echo "[Error] AWS_ACCOUNT variables not defined. Please, set the variables AWS_ACCOUNT in .env.aws"
    exit 1
  fi

  echo "aws configure set aws_access_key_id AWS_ECR_ACCESS_KEY_ID"
  aws configure set aws_access_key_id "$AWS_ECR_ACCESS_KEY_ID";
  echo "aws configure set aws_secret_access_key AWS_ECR_SECRET_ACCESS_KEY"
  aws configure set aws_secret_access_key $AWS_ECR_SECRET_ACCESS_KEY;
  echo "aws configure set default.region AWS_ECR_DEFAULT_REGION"
  aws configure set default.region $AWS_ECR_DEFAULT_REGION

  echo "yarn aws-login"
  # Loggin to docker with AWS credentials
  . ./scripts/aws-config.sh && aws_login

}

aws_push_bcn_image() {
  # Reads repository from AWS
  AWS_REPOSITORY=$(grep AWS_REPOSITORY .env.aws | cut -d '=' -f2);
  if [[ ! $AWS_REPOSITORY ]]
  then
    echo "[Error] Repository not defined. Please, set the variable AWS_REPOSITORY in .env.aws"
    exit 1
  fi

  echo "Pushing bcn image to repository $AWS_REPOSITORY"
  # Reads project current tag (version)
  CURRENT_VERSION=$(grep version package.json | sed 's/.*"version": "\(.*\)".*/\1/');

  read -p "Pushing bcn image with tag '$CURRENT_VERSION'. Continue? (Y/N): " prompt
  if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]] ;
  then
    # Loggin to AWS
    . ./scripts/aws-config.sh && aws_login
    # Tag the bcn image to project current version, and push it to AWS.
    echo "Tagging bitcoin-computer-node-secret image to '$CURRENT_VERSION'"
    docker tag bitcoin-computer-node-secret $(grep AWS_REPOSITORY .env.aws | cut -d '=' -f2):$CURRENT_VERSION;
    echo "Pushing bitcoin-computer-node-secret to repository $AWS_REPOSITORY"
    docker push $AWS_REPOSITORY:$CURRENT_VERSION
  fi
}

docker_context_use() {
    context=$1
    . ./scripts/aws-config.sh && aws_secret_export
    docker context use $context
}

docker_compose_project() {
    projectName=$1
    ymlFile=$2
    context=$3
    echo "Setting up docker compose with project name: $projectName , yml: $ymlFile and context: $context"
    docker --debug compose --project-name $projectName -f docker-compose.yml -f $ymlFile $context
}

aws_project_setup() {
    projectName=$1
    ymlFile=$2
    context=$3

    echo "Setting up AWS for project: $projectName, yml: $ymlFile and context: $context"
    . ./scripts/aws-config.sh && aws_secret_export
    docker_compose_project $projectName $ymlFile $context
}

aws_ltc_testnet() {
    projectName=ltc-testnet-cluster-v0-6-0
    ymlFile=chain-setup/aws/docker-compose-aws-ltc-testnet.yml
    context=$1

    aws_project_setup $projectName $ymlFile $context
}
