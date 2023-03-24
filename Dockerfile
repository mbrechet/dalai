FROM nvidia/cuda:11.6.0-base-ubuntu20.04

RUN apt-get update \
    && apt-get install -y python3.9=3.9.5-3ubuntu0~20.04.1 python3-distutils=3.8.10-0ubuntu1~20.04 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /usr/bin/python3.9 /usr/local/bin/python


# The dalai server runs on port 3000
EXPOSE 3000

# Install dependencies
RUN apt-get update \
    && apt-get install -y \
    build-essential \
    curl \
    g++ \
    git \
    make \
    python3-venv \
    software-properties-common

# Add NodeSource PPA to get Node.js 18.x
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -

# Install Node.js 18.x
RUN apt-get update \
    && apt-get install -y nodejs

WORKDIR /root/dalai

COPY package*.json .
# Install dalai and its dependencies
RUN npm install

COPY . .

RUN npm run setup

RUN node bin/cli.js alpaca setup

# Run the dalai server
CMD [ "node", "bin/cli.js", "serve" ]

