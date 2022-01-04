#!/bin/bash
DATABASE=../binance-trade-bot/data/crypto_trading.db
while read p; do
   echo -n "Coin: "
   echo $p
   jumps=$(sqlite3 -cmd '.timeout 1000' $DATABASE "select count(id) from trade_history where alt_coin_id='$p' and selling=0 and state='COMPLETE';")
   if [[ $jumps -gt 0 ]]
   then
	first_date=$(sqlite3 -cmd '.timeout 1000' $DATABASE "select datetime from trade_history where alt_coin_id='$p' and selling=0 and state='COMPLETE' order by id asc limit 1;")
	echo -n "First coin bought at: "
	echo $first_date
     echo -n "Starting value: "
     first_value=$(sqlite3 -cmd '.timeout 1000' $DATABASE "select alt_trade_amount from trade_history where alt_coin_id='$p' and selling=0 and state='COMPLETE' order by id asc limit 1;")
     echo $first_value
     echo -n "Last value: "
     last_value=$(sqlite3 -cmd '.timeout 1000' $DATABASE "select alt_trade_amount from trade_history where alt_coin_id='$p' and selling=0 and state='COMPLETE' order by id DESC limit 1;")
     echo $last_value
     echo -n "Grow: "
     grow=$(awk "BEGIN {print ($last_value/$first_value*100)-100}")
     echo -n $grow
     echo "%"
	echo -n "Starting value: "
	crypto_coin_id=$(sqlite3 -cmd '.timeout 1000' $DATABASE "select crypto_coin_id from trade_history where alt_coin_id='$p' and selling=0 and state='COMPLETE' order by id asc limit 1;")
	first_value2=$(sqlite3 -cmd '.timeout 1000' $DATABASE "select crypto_trade_amount from trade_history where alt_coin_id='$p' and selling=0 and state='COMPLETE' order by id asc limit 1;")
	echo -n $first_value2
     echo -n " "
     echo $crypto_coin_id
     echo -n "Last value Buy/Sell: "
     last_valueb=$(sqlite3 -cmd '.timeout 1000' $DATABASE "select crypto_trade_amount  from trade_history where alt_coin_id='$p' and selling=0 and state='COMPLETE' order by id DESC limit 1;")
     last_values=$(sqlite3 -cmd '.timeout 1000' $DATABASE "select crypto_trade_amount  from trade_history where alt_coin_id='$p' and selling=1 and state='COMPLETE' order by id DESC limit 1;")

     echo -n $last_valueb
     echo -n " / "
     echo -n " "
     echo -n $last_values
     echo $crypto_coin_id
     echo -n "Grow Buy/Sell: "
     growb=$(awk "BEGIN {print ($last_valueb/$first_value2*100)-100}")
     grows=$(awk "BEGIN {print ($last_values/$first_value2*100)-100}")
     echo -n $growb
     echo -n "% / "
     echo -n $grows
     echo "%"
	echo -n "Number of trades: "
	echo $jumps
   else
     echo "Coin has not yet been bought"
   fi
     echo
done <../binance-trade-bot/supported_coin_list