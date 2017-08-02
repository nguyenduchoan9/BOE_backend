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

 * fix db error - no schema find*
 DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=test bundle exec rake db:drop db:create db:migrate

 * run elasticsearch *
 sudo services elasticsearch start
 sudo systemctl restart elasticsearch
    systemctl status elasticsearch

 sudo /etc/init.d/elasticsearch start/stop
 edit host in yml file


 * dish name - material
Dish.all.map do |d|
    ' <<' + d.dish_name + '--' + d.material.name + '>> ' 
end

 