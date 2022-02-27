#FROM ubuntu
#FROM nginx:alpine
FROM nginx:1.21.1
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl && \
    apt-get install -y git
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y nginx git
#RUN rm -Rf /var/www/html/*
#COPY default.conf.template /etc/nginx/conf.d/default.conf.template
#COPY nginx.conf /etc/nginx/nginx.conf
RUN rm -Rf /usr/share/nginx/html/*
RUN git clone https://github.com/diranetafen/static-website-example.git /usr/share/nginx/html
#RUN useradd -m myuser
#USER myuser
COPY nginx.conf /etc/nginx/conf.d/default.conf

CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'
