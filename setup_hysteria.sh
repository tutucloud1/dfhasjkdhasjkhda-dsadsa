mkdir -p /opt/hysteria-server
mkdir -p /opt/hysteria-server/certs/live/tutusub.xyz

curl -o /opt/hysteria-server/docker-compose.yml https://o.oo0o.ooo/scripts/installment/tutu/docker-compose.yml 
curl -o /opt/hysteria-server/cloudflare.ini https://o.oo0o.ooo/scripts/installment/tutu/cloudflare.ini 
curl -o /opt/hysteria-server/server.yaml https://o.oo0o.ooo/scripts/installment/tutu/server.yaml 

curl -L https://raw.githubusercontent.com/tutucloud1/dfhasjkdhasjkhda-dsadsa/main/fullchain.pem -o /opt/hysteria-server/certs/live/tutusub.xyz/fullchain.pem
curl -L https://raw.githubusercontent.com/tutucloud1/dfhasjkdhasjkhda-dsadsa/main/privkey.pem -o /opt/hysteria-server/certs/live/tutusub.xyz/privkey.pem

chmod 644 /opt/hysteria-server/certs/live/tutusub.xyz/fullchain.pem
chmod 644 /opt/hysteria-server/certs/live/tutusub.xyz/privkey.pem

sed -i 's|/etc/letsencrypt/live/tutucloud.shop/|/etc/letsencrypt/live/tutusub.xyz/|g' /opt/hysteria-server/server.yaml

sed -i '/hysteria:/,/server.yaml/ s|volumes:|volumes:\n      - ./certs/live/tutusub.xyz:/etc/letsencrypt/live/tutusub.xyz|' /opt/hysteria-server/docker-compose.yml

docker compose -f /opt/hysteria-server/docker-compose.yml up -d hysteria

export DEBIAN_FRONTEND=noninteractive
apt-get install -y iptables iproute2 iptables-persistent

iptables -t nat -A PREROUTING -p udp --dport 20000:30000 -j REDIRECT --to-port 9443

netfilter-persistent save
docker compose -f /opt/hysteria-server/docker-compose.yml restart hysteria

echo "Hysteria服务已启动，使用导入的证书文件"
