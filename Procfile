release: bundle exec rake db:migrate

web: bin/rails server -p $PORT
worker: bundle exec sidekiq -c 5 -v
