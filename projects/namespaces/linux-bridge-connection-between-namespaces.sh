#!/bin/bash

# add two namespaces
sudo ip netns add red
sudo ip netns add green

# Add pair of interfaces for namespaces
sudo ip link add veth-red type veth peer name veth-red-br
sudo ip link add veth-green type veth peer name veth-green-br

# Connect virtual network interfaces at namespace end
sudo ip link set veth-red netns red
sudo ip link set veth-green netns green

# Add a linux bridge network
sudo ip link add dev br0 type bridge

# Assign ip adddress for bridge network
sudo ip link set dev br0 up
sudo ip addr add 10.100.0.1/24 dev br0

# Connect virutal network interfaces at birdge end
sudo ip link set dev veth-red-br master br0
sudo ip link set dev veth-green-br master br0

# Turned up virtual interfaces at host
sudo ip link set dev veth-red-br up
sudo ip link set dev veth-green-br up 

# Turned up lo and virtual network at namespace end
sudo ip netns exec red ip link set lo up
sudo ip netns exec red ip link set dev veth-red up
sudo ip netns exec green ip link set lo up 
sudo ip netns exec green ip link set dev veth-green up

# Assign IP address and default route for virtual inerfaces at namespace end
sudo ip netns exec red ip addr add 10.100.0.10/24 dev veth-red
sudo ip netns exec red ip route add default via 10.100.0.1 dev veth-red 
sudo ip netns exec green ip addr add 10.100.0.20/24 dev veth-green
sudo ip netns exec green ip route add default via 10.100.0.1 dev veth-green

# firewall
#sudo iptables --append FORWARD --in-interface br0 --jump ACCEPT
#sudo iptables --append FORWARD --out-interface br0 --jump ACCEPT

# test connectivity
ping -c 2 10.100.0.10
ping -c 2 10.100.0.20
sudo ip netns exec red ping -c 2 10.100.0.20
sudo ip netns exec green ping -c 2 10.100.0.10
