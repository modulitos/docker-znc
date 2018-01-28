echo sleep 3
sleep 3

apt-get update && apt-get install -y procps

cat /etc/nginx/nginx.conf
echo .
echo "Firing up nginx in the background."

# rm /etc/nginx/conf.d/default.conf
# ls -la /etc/nginx/conf.d
# echo "deleted default.conf!"
nginx

# Check user has specified domain name
if [ -z "$MY_DOMAIN_NAME" ]; then
    echo "Need to set MY_DOMAIN_NAME (to a letsencrypt-registered name)."
    exit 1
fi  

# This bit waits until the letsencrypt container has done its thing.
# We see the changes here bceause there's a docker volume mapped.
echo Waiting for folder /etc/letsencrypt/live/$MY_DOMAIN_NAME to exist
while [ ! -d /etc/letsencrypt/live/$MY_DOMAIN_NAME ] ;
do
    sleep 2
done

while [ ! -f /etc/letsencrypt/live/$MY_DOMAIN_NAME/fullchain.pem ] ;
do
	echo Waiting for file fullchain.pem to exist
    sleep 2
done

while [ ! -f /etc/letsencrypt/live/$MY_DOMAIN_NAME/privkey.pem ] ;
do
	echo Waiting for file privkey.pem to exist
    sleep 2
done

#go!
kill $(ps aux | grep 'nginx' | awk '{print $2}')
cp /etc/nginx/nginx-secure.conf /etc/nginx/nginx.conf

nginx -g 'daemon off;'