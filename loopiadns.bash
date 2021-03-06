#!/bin/bash

# Loopia DNS updater

# Tests an IP address for validity
# Example:
#  ip_is_valid IP_ADDRESS
#  if [[ $? -eq 0 ]]; then echo good; else echo bad; fi
#    - or -
#  if ip_is_valid IP_ADDRESS; then echo good; else echo bad; fi
function ip_is_valid() {
  local ip=$1
  local stat=1
  if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    OIFS=$IFS
    IFS='.'
    ip=($ip)
    IFS=$OIFS
    [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
    stat=$?
  fi
  return $stat
}

# Get Loopia account credentials
auth="$1"

# Check existence
if [ -z "$auth" ]; then
  echo 'Authentication info not supplied.'
  echo 'Example: ./loopiadns.bash user:pass firstdomain.tld seconddomain.tld'
  exit 1
fi

# Get first hostname
shift

# Check existence
if [ -z "$1" ]; then
  echo 'Hostname not supplied.'
  echo 'Example: ./loopiadns.bash user:pass firstdomain.tld seconddomain.tld'
  exit 1
fi

# Get IP address from Loopia
myip=`curl -s dns.loopia.se/checkip/checkip.php | sed 's/^.*: \([^<]*\).*$/\1/'`

# Check retrieved value
if [ -z "${myip}" ]; then
  echo "Cannot retrieve external IP address."
  exit 1
fi

# Validate IP address
ip_is_valid "${myip}"
if [ $? -ne 0 ]; then
  echo "Retrieved external IP address is not valid: ${myip}"
  exit 1
fi

# URL for DNS update
burl=https://dns.loopia.se/XDynDNSServer/XDynDNS.php

# Extra options
eops='wildcard=NOCHG'

# Loop through all hostnames and update DNS records if necessary
while [ ! -z "$1" ]; do
  # Get hostname
  hostname="$1"

  # Build URL
  url="${burl}"'?hostname='"${hostname}"'&'myip="${myip}"'&'"${eops}"

  # Get IP from DNS record
  dnsip=$(host -t A "${hostname}" | rev | cut -f 1 -d ' ' | rev)

  # Write '(unknown)' if the DNS lookup does not return a valid IP address
  ip_is_valid "${dnsip}" || dnsip="(unknown)"

  # If the IP has changed, update the DNS record
  if [ "${dnsip}" != "${myip}" ]; then
    result=$(curl -s --user "${auth}" "${url}")
    logmsg="[${hostname}] ${dnsip} -> ${myip}: ${result}"
    logger -t "Loopia DNS updater" "${logmsg}"
  else
    logmsg="[${hostname}] ${dnsip}: no update needed"
  fi
  echo "$logmsg"

  shift
done
