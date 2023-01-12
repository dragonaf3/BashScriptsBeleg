#!/usr/bin/env bash

#Wert, welcher aus der txt Datei ausgelesen wird
anzahl=$(cat anzahl.txt)

#Aktuelles Datum mit Uhrzeit als Datei-Name
fileName="Auswertung_$(date +"%F_%T").txt"

mkdir Auswertungen
cd Auswertungen/
touch $fileName

for ((i = 0; i < anzahl; i++)); do

#Ausgabe der Anzahl der Logins
  echo "User$i has number of logins:" >>$fileName
  grep -c "session opened for user user$i" /var/log/auth.log >>$fileName
  echo "" >>$fileName

#Ausgabe des ersten Logins mit Zeitangabe
  echo "First login of User$i :" >>$fileName
  cat /var/log/auth.log | grep "user$i" | awk '{print $1, $2, $3}' | head -1 >>$fileName
  echo "" >>$fileName

#Ausgabe des letzten Logins mit Zeitangabe
  echo "Last login of User$i :" >>$fileName
  cat /var/log/auth.log | grep "user$i" | awk '{print $1, $2, $3}' | tail -1 >>$fileName
  echo "" >>$fileName

#Ausgabe der Zeitdifferenz des ersten Logins und letzten Logins
  # Speichern der Anmeldezeiten in einer Liste
  logins=$(cat /var/log/auth.log | grep "user$i" | awk '{print $1, $2, $3}')

  # Konvertieren der Anmeldezeiten in die Epochenzeit, zum rechnen damit (Anzahl der Sekunden seit dem 1. Januar 1970)
  first_login=$(date -d "$(echo "$logins" | head -1)" +%s)
  last_login=$(date -d "$(echo "$logins" | tail -1)" +%s)

  # Berechnen des Zeitunterschieds in Sekunden
  diff=$((last_login-first_login))

  # Konvertieren der Sekunden in Stunden, Minuten und Sekunden
  hours=$((diff / 3600))
  minutes=$(((diff % 3600) / 60))
  seconds=$((diff % 60))

  # Ausgabe der der Zeitdifferenz
  echo "The time difference between first and last login was:" >>$fileName
  printf "%02d:%02d:%02d\n" $hours $minutes $seconds >>$fileName
  echo "" >>$fileName

#Ausgabe der durchschnittlichen Zeitdifferenz der Logins
  #Speichern der Login-Anzahl in einer Variable und Berechnung der durchschnittlichen Zeitdifferenz (noch in Sekunden)
  countLogin=$(grep -c "session opened for user user$i" /var/log/auth.log)
  diffAverage=$((diff / countLogin))

  #Wieder umrechnen in Stunden, Minuten, Sekunden
  hours=$((diffAverage / 3600))
  minutes=$(((diffAverage % 3600) / 60))
  seconds=$((diffAverage % 60))

  #Ausgabe der Zeitdifferenz
  echo "During the first and last login the user logged in on average every:" >>$fileName
  printf "%02d:%02d:%02d\n" $hours $minutes $seconds >>$fileName
  echo "" >>$fileName


  #Abschluss
  echo "_____________________________________________________" >>$fileName

done
