#!/bin/bash

if [ -z "${PMM_SERVER}" ]; then
    echo PMM_SERVER is not specified. exiting
    exit 1
else
  SERVER_IS_READY=0
  # wait for pmmserver listen to connection
  while [ "$SERVER_IS_READY" -eq 0 ]
  do
    STATUS_CODE=$(curl --write-out %{http_code} --silent --output /dev/null "${PMM_SERVER}/ping")

    if [[ "$STATUS_CODE" -eq "200" ]] ; then
      SERVER_IS_READY=1
    fi

    echo "waiting for pmmserver to accept connection ..."
    sleep 1
  done
fi


if [ -n "${SERVER_USER}" ]; then
    ARGS+=" --server-user ${SERVER_USER}"
fi
if [ -n "${SERVER_PASSWORD}" ]; then
    ARGS+=" --server-password ${SERVER_PASSWORD}"
fi

PMM_SERVER_IP=$(ping -c 1 "${PMM_SERVER}" | grep PING | sed -e 's/).*//; s/.*(//')
SRC_ADDR=$(ip route get "${PMM_SERVER_IP}" | grep 'src ' | awk '{print$7}')
CLIENT_NAME=${DB_HOST:-$HOSTNAME}

pmm-admin config \
    --force \
    --server "${PMM_SERVER}" \
    --server-insecure-ssl \
    --bind-address "${SRC_ADDR}" \
    --client-address "${SRC_ADDR}" \
    --client-name "${CLIENT_NAME}" \
    ${ARGS}

if [ -n "${DB_HOST}" ]; then
    DB_ARGS+=" --host ${DB_HOST}"
fi
if [ -n "${DB_USER}" ]; then
    DB_ARGS+=" --user ${DB_USER}"
fi
if [ -n "${DB_PASSWORD}" ]; then
    DB_ARGS+=" --password ${DB_PASSWORD}"
fi

if [ -n "${DB_TYPE}" ]; then
    pmm-admin add "${DB_TYPE}" \
        ${DB_ARGS}

fi

$SHELL
