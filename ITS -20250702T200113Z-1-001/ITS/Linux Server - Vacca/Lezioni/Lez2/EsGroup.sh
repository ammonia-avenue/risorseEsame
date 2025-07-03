#!/bin/bash 

#creare un programma che permetta di visualizzare la 
#lista di tutti i gruppi presenti nella macchina azureuser

echo "Lista gruppi"
cat /etc/group
#controlla perché

#getent group $(getent passwd | grep '/bin/bash' | cut -d: -f4) | cut -d: -f1

#group