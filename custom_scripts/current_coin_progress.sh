#!/bin/bash
sqlite3 -cmd '.timeout 1000' ../binance-trade-bot/data/crypto_trading.db "select id,alt_trade_amount, datetime, alt_coin_id from trade_history where selling=0 and state='COMPLETE' and alt_coin_id=(select alt_coin_id from trade_history order by id DESC limit 1);" > results
starting_value=$(sed -n '1p' results| awk -F\| '{print $2}')
while read p; do
   echo -n "Trade no: "
   echo $p | awk -F\| '{print $1}'
   echo -n "Hodlings: "
   echo $p | awk -F\| '{print $2}'
   echo -n "Date: "
   echo $p | awk -F\| '{print $3}'
   echo -n "Grow: "
   value=$(echo $p | awk -F\| '{print $2}')
   grow=$(awk "BEGIN {print ($value/$starting_value*100)-100}")
   echo -n $grow
   echo "%"
   echo
done <results
echo -n "Current coin: "
echo $(sed -n '1p' results| awk -F\| '{print $4}')