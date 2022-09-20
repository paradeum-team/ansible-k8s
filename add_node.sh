#!/bin/bash
set -e

BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR

. ./config.cfg

isHostInit=${1:-true}

ansible-playbook playbooks/k8s/node.yml --extra-vars "isHostInit=$isHostInit"
