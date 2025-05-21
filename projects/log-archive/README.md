# Log Archive Tool

A very basic log archive python program to create and send zipfile from a given log directory.

- create zip of logs from given directory
- set custom zip file name
- choose output path to save zipfile
- verbose to print each line
- version to show current program version

## How to run?

- Download the script: `wget https://raw.githubusercontent.com/imShakil/devops-lab/refs/heads/main/projects/log-archive/log-archive.py`
- Execute permission: `chmod +x log-archive.py`
- Execute the script

## Run program as a command [Optional]

- Download the script as already shown: `wget https://raw.githubusercontent.com/imShakil/devops-lab/refs/heads/main/projects/log-archive/log-archive.py`

- Give execute permission: `chmod +x log-archive.py`
- Move script: `sudo mv log-archive.py /usr/local/bin/log-archive`
- finally run: `log-archive -h`

## Available Command Options

```shell
log-archive -h
```

```text
imshakil@35240218232:~$ log-archive -h
usage: Log Archiver [-h] [-n NAME] [-o OUTPUT] [-s] [-v] [--version] log_dir

Archive your logs and send it to mail

positional arguments:
  log_dir               full path of your logs to archive

options:
  -h, --help            show this help message and exit

archive options:
  -n NAME, --name NAME  Archive file name, default is: log_archive_timestamp.zip
  -o OUTPUT, --output OUTPUT
                        Path to save the log archive, default is current directory
  -s, --sendmail        Send it given user email, it will prompt to take mailing info.

mode:
  -v, --verbose         Choose to see details information
  --version             Print version

Examples: Basic usage (creates archive in current directory): python log_archiver.py /var/log/myapp With custom output directory: python log_archiver.py /var/log/myapp -o ~/tmp With
custom archive name: python log_archiver.py /var/log/myapp -n myapp_logs.zip

```

> ref: [roadmap.sh](https://roadmap.sh/projects/log-archive-tool)
