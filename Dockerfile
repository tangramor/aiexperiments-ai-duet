FROM ubuntu:14.04

RUN apt-get update && apt-get install -y \
    pkg-config \
    libpng-dev \
    libjpeg8-dev \
    libfreetype6-dev \
    libblas-dev \
    liblapack-dev \
    libatlas-base-dev \
    gfortran \
    python \
    python-dev \
    python-pip \
    curl && \
    curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash - && \
    apt-get install -y nodejs

#Fix Python 2.7 bugs
RUN pip install -U numpy==1.16.6 && pip install -U scipy==1.2.1 && pip install https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.12.1-cp27-none-linux_x86_64.whl

COPY ./server/requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt

COPY . /src/

WORKDIR /src/static/
RUN npm install && npm run build

WORKDIR /src/server/

EXPOSE 8080
ENTRYPOINT python server.py
