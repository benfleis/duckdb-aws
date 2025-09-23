#!/bin/bash

set -o noclobber
# WARNING: moves your existing config/credentials with single archive

# Set default file path for config & credentials file if unset
: ${AWS_CONFIG_FILE:=$HOME/.aws/config}
: ${AWS_SHARED_CREDENTIALS_FILE:=$HOME/.aws/credentials}

# create dir if not already exists
for file in $AWS_CONFIG_FILE $AWS_SHARED_CREDENTIALS_FILE; do
    mkdir -p $(dirname "$file")
    [[ -r "$file" ]] && {
        echo "- ARCHIVE $file -> $file-previous" >&2
        mv -f "$file" "${file}-previous"
    }
done

# Create the credentials configuration
credentials_str="
[default]
aws_access_key_id=minio_duckdb_user
aws_secret_access_key=minio_duckdb_user_password

[minio-testing-2]
aws_access_key_id=minio_duckdb_user_2
aws_secret_access_key=minio_duckdb_user_2_password

[minio-testing-invalid]
aws_access_key_id=minio_duckdb_user_invalid
aws_secret_access_key=thispasswordiscompletelywrong
aws_session_token=completelybogussessiontoken

[assume-role-arn]
source_profile = default
role_arn = arn:aws:iam::840140254803:role/pyiceberg-etl-role
region = us-east-2

[assume-role-arn-external-id]
source_profile = default
role_arn = arn:aws:iam::840140254803:role/pyiceberg-etl-role
region = us-east-2
external_id = 128289344
"

# Write the credentials configuration to the file
echo "$credentials_str" >"$AWS_SHARED_CREDENTIALS_FILE"
echo "- CREATE $AWS_SHARED_CREDENTIALS_FILE"

# Create the credentials configuration
config_str="
[default]
region=eu-west-1

[profile minio-testing-2]
region=eu-west-1

[profile minio-testing-invalid]
region=the-moon-123
"

# Write the config to the file
echo "$config_str" >"$AWS_CONFIG_FILE"
echo "- CREATE $AWS_CONFIG_FILE"

echo OK

