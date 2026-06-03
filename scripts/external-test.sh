#!/bin/bash
#
# cisco-enterprise-network
# https://github.com/briangeis/cisco-enterprise-network
#
# External Connectivity Test
# Verifies external host reachability via ping, HTTP, and DNS.
#
# Author:  Brian Geis
# License: GPL-3.0-or-later
#

main() {
  # Define the IP addresses of HTTP servers
  local -A hosts=(
    ["Server-01"]="172.20.1.3"
    ["Server-02"]="172.20.1.4"
    ["Server-03"]="172.20.1.5"
  )

  # Define the URLs of all HTTP servers
  local -A servers=(
    ["Server-01"]="http://172.20.1.3"
    ["Server-02"]="http://172.20.1.4"
    ["Server-03"]="http://172.20.1.5"
  )

  # Define the domain used for DNS testing
  local domain="github.com"

  # Perform ping connectivity tests
  local host
  for host in "${!hosts[@]}"; do
    local ip="${hosts[$host]}"
    printf "Testing ping connectivity to %s (%s)... " "${host}" "${ip}"
    if ping -c1 -W1 "${ip}" &>/dev/null; then
      printf "OK\n"
    else
      printf "FAILED\n"
    fi
  done

  # Perform HTTP connectivity tests
  local server
  for server in "${!servers[@]}"; do
    local url="${servers[$server]}"
    printf "Testing HTTP connectivity to %s (%s)... " "${server}" "${url}"
    if curl -sf --output /dev/null --connect-timeout 5 "${url}"; then
      printf "OK\n"
    else
      printf "FAILED\n"
    fi
  done

  # Perform DNS resolution test
  printf "Testing DNS resolution for %s... " "${domain}"
  if [[ -n "$(dig +short "${domain}")" ]]; then
    printf "OK\n"
  else
    printf "FAILED\n"
  fi
}

main "$@"
