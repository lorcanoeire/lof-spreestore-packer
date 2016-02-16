#!/usr/bin/env bash

# url to install bundler
gem_bundler_url=https://rubygems.org

# detect rvm gemset to use
RVM_GEMSET=$(cat .ruby-version .ruby-gemset | tr "\\n" "@" | sed 's/@$//')

# load rvm functions
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
[[ -s "/usr/lib/rvm/scripts/rvm" ]] && . "/usr/lib/rvm/scripts/rvm"

rvm --create --install use $RVM_GEMSET

if ! gem list | grep --quiet -w "^bundler\ "; then
  gem install bundler --config-file '' \
                      --no-rdoc --no-ri \
                      --source "$gem_bundler_url" \
                      --version "1.10.6"
fi

bundle check > /dev/null || bundle install --path=vendor

bundle exec rake -f Rakefile $@
