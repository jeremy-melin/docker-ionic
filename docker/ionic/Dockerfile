FROM node:12.19.0-alpine3.12

# Build args
ARG GITHUB_USERNAME=""
ARG GITHUB_PASSWORD=""

#ENVIRONNEMENT
ENV GLIB_PACKAGE_BASE_URL https://github.com/sgerrand/alpine-pkg-glibc/releases/download
ENV GLIB_VERSION 2.25-r0

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk

ENV GRADLE_HOME /usr/local/gradle
ENV GRADLE_VERSION 6.8.3

ENV ANDROID_BUILD_TOOLS_VERSION 30.0.3
ENV SDK_TOOLS "6609375"
ENV ANDROID_HOME "/opt/sdk"
ENV PATH $PATH:${ANDROID_HOME}/cmdline-tools/tools/bin:${ANDROID_HOME}/platform-tools

ENV IONIC_VERSION 6
ENV CORDOVA_VERSION 10

ENV PATH ${GRADLE_HOME}/bin:${JAVA_HOME}/bin:${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:${ANDROID_HOME}/build-tools/30.0.3:$PATH


# INSTALL JAVA
RUN apk add curl openjdk8-jre openjdk8

# INSTALL IONIC AND CORDOVA
RUN npm install -g cordova@${CORDOVA_VERSION}
RUN npm install -g @ionic/cli

#INSTALL Gradle
RUN mkdir -p ${GRADLE_HOME} && \
  curl -L https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip > /tmp/gradle.zip && \
  unzip /tmp/gradle.zip -d ${GRADLE_HOME} && \
  mv ${GRADLE_HOME}/gradle-${GRADLE_VERSION}/* ${GRADLE_HOME} && \
  rm -r ${GRADLE_HOME}/gradle-${GRADLE_VERSION}/

# Install required dependencies
RUN apk add --no-cache bash git unzip wget && \
    apk add --virtual .rundeps $runDeps && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/* && \
    # Download and extract Android Tools
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-${SDK_TOOLS}_latest.zip -O /tmp/tools.zip && \
    mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    unzip -qq /tmp/tools.zip -d ${ANDROID_HOME}/cmdline-tools && \
    rm -v /tmp/tools.zip && \
    # Install SDK Packages
    mkdir -p ~/.android/ && touch ~/.android/repositories.cfg && \
    yes | sdkmanager --sdk_root=${ANDROID_HOME} --licenses && \
    sdkmanager --sdk_root=${ANDROID_HOME} "platform-tools" "extras;android;m2repository" "extras;google;m2repository" "extras;google;instantapps" && \
    sdkmanager --update && \ 
    sdkmanager "build-tools;"${ANDROID_BUILD_TOOLS_VERSION}

RUN apk add --no-cache git
RUN apk add --update openssh

## Store git credentials in order to download private dependencies
RUN git config --global credential.helper store && \
    echo "https://"${GITHUB_USERNAME}":"${GITHUB_PASSWORD}"@github.com" >> ~/.git-credentials

# INSTALL GLIBC
RUN curl -L https://raw.githubusercontent.com/wassim6/alpine-pkg-glibc/master/sgerrand.rsa.pub > /etc/apk/keys/sgerrand.rsa.pub && \
  curl -L ${GLIB_PACKAGE_BASE_URL}/${GLIB_VERSION}/glibc-${GLIB_VERSION}.apk > /tmp/glibc.apk && \
  curl -L ${GLIB_PACKAGE_BASE_URL}/${GLIB_VERSION}/glibc-bin-${GLIB_VERSION}.apk > /tmp/glibc-bin.apk && \
  apk add /tmp/glibc-bin.apk /tmp/glibc.apk

#FILES DELETION
RUN rm -rf /tmp/* /var/cache/apk/*

WORKDIR /var/www/occasions-mobile

# Expose 8100 for ionic dev server
EXPOSE 8100  

# Expose 3000 for mock server
EXPOSE 3000