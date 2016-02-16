#!/bin/bash
sudo yum install -q -y rubygem-bundler

cd /tmp/serverspec

sudo bundle install --path=vendor
sudo bundle exec rake spec || exit $ERRCODE

sudo rm -rf /tmp/packer-provisioner-ansible-local
sudo yum remove -q -y rubygem-bundler
sudo yum autoremove -q -y
