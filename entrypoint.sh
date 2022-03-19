#!/bin/bash

# echo "Build go from target:" $GO_BUILD_TARGET
# mkdir -p bin/output 
# git config --global --add url."https://$GH_PAT@github.com:".insteadOf "https://github.com/"
# export GOPRIVATE=github.com/sugerio/*
# GOOS=linux go build -o bin/output/ $GO_BUILD_TARGET

ARTIFACTS_DIRECTORY=bin/zip_artifacts
mkdir -p $ARTIFACTS_DIRECTORY
RELEASE_ZIP=$RELEASE_TAG.zip
LATEST_ZIP=latest.zip
echo "Packaging lambda zip to:" $ARTIFACTS_DIRECTORY/$RELEASE_ZIP $ARTIFACTS_DIRECTORY/$LATEST_ZIP
zip bin/artifacts/$RELEASE_ZIP $BINARY_DIRECTORY/*
echo "Successfully created $RELEASE_ZIP"

echo "Upload zip file to bucket" $AWS_BUCKET_NAME 
S3_RELEASE_ZIP=s3://$AWS_BUCKET_NAME/$AWS_BUCKET_KEY_PREFIX/$RELEASE_ZIP
S3_LATEST_ZIP=s3://$AWS_BUCKET_NAME/$AWS_BUCKET_KEY_PREFIX/$LATEST_ZIP
aws --region $AWS_DEFAULT_REGION s3 cp $ARTIFACTS_DIRECTORY/$RELEASE_ZIP $S3_RELEASE_ZIP --no-progress
aws --region $AWS_DEFAULT_REGION s3 cp $S3_RELEASE_ZIP $S3_LATEST_ZIP --no-progress
echo "Successfully uploaded zip to $S3_RELEASE_ZIP and $S3_LATEST_ZIP"

# if the LAMBDA_FUNCTION_NAME is not empty
if [ ! -z "$LAMBDA_FUNCTION_NAME" ]
then
    echo "Update lambda function" $LAMBDA_FUNCTION_NAME "from s3 bucket"
    aws --region $AWS_DEFAULT_REGION lambda update-function-code --function-name $LAMBDA_FUNCTION_NAME \
    --s3-bucket $AWS_BUCKET_NAME --s3-key $AWS_BUCKET_KEY_PREFIX/$LATEST_ZIP --publish &> /dev/null
    echo "Successfully updated lambda function" $LAMBDA_FUNCTION_NAME "from s3 bucket"
fi

rm -rf $BINARY_DIRECTORY/
rm -rf $ARTIFACTS_DIRECTORY/
echo "Successfully removed the bin folder"
