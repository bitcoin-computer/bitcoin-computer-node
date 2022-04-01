#!/bin/bash

test_ltc() {
    BCN_URL=http://127.0.0.1:3000 CHAIN=LTC NETWORK=regtest BCN_ENV=test POSTGRES_PORT=5432 POSTGRES_HOST=127.0.0.1 RPC_HOST=127.0.0.1 RPC_PORT=19332 RPC_PROTOCOL=http RPC_USER=bcn-admin RPC_PASSWORD=kH4nU5Okm6-uyC0_mA5ztVNacJqZbYd_KGLl6mx722A= ZMQ_URL=tcp://127.0.0.1:28332 UN_P2SH_URL=http://127.0.0.1:3000 jest --config ./jest.config.json --detectOpenHandles --verbose
}

test_btc() {
    BCN_URL=http://127.0.0.1:3000 CHAIN=LTC NETWORK=regtest BCN_ENV=test POSTGRES_PORT=5432 POSTGRES_HOST=127.0.0.1 RPC_HOST=127.0.0.1 RPC_PORT=8332 RPC_PROTOCOL=http RPC_USER=bcn-admin RPC_PASSWORD=kH4nU5Okm6-uyC0_mA5ztVNacJqZbYd_KGLl6mx722A= ZMQ_URL=tcp://127.0.0.1:28332 UN_P2SH_URL=http://127.0.0.1:3000 jest --config ./jest.config.json --detectOpenHandles --verbose
}

test_aws() {
    BCN_ENV=test POSTGRES_PORT=5432 POSTGRES_HOST=54.145.161.100 RPC_HOST=127.0.0.1 RPC_PROTOCOL=http RPC_USER=bcn-admin RPC_PASSWORD=kH4nU5Okm6-uyC0_mA5ztVNacJqZbYd_KGLl6mx722A= ZMQ_URL=tcp://127.0.0.1:28332 UN_P2SH_URL=http://127.0.0.1:3000 jest --config ./jest.config.json --detectOpenHandles --verbose
}
