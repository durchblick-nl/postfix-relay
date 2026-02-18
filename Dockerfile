FROM boky/postfix:latest

COPY init-sender-maps.sh /docker-init.db/
RUN chmod +x /docker-init.db/init-sender-maps.sh
