FROM python:3.8.12-slim

WORKDIR /bot

# Install dependencies
RUN apt-get update && apt-get install -y git sqlite3 gcc g++ libfreetype6-dev pkg-config

# Env variable below is used to specify bot version
# Edeng23: git clone https://github.com/edeng23/binance-trade-bot.git
# Idkravtiz: git clone https://github.com/idkravitz/binance-trade-bot.git
# Tntwist: git clone https://github.com/tntwist/binance-trade-bot.git
# Mila432 (Homersimpson): git clone https://github.com/Mila432/binance-trade-bot.git
# MasaiasuOse: git clone https://github.com/MasaiasuOse/binance-trade-bot.git
# Specific branch: git clone -b websockets-idkravitz --single-branch https://github.com/idkravitz/binance-trade-bot.git
ENV BINANCE_BOT_VERSION="git clone https://github.com/MasaiasuOse/binance-trade-bot.git"
# Telegram bot language
ENV TG_LANG=en

# Clone binance bot
RUN $BINANCE_BOT_VERSION
# Install bot requirements
RUN pip3 install -r /bot/binance-trade-bot/requirements.txt
# Put configs in their places
COPY config_example/user.cfg /bot/binance-trade-bot/user.cfg
COPY config_example/supported_coin_list /bot/binance-trade-bot/supported_coin_list
COPY config_example/apprise.yml /bot/binance-trade-bot/config/apprise.yml

# Clone telegram manager
RUN git clone https://github.com/lorcalhost/BTB-manager-telegram.git
# Install telegram manager requirements
RUN pip3 install -r /bot/BTB-manager-telegram/requirements.txt
# Copy custom scripts config
COPY ./config_example/custom_scripts.json /bot/BTB-manager-telegram/config/custom_scripts.json
# Copy custom scripts
COPY ./custom_scripts /bot/BTB-manager-telegram/custom_scripts
RUN chmod +x /bot/BTB-manager-telegram/custom_scripts/*.sh

# Clone chart plugin
RUN git clone https://github.com/marcozetaa/binance-chart-plugin-telegram-bot.git
# Install its requirements
RUN pip3 install -r /bot/binance-chart-plugin-telegram-bot/requirements.txt
# Copy config_example
COPY config_example/btb-chart-config /bot/binance-chart-plugin-telegram-bot/config

COPY ./entrypoint.sh /bot/entrypoint.sh

ENTRYPOINT [ "bash", "/bot/entrypoint.sh" ]