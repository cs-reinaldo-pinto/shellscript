#!/bin/bash

branchs=(`git branch -a |grep -i 'origin'|grep -iv 'HEAD' |awk -F"/"  '{print $(NF)}' | tr 'a-z' 'A-Z'`)

# ${branchs[@]} #Print conteudo array
# ${!branchs[@]} #Print numero de indices
# ${#branchs[@]} #Print qtd de indices

#Cria um novo array(compareArray) e add todas as strings do array anterior(branchs).
for ((i=0; i < ${#branchs[@]}; i++)); do
   compareArray[$i]=${branchs[$i]^^}
done

#1 For passa no array branchs, 2 For passa no array compareArray. Compara as strings e mostra as repetidas.
for ((i=0; i < ${#branchs[@]}; i++)); do
  for ((x=0; x < ${#compareArray[@]}; x++)); do
	if [ ${branchs[$i]} == ${compareArray[$x]} ]; then
	   echo "A ${branchs[$i]} e igual ${compareArray[$x]}" 
  	fi
  done
done

