FROM cypress/base:10
RUN npm install --save-dev cypress
RUN $(npm bin)/cypress verify
RUN rm -rf /tmp/* /var/cache/apk/*
RUN ./node_modules/cypress/bin/cypress install

WORKDIR /var/www/occasions-mobile

EXPOSE 8100  

# Expose 3000 for mock server
EXPOSE 3000