#!/bin/sh

bitcoin_cli_setup() {
  echo "Setting up bitcoin cli with $1 $2 $3 $4 $5 $6 $7"
  dockerImage=$1
  cliType=$2
  deamon=$3
  regtest=$4
  port=$5
  command=$6
  num=$7
  address=$8

  docker run --network ${PWD##*/}_bitcoin $dockerImage $cliType -rpcconnect=$deamon -rpcuser=bcn-admin -rpcpassword=kH4nU5Okm6-uyC0_mA5ztVNacJqZbYd_KGLl6mx722A= $regtest $port $command $num $address
}

bitcoin_cli_ltc_regtest() {
  dockerImage=public.ecr.aws/j9i7w6o6/litecoin-docker-images
  cliType=litecoin-cli
  deamon=litecoind
  regtest=$1
  port=$2
  command=$3
  num=$4
  address=$5

  bitcoin_cli_setup $dockerImage $cliType $deamon $regtest $port $command $num $address
}

bitcoin_cli_btc_regtest() {
  dockerImage=ruimarinho/bitcoin-core
  cliType=bitcoin-cli
  deamon=bitcoind
  regtest=$1
  port=$2
  command=$3
  num=$4
  address=$5

  bitcoin_cli_setup $dockerImage $cliType $deamon $regtest $port $command $num $address
}
