#!/bin/bash
sudo apt-get install -y bundler

cd /tmp/serverspec

sudo bundle install --path=vendor
sudo bundle exec rake spec || exit $ERRCODE

sudo rm -rf /tmp/packer-provisioner-ansible-local
sudo apt-get remove -y bundler
