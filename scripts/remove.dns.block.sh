#!/bin/bash

## Drop all DNS blocking...

iptables -t mangle -D PREROUTING -p udp --dport 53 -j DROP
iptables -t mangle -D PREROUTING -p tcp --dport 53 -j DROP
