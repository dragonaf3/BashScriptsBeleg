#!/usr/bin/env bash

#Wert, welcher aus der txt Datei ausgelesen wird
anzahl=$(cat anzahl.txt)

for ((i = 0; i < 50; i++)); do
  zufallUser=$(($RANDOM % anzahl))
  zufallVM=$(($RANDOM % anzahl))
  ssh user$zufallUser@vm$zufallVM touch IchWarHier.txt
done

