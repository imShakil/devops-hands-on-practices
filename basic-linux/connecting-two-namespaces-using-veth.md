# Connecting two namespaces using veth

1. Lets create two namespaces:

```
sudo ip netns add ns1
sudo ip netns add ns2
```

2. Add a pair of network interfaces:

```
sudo ip link add veth-ns1 type veth peer name veth-ns2
```

3. Move network interfaces to namespaces:

```
sudo ip link set veth-ns1 netns ns1
sudo ip link set veth-ns2 netns ns2
```
4. Add IP Address to the network interfaces for each namespace:

```
sudo ip netns exec ns1 ip addr add 192.168.0.1/24 dev veth-ns1
sudo ip netns exec ns2 ip addr add 192.168.1.1/24 dev veth-ns2
```

5. Lets turned up the `loopback` and `veth` network interface on each namespace:

```
sudo ip netns exec ns1 ip link set lo up
sudo ip netns exec ns1 ip link set veth-ns1 up
sudo ip netns exec ns2 ip link set lo up
sudo ip netns exec ns2 ip link set veth-ns2 up
```

6. Add default gateway to setup connection between two namespaces:

```
sudo ip netns exec ns1 ip route add default via 192.168.0.1 dev veth-ns1
sudo ip netns exec ns2 ip route add default via 192.168.1.1 dev veth-ns2 
```

7. Test connectivity:

```
sudo ip netns exec ns1 ping -c 2 192.168.1.1
sudo ip netns exec ns2 ping -c 2 192.168.0.1
```
