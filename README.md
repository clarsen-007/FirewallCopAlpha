# FirewallCopAlpha

# Script used on Ubuntu - installed with iptables and ipset
# I use this script to setup firewall rules to block bad traffic on my Edge Server
#                          ╔═════════════════════╗              ╔═════════════════════╗
#                          ║ Ubuntu              ║              ║                     ║  ════════ >  Network / VLAN 1
#                          ║ Edge Server         ║              ║  pfSense            ║
# Internet    ════════ >   ║ Acting as my first  ║  ════════ >  ║  Main Firewall      ║  ════════ >  Network / VLAN 2
#                          ║ Firewall            ║              ║                     ║
#                          ║                     ║              ║                     ║  ════════ >  Network / VLAN 3
#                          ╚═════════════════════╝              ╚═════════════════════╝
