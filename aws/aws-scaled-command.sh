#!/bin/bash

PROFILES=$(cat ~/.aws/credentials | grep  '\[*.\]' | sed 's/[][]//g')
CMD=$1

if [[ -v $1 ]]; then
  echo "Error: AWS command not provided: ./aws-scaled-command.sh 's3 ls'"
  exit
fi

echo "Using command: aws $1"
echo "Public Source IP Address:" $(curl --silent https://checkip.amazonaws.com)

for PROFILE in $PROFILES
do
    echo COMMAND START::$CMD::PROFILE::$PROFILE::DATE::$(date)
    echo -n "INFO:Getting caller identity: "
    
    IAM=""
    IAM=$(AWS_PROFILE=$PROFILE aws sts get-caller-identity | jq .Arn)
    
    if [[ $IAM != "" ]]; then
      
      echo $IAM
      echo "INFO::Running command aws $CMD: "
      
      AWS_PROFILE=$PROFILE aws $1
      echo COMMAND EXIT::$CMD::PROFILE::$PROFILE::USER::$IAM::EXIT CODE::$?

    else 
      echo COMMAND EXIT::$CMD::PROFILE::$PROFILE::EXIT CODE::ERR_INVALID_CREDS
    fi
    
done

echo "Done."
