FROM openresty/openresty:buster-fat

COPY vhost.nginx /etc/nginx/conf.d/default.conf
COPY lua/*.lua /etc/nginx/lua/

RUN echo "# Expose environment variables\nenv REDIS_HOST;\nenv REDIS_PORT;\nenv VSF_BACKEND_HOST;\nenv VSF_BACKEND_PORT;\n" >> /etc/openresty/nginx.conf
