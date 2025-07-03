/*
***************************************************************************
***************************************************************************
                                LABORATORIO
Realizzare e testare una architettura Database complessa che gestisca 
   la TRASMISSIONE DATI "in DELTA" dalla tabella ft_prodotto, 
   lavorando per finestre temporali che agiscono sulla colonna dt_update.
   La procedura deve gestire correttamente:
		- la scrittura dei log nella tabella FT_LOG_MONITORAGGIO
		- i casi di "Exception"
		- la riestrazione dello stesso periodo temporale nel caso in cui l'esecuzione precedente sia andata in errore.
		
   La configurazione della finestra temporale deve essere letta e salvata 
   nella tabella di configurazione: dm_configurazione_export.
   
   La trasmissione consisterà nello scrivere i record in DELTA 
   all'interno della tabella: ft_prodotto_export inserendo nella colonna: record_csv
   tutti i valori delle colonne della tabella ft_prodotto concatenati in formato CSV
   usando come carattere separatore la VIRGOLA.
***************************************************************************
***************************************************************************
*/

/*
***************************************************************************
***************************************************************************
                     OPERAZIONI PRELIMINARI
    Eseguire i seguenti codici al fine di creare e popolare la tabella 
	     di configurazione e la tabella di Export dei dati.
***************************************************************************
***************************************************************************
*/

/*creazione tabella di configurazione export*/
CREATE TABLE dm_configurazione_export (
	tracciato varchar(1000) NOT NULL,
	dt_inizio timestamp NULL,
	dt_fine timestamp NULL,
	esito bool NULL,
	CONSTRAINT const_dm_conf_export_pk PRIMARY KEY (tracciato)
);

/*inserisco i record nella tabella di configurazione*/
insert into dm_configurazione_export
	(tracciato, dt_inizio, dt_fine, esito)
VALUES
	('ft_prodotto','1900-01-01',now(),FALSE),
	('ft_azienda','1900-01-01',now(),FALSE),
	('ft_cliente','1900-01-01',now(),FALSE),
	('ft_investimento','1900-01-01',now(),FALSE),
	('ft_recensione','1900-01-01',now(),FALSE),
	('ft_transazione','1900-01-01',now(),FALSE)
;

/*creazione tabella di esportazione dei prodotti*/
CREATE TABLE ft_prodotto_export (
	id_export SERIAL NOT NULL,
	record_csv varchar(4000) NOT NULL,
	dt_update timestamp NOT NULL DEFAULT now(),
	CONSTRAINT const_ft_prodotto_export_pk PRIMARY KEY (record_csv, dt_update)
);


/*
***************************************************************************
***************************************************************************
1) Realizzarare la procedura ft_prodotto_export() che esegue quanto richiesto 
   nel presente laboratorio.
***************************************************************************
***************************************************************************
*/

create or replace function ft_prodotto_export()
language plpgsql
as $$
declare
begin
    
end;
$$;

