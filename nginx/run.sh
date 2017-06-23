
#you need to mount /mnt/soichifs as nginx so that nginx can access it (sshfs limiation?)
docker rm -f nginx
docker run --name nginx \
	-v /root/o3d/data:/usr/share/nginx/html \
	-v `pwd`/nginx.conf:/etc/nginx/nginx.conf \
	-p 0.0.0.0:80:80 \
	-d nginx
#-p 0.0.0.0:443:443 \
#-v /root/dc2karst/Downloads/dc2git/git-dc2karst:/usr/share/nginx/html \
#-v `pwd`/html:/usr/share/nginx/html \
