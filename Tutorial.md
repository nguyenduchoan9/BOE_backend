* Initialize Database *

rails db:create db:migrate db:seed

* Reset Database *

rails db:migrate:resetss

* Open host for mobile *

rails s -b [your-host]

* Sidekiq *
bundle exec sidekiq -d -L log/sidekiq.log -C config/sidekiq.yml -e production
bundle exec sidekiq -L log/sidekiq.log -C config/sidekiq.yml
* PORT * 
https://askubuntu.com/questions/538208/how-to-check-opened-closed-port-on-my-computer
https://stackoverflow.com/questions/9346211/how-to-kill-a-process-on-a-port-on-ubuntu

* kill sidekiq*
ps ax|grep sidekiq
 kill -TTIN 5938
 