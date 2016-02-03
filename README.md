# Loopia DNS updater

This is a script to automatically update DNS records at Loopia.

- Supports multiple hosts
- Only updates the records if the current IP has changed
- Logs to syslog

## Usage
### Run once
1. `./loopiadns.bash user:pass domain.tld [domain.tld ...]`

### Schedule
1. Put `loopiadns.bash` somewhere.
2. Edit crontab (`crontab -e`) to schedule the script to run for example every 15 minutes:

```
*/15 * * * * /some/path/to/loopiadns.bash user:pass firstdomain.tld seconddomain.tld
```

## Licence
Copyright (c) 2012 Johan Sageryd <j@1616.se>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
