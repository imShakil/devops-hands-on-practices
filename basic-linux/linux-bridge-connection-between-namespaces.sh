#!/bin/bash

# add two namespaces
sudo ip netns add ns1
sudo ip netns add ns2

# Add pair of interfaces for namespaces
sudo ip link add veth-ns1 type veth peer name veth-ns1-br
sudo ip link add veth-ns2 type veth peer name veth-ns2-br

# Connect virtual network interfaces at namespace end
sudo ip link set veth-ns1 netns ns1
sudo ip link set veth-ns2 netns ns2

# Add a linux bridge network
sudo ip link add dev br0 type bridge

# Assign ip adddress for bridge network
sudo ip link set dev br0 up
sudo ip addr add 10.100.0.1/24 dev br0

# Connect virutal network interfaces at birdge end
sudo ip link set dev veth-ns1-br master br0
sudo ip link set dev veth-ns2-br master br0

# Turned up virtual interfaces at host
sudo ip link set dev veth-ns1-br up
sudo ip link set dev veth-ns2-br up 

# Turned up lo and virtual network at namespace end
sudo ip netns exec ns1 ip link set lo up
sudo ip netns exec ns1 ip link set dev veth-ns1 up
sudo ip netns exec ns2 ip link set lo up 
sudo ip netns exec ns2 ip link set dev veth-ns2 up

# Assign IP address and default route for virtual inerfaces at namespace end
sudo ip netns exec ns1 ip addr add 10.100.0.10/24 dev veth-ns1
sudo ip netns exec ns1 ip route add default via 10.100.0.1 dev veth-ns1 
sudo ip netns exec ns2 ip addr add 10.100.0.20/24 dev veth-ns2
sudo ip netns exec ns2 ip route add default via 10.100.0.1 dev veth-ns2

# firewall
#sudo iptables --append FORWARD --in-interface br0 --jump ACCEPT
#sudo iptables --append FORWARD --out-interface br0 --jump ACCEPT

# test connectivity
ping -c 2 10.100.0.10
ping -c 2 10.100.0.20
sudo ip netns exec ns1 ping -c 2 10.100.0.20
sudo ip netns exec ns2 ping -c 2 10.100.0.10
