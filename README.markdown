Loopia DNS updater
===================
This is a script to automatically update DNS records at Loopia.

- Supports multiple hosts
- Only updates the records if the current IP has changed

Usage
------------------
### Run once
1. `./loopiadns.bash user:pass domain.tld [domain.tld ...]`

### Schedule
1. Put `loopiadns.bash` somewhere.
2. Edit crontab (`crontab -e`) to schedule the script to run for example every 15 minutes:

	*/15 * * * * /Users/j/Documents/repos/loopiadns/loopiadns.bash user:pass firstdomain.tld seconddomain.tld

Disclaimer
------------------
I take no responsibility for this script should it cause any harm.
