#
# Copyright 2016 Dennis Vriend
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#!/bin/bash
export VM_HOST="${VM_HOST:-boot2docker}"

# Wait for a certain service to become available
# Usage: wait 3306 Mysql
wait() {
while true; do
  if ! nc -z $VM_HOST $1
  then
    echo "$2 not available, retrying..."
    sleep 1
  else
    echo "$2 is available"
    break;
  fi
done;
}

docker rm -f $(docker ps -aq)
docker-compose up -d
wait 8161 Activemq
export CODACY_PROJECT_TOKEN=$REACTIVE_AMQ_TOKEN
echo "project token: $CODACY_PROJECT_TOKEN"
sbt clean coverage test
sbt coverageReport
sbt coverageAggregate
sbt codacyCoverage
docker rm -f $(docker ps -aq)
