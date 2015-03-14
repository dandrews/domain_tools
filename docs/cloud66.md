### Cloud66 with DigitalOcean ###

#### Command Line Tools ####

Download and install the [Cloud66 Toolbelt](http://help.cloud66.com/toolbelt/toolbelt-introduction):

 * ssh to production: ```cx ssh -s "SD" Cheetah```
                      ```cx ssh -s "domain_tools" Alpaca```
 * ssh log files: ```cx tail -s "SD" web production.log```
 * run rake tasks: ```cx run -s "SD" Cheetah 'cd /var/deploy/cheetah/web_head/current; bundle exec rake clear --trace RAILS_ENV=production'```
