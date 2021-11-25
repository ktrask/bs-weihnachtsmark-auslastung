#!/bin/bash

if [[ ! -f auslastung.csv ]]
then
    cp auslastung_dummy.csv auslastung.csv
fi

while :
do
  date
  python3 getAuslastung.py
  sleep 60
done
