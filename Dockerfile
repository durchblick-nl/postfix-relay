FROM boky/postfix:latest

COPY init-sender-maps.sh /docker-init.d/
RUN chmod +x /docker-init.d/init-sender-maps.sh
