/*
***************************************************************************
***************************************************************************
1) Eseguire il seguente codice di creazione tabella:
***************************************************************************
***************************************************************************
*/
CREATE TABLE ft_kpi_valori_medi (
    id_monitoraggio SERIAL NOT NULL,
    azienda VARCHAR(255),
    tot_budget_investimenti integer,
	tot_importo_transazioni integer,
	flag_budget_superiore_alla_media boolean,
	flag_importo_superiore_alla_media boolean,
	dt_update timestamp DEFAULT now(),	
    CONSTRAINT const_ft_monit_tr_pk PRIMARY KEY (id_monitoraggio)
);



/*
***************************************************************************
***************************************************************************
2) Realizzare e testare una funzione chiamata: roi_get_somma_budget_azienda() che:
	accetti come parametro in entrata l'identificativo di una azienda e restituisca 
	la "somma dei budget" degli investimenti per quella azienda.
	Nel caso non trovi l'azienda deve restituire 0
***************************************************************************
***************************************************************************
*/


/*
***************************************************************************
***************************************************************************
3) Realizzare e testare una funzione chiamata: roi_get_somma_importo_transazioni() che:
	accetti come parametro in entrata l'identificativo di una azienda e restituisca 
	la "somma degli importi di tutte le transazioni sui prodotti di quella azienda."
	Nel caso non trovi l'azienda deve restituire 0
***************************************************************************
***************************************************************************
*/

/*
***************************************************************************
***************************************************************************
4) Realizzare e testare una proceruda chiamata: roi_kpi_valori_medi() che:
	step1: cancella tutti i record della tabella: ft_kpi_valori_medi 
	step2: Cicla per ogni record della tabella: ft_azienda
		step2.1: Registra in una variabile la somma dei budget 
				 (richiamando la funzione roi_get_somma_budget_azienda)
		step2.2: Registra in una variabile la somma degli importi 
				 (richiamando la funzione roi_get_somma_importo_transazioni)
		step2.3: Inserisce un record nella tabella ft_kpi_valori_medi 
				 con i valori delle colonne:
			azienda (codice fiscale)
			tot_budget_investimenti
			tot_importo_transazioni
	step3: Cicla per ogni record della tabella ft_kpi_valori_medi
		step3.1: Registra in una variabile booleana, il valore TRUE se il totale budget 
				 è superiore alla "media di tutti i totali budget della tabella: ft_kpi_valori_medi"
		step3.2: Registra in una variabile booleana, il valore TRUE se il totale importo 
				 è superiore alla "media di tutti i totali importi della tabella: ft_kpi_valori_medi"
		step3.3: Fa l'update del record della tabella ft_kpi_valori_medi 
				 aggiungendo le informazioni registrate ai punti 4.1 e 4.2
***************************************************************************
***************************************************************************
*/