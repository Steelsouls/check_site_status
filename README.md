# check_site_status.rb

This little script checks whether or not a website can be reached.
It then logs the result to a text file and, if provided, emails an alert
when the site is down.

## Usage
	$ cd .../check_site_status
	$ bundle install
	$ ruby check_site_status.rb <URL> [email_to] [alternate_log_directory]

## Cron
Call this script from Cron to set up a site monitor so you can always
know when your site isn't up!
In order to call Ruby files from your crontab, you must load an environment containing the Ruby runtime. Here's an example that runs every ten minutes, just replace my BASH_ENV with the path to load your environment.

	SHELL=/bin/bash
	BASH_ENV = $HOME/.bash_profile
	
	*/10 * * * * $HOME/code/scripts/check_site_status.rb http://brandonrubin.me steelsouls@gmail.com

## Email
In order for email to work, you must set up a local mail server and 
add a $USER_EMAIL environment variable.
I run this with Ubuntu 12.04 and 13.04, and my favorite mail server is Postfix. All you really need to get working is outgoing mail, which I've found to be easier than incoming, as you don't have to open any ports, set up spam filtering, or worry about what type of mailbox you have.
[Ubuntu Official Postfix Basic Setup](https://help.ubuntu.com/community/PostfixBasicSetupHowto "Setup Postfix")

## Dependencies
* Faraday gem
* Pony gem
You can install these manually or by issuing 'bundle install' inside the script's directory.

## License
Copyright (C) 2013 [Brandon Rubin](http://brandonrubin.me) (steelsouls), [MIT License](https://github.com/steelsouls/check_site_status/blob/master/LICENSE)
