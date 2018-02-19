FROM debian:wheezy
ENV OPENSSL_TARGET 'linux-x86_64'
ENV OPENSSL_FLAGS 'no-idea no-mdc2 no-rc5 no-zlib enable-tlsext no-ssl2 no-ssl3 no-ssl3-method enable-rfc3779 enable-cms'
# In case the old package URL is still being used
RUN sed -i 's/http\.debian\.net/httpredir\.debian\.org/g' /etc/apt/sources.list

# Installing packages for development tools
RUN apt-get -y update && apt-get install -y build-essential git flex bison gperf python ruby git libfontconfig1-dev
# Preparing to download Debian source package
RUN echo "deb-src http://httpredir.debian.org/debian wheezy main" >> /etc/apt/sources.list
RUN apt-get -y update
# Recompiling OpenSSL for ${OPENSSL_TARGET}..."
RUN apt-get source openssl
RUN cd openssl-1.0.1e \
    && ./Configure --prefix=/usr --openssldir=/etc/ssl --libdir=lib ${OPENSSL_FLAGS} ${OPENSSL_TARGET} \
    && make depend \
    && make \
    && make install \
    && cd ..

# Building the static version of ICU library
RUN apt-get source icu \
    && cd icu-4.8.1.1/source \
    && ./configure --prefix=/usr --enable-static --disable-shared \
    && make \
    && make install \
    && cd ..
