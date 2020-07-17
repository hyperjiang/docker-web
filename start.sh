#!/bin/bash

# create cronjob file for root, application can edit this file to customize its own rules
cronfile="/var/spool/cron/crontabs/root"
touch $cronfile
chown root.crontab $cronfile
chmod 600 $cronfile

# run customized scripts
if [ -d "/scripts" ]; then
	# make scripts executable incase they aren't
	chmod a+x /scripts/*; sync;
	# run scripts in number order
	for i in `ls /scripts`; do /scripts/$i ; done
fi

# start services, nginx will run in foreground so that the container won't exit
service cron start
service php7.2-fpm start
service nginx start
