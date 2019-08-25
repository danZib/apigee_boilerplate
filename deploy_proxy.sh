#!/usr/bin/env bash
set -e
ORG="danielzibion-eval"
APIGEE_ENV="test"

proxy_name="$1"

# Check Maven is pre-installed
if ! [ -x "$(command -v mvn)" ]; then
  >&2 echo 'Please install maven' >&2
  exit 1
fi

# Check GNU sed is installed
if [ -x "$(command -v gsed)" ]; then
  SED="gsed"
elif [ -x "$(command -v sed)" ]; then
  SED="sed"
else
  >&2 echo 'Please install GNU sed' >&2
  exit 1
fi


if [ "${proxy_name}" == "" ]; then
    >&2 echo "Usage: $0 [proxy-name]"
    exit 1
fi

if [ "${USER}" == "" ] || [ "${PASSWORD}" == "" ]; then
    >&2 echo "\$USER or \$PASSWORD not set"
    exit 1
fi

tmp_dir=/tmp/esh.conf.apigee
rm -rf ${tmp_dir}

cp -R $(dirname $0)/gateway ${tmp_dir}

cd ${tmp_dir}/${proxy_name}

echo "Deploying ${proxy_name} to ${APIGEE_ENV} on ${ORG}"
mvn install -P${APIGEE_ENV} -Dusername=${USER} -Dpassword=${PASSWORD} -Dorg=${ORG}
cd - >/dev/null

rm -rf ${tmp_dir}
