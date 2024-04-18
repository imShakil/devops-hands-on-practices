> # Problem: Create two namespace `red` and `green` and connect them using bridge. Setup a ingress-egress to make sure you can ping google dns from both of your namespaces.

# creating two namespace
```
sudo ip netns add red
sudo ip netns add green
```

# creating two veth peer
```
sudo ip link add veth-red type veth peer name veth-red-br
sudo ip link add veth-green type veth peer name veth-green-br
```

# creating a bridge network
```
sudo ip link add dev br0 type bridge
```

# connect each peer
```
sudo ip link set veth-red netns red
sudo ip link set veth-green netns green
sudo ip link set veth-red-br master br0
sudo ip link set veth-green-br master br0
```

# set ip address
```
sudo ip netns exec red ip addr add 10.10.0.10/16 dev veth-red
sudo ip netns exec green ip addr add 10.10.0.20/16 dev veth-green
```
# turn up all devices
```
sudo ip link set br0 up
sudo ip link set veth-red-br up
sudo ip link set veth-green-br up
sudo ip netns exec red ip link set dev lo up
sudo ip netns exec red ip link set dev veth-red up
sudo ip netns exec green ip link set dev lo up
sudo ip netns exec green ip link set dev veth-green up
```

# ping from one namespace to another 
```
sudo ip netns exec red ping -c 3 10.10.0.20
sudo ip netns exec green ping -c 3 10.10.0.10
```

# lets ping to host network

```
sudo ip netns exec red ping 192.168.0.132
```

Its output should be like `Host: network unreachbale`
Its because we did not add any ip and route to bridge network.

lets add route to our bridge network

# add ip in bridge network
```
sudo ip addr add 10.10.0.1/16 dev br0
```
# add route to namespace network
```
sudo ip netns exec red ip route add default via 10.10.0.1
sudo ip netns exec green ip route add default via 10.10.0.1
```

Now we can test route by ping to host network:

```
sudo ip netns exec red ping -c 2 192.168.0.132 
sudo ip netns exec green ping -c 2 192.168.0.132
```

# communicate with world

Let try to ping now on outside the host network like, google dns (8.8.8.8)
```
sudo ip netns exec red ping -c 2 8.8.8.8
```

We don't see anything

We can debug this using `tcpdump` while pinging google dns

```
sudo tcpdump -i br0 icmp
```
If doesn't show anything changes in terminal, that means packet not reached yet on bridge. So, We have to forward our ipv4.

# Fix ipv4 forward
```
sudo sysctl -w net.ipv4.ip_forward=1
```

Now lets try again:

```
sudo ip netns exec red ping 8.8.8.8
```

```
root@imshakil:~# sudo tcpdump -i br0
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on br0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
04:59:47.184264 IP 10.10.0.10 > dns.google: ICMP echo request, id 44177, seq 6838, length 64
04:59:48.208357 IP 10.10.0.10 > dns.google: ICMP echo request, id 44177, seq 6839, length 64
04:59:49.232219 IP 10.10.0.10 > dns.google: ICMP echo request, id 44177, seq 6840, length 64
04:59:50.256097 IP 10.10.0.10 > dns.google: ICMP echo request, id 44177, seq 6841, length 64
04:59:51.280134 IP 10.10.0.10 > dns.google: ICMP echo request, id 44177, seq 6842, length 64
04:59:52.304149 IP 10.10.0.10 > dns.google: ICMP echo request, id 44177, seq 6843, length 64
```


# NAT setup

So, packet sending is working upto bridge network. 
Let's try to see the host ethernet network `ensX` which is `ens33` in my case.

```
root@imshakil:~# sudo tcpdump -i ens33 icmp
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on ens33, link-type EN10MB (Ethernet), snapshot length 262144 bytes
```

If you look it doesn't show anything. Because, we can't communicate with the world using private network. Here it comes, NAT. 

```
sudo iptables --table nat -A POSTROUTING -s 10.10.0.0/16 ! -o app_br -j MASQUERADE
```

Now we can ping:

```
sudo ip netns exec red ping -c 2 8.8.8.8
sudo ip netns exec green ping -c 2 8.8.8.8
```



