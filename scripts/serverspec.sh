#!/bin/bash
source /home/ubuntu/.rvm/scripts/rvm
gem install bundler

cd /tmp/serverspec

sudo bundle install --path=vendor
sudo bundle exec rake spec || exit $ERRCODE

sudo rm -rf /tmp/packer-provisioner-ansible-local
gem uninstall bundler
