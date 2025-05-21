# Migrating Jenkins Container from One Host To Another

## Caution

- Identify the Jenkins version you are using, it should be the same image on the new host
- Both server should be able to communicate with each other usin SSH

## Identity Jenkins Home Directory

On your current server, find the volume used to persist jenkins data. If you are using bind mounts volume try to find the location using following command:

```shell
docker inspect jenkins-container-name | grep volume
```

of if using docker named volume:

```shell
docker volume ls
```

## Backup Jenkins Data

Before creating a backup, make sure jenkins server stopped:

```shell
docker stop jenkins-container-name
```

Archive the jenkins home data:

```shell
tar -czvf jenkins_backup.tar.gz /path/of/bind/mount
```

If it's a named volume:

```shell
docker run --rm -v jenkins_home:/data -v $(pwd):/backup alpine \
tar czvf /backup/jenkins_backup.tar.gz -C /data .
```

> Here, we have used a new container using `alpine` image to create a backup of `jenkins` docker volume. it will create a `jenkins_backup.tar.gz` file in your current directory.

## Transfer to New Server

Copy the backup file to new server:

```shell
scp jenkins_backup.tar.gz user@new_host:/path/to/new_host
```

## Restore Data

You can extract data into a directory to use as bind mount or a docker volume. 

To extract into a directory:

```shell
mkdir -p /var/jenkins_home
tar -xzvf jenkins_backup.tar.gz -C /var/jenkins_home
chown -R 1000:1000 /var/jenkins_home
```

To extract into a docker volume:

```shell
# create docker volume
docker volume create jenkins_home

# extract data into this volume and fix file permissions
docker run --rm -v jenkins_home:/data -v /directory_path/of/backup_file/:/backup alpine \
sh -c "cd /data && tar xzvf /backup/jenkins_backup.tar.gz && chown -R 1000:1000 /data"
```

> What's happening here?: docker creating a new alpine container using jenkins_home volume, and extracted backup data into that directory and modified the files permission.

## Run Jenkins on the New Host

Let's run the jenkins container on the new host with resorted data volume.

```shell
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
```

We are done.
