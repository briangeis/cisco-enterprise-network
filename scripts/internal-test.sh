#!/bin/bash
#
# cisco-enterprise-network
# https://github.com/briangeis/cisco-enterprise-network
#
# Internal Connectivity Test
# Verifies internal host reachability via ping, HTTP, and DNS.
#
# Author:  Brian Geis
# License: GPL-3.0-or-later
#

main() {
  # Define the IP addresses of all hosts
  local -A hosts=(
    ["Server-01"]="10.1.10.10"
    ["Server-02"]="10.1.10.20"
    ["Server-03"]="10.1.10.30"
    ["NetAdmin-PC"]="10.1.20.51"
    ["Sales-PC"]="10.1.30.11"
    ["Marketing-PC"]="10.1.40.11"
    ["Accounting-PC"]="10.1.50.11"
    ["Management-PC"]="10.1.60.11"
    ["Shipping-PC"]="10.1.70.11"
    ["Receiving-PC"]="10.1.80.11"
    ["NetAdmin-RM"]="10.2.20.11"
    ["Sales-RM"]="10.2.30.11"
    ["Shipping-RM"]="10.2.70.11"
  )

  # Define the URLs of all HTTP servers
  local -A servers=(
    ["Server-01"]="http://10.1.10.10"
    ["Server-02"]="http://10.1.10.20"
    ["Server-03"]="http://10.1.10.30"
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
