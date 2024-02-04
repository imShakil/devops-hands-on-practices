# Connecting two namespaces using Linux Bridge Networking

0. Lets check the `ip link` interfaces:
```
sudo ip link show
```
The output will be almost similar like below:
```
root@imShakil-decent-cobra:~# sudo ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether e6:c8:d7:e4:8e:e1 brd ff:ff:ff:ff:ff:ff
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether ee:be:eb:45:72:a3 brd ff:ff:ff:ff:ff:ff
```
Here, `lo`, `eth0`, `eth1` are the network interfaces.

Lets check routing table:

```
sudo route -n
```

```
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         157.245.128.1   0.0.0.0         UG    0      0        0 eth0
10.10.0.0       0.0.0.0         255.255.0.0     U     0      0        0 eth0
10.136.0.0      0.0.0.0         255.255.0.0     U     0      0        0 eth1
157.245.128.0   0.0.0.0         255.255.240.0   U     0      0        0 eth0
```

If we look at this routing table, 

1. Lets create two network namespace:

```
sudo ip netns add ss1
sudo ip netns add ss2
```

It will create two network namespaces `ss1`, and `ss2`. We can check if they are created or not with this command:
```
sudo ip netns list
```
It will display the list of namespaces.

2. Lets up `ss1` and `ss2` namespaces:
By default, newly created namespaces are not running up. So, we need to turned them up:

```
sudo ip netns exec ss1 ip link set lo up
sudo ip netns exec ss2 ip link set lo up
```

With these commands, we turned up loopback interfaces on both network namespaces. To check, we can run:

```
sudo ip netns exec ss1 ip link
sudo ip netns exec ss2 ip link
```

3. Lets create a bridge network on host:

```
sudo ip link add br0 type bridge
sudo ip link set br0 up
```

We can check `ip link`:
```
sudo ip link
```

```
root@imShakil-decent-cobra:~# ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether e6:c8:d7:e4:8e:e1 brd ff:ff:ff:ff:ff:ff
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether ee:be:eb:45:72:a3 brd ff:ff:ff:ff:ff:ff
4: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether 22:d5:3c:d2:bb:5e brd ff:ff:ff:ff:ff:ff
```
3. Configure IP address to created bridge network (`br0`):

Let check ip address:

```
ip a
```

```
root@imShakil-decent-cobra:~# ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether e6:c8:d7:e4:8e:e1 brd ff:ff:ff:ff:ff:ff
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether ee:be:eb:45:72:a3 brd ff:ff:ff:ff:ff:ff
4: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether 22:d5:3c:d2:bb:5e brd ff:ff:ff:ff:ff:ff
root@imShakil-decent-cobra:~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether e6:c8:d7:e4:8e:e1 brd ff:ff:ff:ff:ff:ff
    inet 157.245.128.208/20 brd 157.245.143.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet 10.10.0.6/16 brd 10.10.255.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 2604:a880:400:d0::1880:d001/64 scope global
       valid_lft forever preferred_lft forever
    inet6 fe80::e4c8:d7ff:fee4:8ee1/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether ee:be:eb:45:72:a3 brd ff:ff:ff:ff:ff:ff
    inet 10.136.33.102/16 brd 10.136.255.255 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::ecbe:ebff:fe45:72a3/64 scope link
       valid_lft forever preferred_lft forever
4: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 22:d5:3c:d2:bb:5e brd ff:ff:ff:ff:ff:ff
    inet6 fe80::20d5:3cff:fed2:bb5e/64 scope link
       valid_lft forever preferred_lft forever
```

If you see our created br0 has no Ip addess, since we did not assign any ip address yet. Let assign IP address to `br0`:

```
sudo ip addr add 192.168.1.1/24 dev br0
```

we can ping to ensure that ip address is assigned and working:

```
ping -c 3 192.168.1.1
```

4. Create two veth pair for two namespaces:

for `ss1`:

```
sudo ip link add veth0 type veth peer name ceth0
sudo ip link set veth0 master br0
sudo ip link set veth0 up
```

Connect `ceth0` end to the `ss1`:

```
sudo ip link set ceth0 netns ss1
sudo ip netns exec ss1 ip link set ceth0 up
sudo ip netns exec ss1 ip link
sudo ip link
```

Lets do the same for `ss2`:

```
sudo ip link add veth1 type veth peer name ceth1
sudo ip link set veth1 master br0
sudo ip link set veth1 up
sudo ip link set ceth1 netns ss2
sudo ip netns exec ss2 ip link set ceth1 up
sudo ip netns exec ss2 ip link
sudo ip link
```

5. Add ip address to this pair of veth network:

```
sudo ip netns exec ss1 ip addr add 192.168.1.10/24 dev ceth0
sudo ip netns exec ss2 ip addr add 192.168.1.11/24 dev ceth1
```

6. Lets verify the connectivity:

```
ping -c 2 192.168.1.1
ping -c 2 192.168.1.10
ping -c 2 192.168.1.11

sudo ip netns exec ss1 ping -c 2 192.168.1.11
sudo ip netns exec ss2 ping -c 2 192.168.1.10
```

