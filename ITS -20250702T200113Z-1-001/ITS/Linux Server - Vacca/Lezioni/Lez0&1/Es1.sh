#!/bin/bash 

# - chiedere percorso che vogliamo backuppare
# - crea directory per backup nella home (check se esiste già)
# - nome file backup deve avere data e ora dell'operazione (es: "backup-YYYYMMDD-HHMMSS.tar.gz")
# - deve dare conferma dell'operazione

# 1 chiederw cosa backuppare
echo "su quale directory devo eseguire il backup?"
read directory


#2 crea directory per backup/check se esiste già
#controlliamo se la dir esiste
if [ ! -d "$directory" ]; then 
    echo "la directory non esiste"
    exit 1
fi 
# gestiamo dir di backup in home con i controlli del caso
#creiamo la variabile nella dir di backup
backup_dir="$HOME/Backup"
#controllo se esiste già altrimenti la creo
if [ ! -d "$backup_dir" ]; then
    echo "la directory non esisteva fino ad adesso :)"
    mkdir -p "$backup_dir"
fi


#3 formattiamo data e ora corrente per il nome del backup
date_time_now=$(date "+%Y%m%d-%H%M%S")
#montiamo nome file di backup
file_backup="backup-$date_time_now.tar.gz"
#creo il file backup
tar -czf "$backup_dir/$file_backup" "$directory"


#4 creiamo la conferma
echo "backup eseguito della '$directory' dentro '$backup_dir/$file_backup' confermi operazione? " 