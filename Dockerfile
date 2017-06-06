FROM php:7.0-fpm

COPY ./sources.list /etc/apt/sources.list


RUN apt-get update -qq \
	&& apt-get install -y locales -qq \ 
	&& locale-gen en_US.UTF-8 en_us  \
	&& locale-gen zh_CN.UTF-8 zh_cn  \
	&& locale-gen ug_CN ug_cn  

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# ug_CN UTF-8/ug_CN UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8




RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        gettext \
        php-gettext \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd iconv mcrypt pdo pdo_mysql mysqli gettext


COPY php.ini /usr/local/etc/php/
