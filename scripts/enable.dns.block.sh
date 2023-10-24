#!/bin/bash

## Add all DNS blocking...

iptables -t mangle -A PREROUTING -p udp --dport 53 -j DROP
iptables -t mangle -A PREROUTING -p tcp --dport 53 -j DROP
