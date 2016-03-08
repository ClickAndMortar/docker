FROM clickandmortar/apache-php

MAINTAINER Click & Mortar <contact@clickandmortar.fr>

# Supervisord
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Start
ADD entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

CMD ["/entrypoint.sh"]
