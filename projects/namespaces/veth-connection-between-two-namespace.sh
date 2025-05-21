#!/bin/bash

# add two namespace

sudo ip netns add ns1
sudo ip netns add ns2

# add a pair of network interface 

sudo ip link add veth-ns1 type veth peer name veth-ns2

# move network interfaces to namespace
sudo ip link set veth-ns1 netns ns1
sudo ip link set veth-ns2 netns ns2

# add ip address to network interface on each namespace

sudo ip netns exec ns1 ip addr add 192.168.0.1 dev veth-ns1
sudo ip netns exec ns2 ip addr add 192.168.1.1 dev veth-ns2 

# turned up the interfaces

sudo ip netns exec ns1 ip link set lo up
sudo ip netns exec ns1 ip link set veth-ns1 up
sudo ip netns exec ns2 ip link set lo up
sudo ip netns exec ns2 ip link set veth-ns2 up

# add default gateway

sudo ip netns exec ns1 ip route add default via 192.168.0.1 dev veth-ns1
sudo ip netns exec ns2 ip route add default via 192.168.1.1 dev veth-ns2

# test connectivity

sudo ip netns exec ns1 ping -c 2 192.168.1.1
sudo ip netns exec ns2 ping -c 2 192.168.0.1
