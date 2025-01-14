echo -e "deb http://archive.debian.org/debian stretch main contrib non-free\ndeb http://archive.debian.org/debian-security stretch/updates main contrib non-free" | tee /etc/apt/sources.list > /dev/null
apt-get update
apt-get install -y git
git clone https://github.com/Shanksu7/fast_api_test app
cd app
git pull
mv /home/site/wwwroot/app/* /home/site/wwwroot/
cd /home/site/wwwroot/
rm -r app
chmod -x startup.sh