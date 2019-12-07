#!/bin/bash

REPO_ID=460015929520;
AWS_REGION=ap-south-1;
REPO_NAME=iplserver;
API_REPO_NAME=iplapi;
JOB_REPO_NAME=ipljobs;

IPLSERVER_SC_PORT=8000;
IPLSERVER_API_PORT=7000;

SC_BIN=server.js;
API_BIN=apiServer.js;
JOB_BIN=job.js;

NO_SC_INSTANCES=4;
NO_API_INSTANCES=4;
NO_JOB_INSTANCES=2;

DOCKER_BIN=/usr/bin/docker;
HOST_NAME=`hostname`


############################
VAR_LOG_PATH=" -v /logs:/logs -v /logs:/var/www/logs "
#VAR_REDIS_HOST="10.0.34.12"
VAR_PROD_REDIS="--env REDIS_CLUSTERED=true --env REDIS_HOST0=10.0.34.12 --env REDIS_HOST1=10.0.34.13 --env REDIS_HOST2=10.0.34.14"
#VAR_REDIS_HOST="wc-prod-0001-001.unx29l.0001.aps1.cache.amazonaws.com"
#VAR_PROD_REDIS="--env REDIS_CLUSTERED=true --env REDIS_HOST0=ipl12-prod-0001-001.unx29l.0001.aps1.cache.amazonaws.com --env REDIS_HOST1=ipl12-prod-0002-001.unx29l.0001.aps1.cache.amazonaws.com --env REDIS_HOST2=ipl12-prod-0003-001.unx29l.0001.aps1.cache.amazonaws.com --env REDIS_HOST3=ipl12-prod-0004-001.unx29l.0001.aps1.cache.amazonaws.com"
#VAR_GP_REDIS="--env GP_REDIS_CLUSTERED=true --env GP_REDIS_HOST0=ipl12-gp-prod-0001-001.unx29l.0001.aps1.cache.amazonaws.com --env GP_REDIS_HOST1=ipl12-gp-prod-0002-001.unx29l.0001.aps1.cache.amazonaws.com --env GP_REDIS_HOST2=ipl12-gp-prod-0003-001.unx29l.0001.aps1.cache.amazonaws.com --env GP_REDIS_HOST3=ipl12-gp-prod-0004-001.unx29l.0001.aps1.cache.amazonaws.com"
VAR_LB_REDIS="--env LB_REDIS_HOST=10.0.34.12 --env LB_REDIS_HOST1=10.0.34.13 --env LB_REDIS_HOST2=10.0.34.14"
VAR_GP_REDIS="--env GP_REDIS_HOST=10.0.34.12 --env GP_REDIS_HOST1=10.0.34.13 --env GP_REDIS_HOST2=10.0.34.14"
VAR_MONGO="--env MONGODB_URL=mongodb://10.0.33.2 --env DB_HOST=10.0.33.2"
VAR_RABBITMQ="--env RABBITMQ_HOST=10.0.35.2"

VAR_COUPON="--env COUPON_HOST=https://couponapi.jiokhelo.com"
VAR_WHITELIST='--env WHITELIST=https://jioplayalong1.akamaized.net,https://jioplayalong4.akamaized.net'
############################
start_sc_instances(){
    echo "Starting $NO_SC_INSTANCES socket cluster instances";
    for (( i=0; i<$NO_SC_INSTANCES; i++ ))
    do
        PORT=$(($i + $IPLSERVER_SC_PORT));
        docker run -d --name iplserver-$PORT -p $PORT:3000  $VAR_LOG_PATH  --env LOG_INITIAL=$HOST_NAME-$PORT --env ENV=PROD --env REDIS_HOST=$VAR_REDIS_HOST --env REDIS_URL=$VAR_REDIS_HOST  $VAR_RABBITMQ $VAR_PROD_REDIS $VAR_GP_REDIS  --restart unless-stopped $REPO_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME:latest_wc;
    done
}

start_api_instances(){
    echo "Starting $NO_API_INSTANCES socket cluster instances";
    for (( i=0; i<$NO_API_INSTANCES; i++ ))
    do
        PORT=$(($i + $IPLSERVER_API_PORT));
        docker run -d --name iplapi-$PORT -p $PORT:5000 $VAR_LOG_PATH --env ENV=PROD --env LOG_INITIAL=$HOST_NAME-$PORT  --env REDIS_HOST=$VAR_REDIS_HOST --env REDIS_URL=$VAR_REDIS_HOST $VAR_LB_REDIS $VAR_RABBITMQ $VAR_PROD_REDIS $VAR_GP_REDIS $VAR_WHITELIST --restart unless-stopped $REPO_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$API_REPO_NAME:latest_wc;
    done
}

start_job_instances(){
    echo "Starting $NO_JOB_INSTANCES job instances";
    for (( i=0; i<$NO_JOB_INSTANCES; i++ ))
    do
        docker run -d --name ipljobs-$i $VAR_LOG_PATH --env ENV=PROD --env LOG_INITIAL=$HOST_NAME-$i $VAR_MONGO $VAR_RABBITMQ $VAR_LB_REDIS $VAR_PROD_REDIS $VAR_GP_REDIS $VAR_COUPON --restart unless-stopped $REPO_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$JOB_REPO_NAME:latest_wc;
    done
}

stop_instances(){
    echo "Stopping and removing existing instances ,containers and images";

    docker ps -q | xargs -r docker stop;
    docker ps -a -q | xargs -r docker rm;
    docker images -q | xargs -r docker rmi;
}

sync_container(){
    echo "Syncing container";
#    $(aws ecr get-login --region ap-south-1 | sed -e 's/-e none//g');
    $DOCKER_BIN pull $REPO_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME:latest_wc;
    $DOCKER_BIN pull $REPO_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$API_REPO_NAME:latest_wc;
}
deploy(){
    mkdir -p $HOME/.aws/
 #   cp -r $HOME/configs/aws/* $HOME/.aws/
    stop_instances;
    sync_container;
    start_sc_instances;
    start_api_instances;
    start_job_instances;
}

deploy
