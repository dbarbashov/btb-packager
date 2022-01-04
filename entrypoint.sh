#!/bin/bash

cd /bot/binance-trade-bot
python3 -u -m binance_trade_bot &

cd /bot/BTB-manager-telegram
python3 -u -m btb_manager_telegram -s -p "../binance-trade-bot" -l ${TG_LANG} &

wait -n

exit $?