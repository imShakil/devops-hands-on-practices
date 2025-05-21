# Server Performance Stats

A basic shell script to check server performance stats (cpu, disk, memory). This script may provide following information:

- server information (os, uptime, last login, load avg)
- cpu usage
- disk usage (used, free space)
- memory (used, free, cached)
- top 5 processes filtered by cpu usage
- top 5 processes filtered by memory usage

## How to run?

1. Download the script: `wget https://raw.githubusercontent.com/imShakil/MyDevOpsJourney/refs/heads/main/projects/Server%20Performance%20Stats/server-stats.sh`
2. Give execute permission: `chmod +x server-stats.sh`
3. Execute the script: `./server-stats.sh`

## Output

You will get details of your linux server like below:

```shell
---
         MEMORY INFO         
Size:           7.8Gi
Used:           2.0Gi (25.64%)
Free:           3.9Gi (50.00%)
Cached:         1.9Gi (24.36%)
---
```

This project is part of: [roadmap.sh](https://roadmap.sh/projects/server-stats) DevOps projects.
