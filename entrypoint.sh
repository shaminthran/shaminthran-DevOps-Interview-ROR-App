#!/bin/bash
set -e

echo "Running bundle install..."
bundle check || bundle install

echo "Checking and removing stale server PID..."
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

echo "Creating and migrating the database..."
bundle exec rails db:create
bundle exec rails db:schema:load
bundle exec rails db:migrate

echo "Precompiling assets..."
bundle exec rails assets:precompile

echo "Starting Rails server..."
exec bundle exec rails server -b 0.0.0.0 -p 3000
