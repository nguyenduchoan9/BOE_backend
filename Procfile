web: bundler exec rails server -p $PORT -e $RAILS_ENV
worker: bundle exec sidekiq -c 1 -v -q default -q notification
