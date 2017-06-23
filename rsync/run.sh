docker rm -f rsync
docker run \
    --name rsync \
    --restart=always \
    -p 1873:873 \
    -v /root/dc2:/dc2 \
    -v `pwd`/rsyncd.conf:/etc/rsyncd.conf \
    -d bfosberry/rsync

