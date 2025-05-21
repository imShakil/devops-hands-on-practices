# NGINX Log Analyzer

This is a simple shell script to analysis nginx server log. With this script, we can check -

    - most requested from IP
    - most requested paths
    - most response
    - User agents

## How to Use?

1. Download the [`script`](./nginx-log-analyzer.sh)
2. set excute permission: `chmod +x ./nginx-log-analyzer.sh`
3. execute the script: `./nginx-log-analyzer.sh logfile`

    example:
    ```bash
    ./nginx-log-analyzer.sh /var/log/nginx/nginx-access.log
    ```

> ref: https://roadmap.sh/projects/nginx-log-analyser
