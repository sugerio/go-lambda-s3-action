# go-lambda-s3-action
Github action to build go, zip it and upload to s3 bucket for lambda deployment.

#Example:
```
name: Build, Zip & Upload to s3 bucket

on:
  workflow_dispatch:
  push:
    branches:
      - 'main'

jobs:
  build:
    # runs-on: ubuntu-latest
    runs-on: [self-hosted, linux, x64]
    steps:
    - uses: actions/checkout@master
    - name: Build, zip & upload to s3 bucket
      uses: sugerio/go-lambda-s3-action@main
      env:
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        AWS_DEFAULT_REGION: us-west-2
        AWS_BUCKET_NAME: suger-artifact-dev
        AWS_BUCKET_KEY_PREFIX: workload/marketplace-service
        GO_BUILD_TARGET: cmd/server
        RELEASE_TAG: v1.1.0

```
