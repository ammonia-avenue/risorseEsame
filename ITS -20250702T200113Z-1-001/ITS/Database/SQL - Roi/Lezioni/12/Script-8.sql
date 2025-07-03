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

INSERT INTO ft_kpi_valori_medi (azienda, tot_budget_investimenti, tot_importo_transazioni, flag_budget_superiore_alla_media, flag_importo_superiore_alla_media)
VALUES ('Azienda_001', 100000, 50000, false, false);
INSERT INTO ft_kpi_valori_medi (azienda, tot_budget_investimenti, tot_importo_transazioni, flag_budget_superiore_alla_media, flag_importo_superiore_alla_media)
VALUES ('Azienda_001', 200000, 50000, false, false);
INSERT INTO ft_kpi_valori_medi (azienda, tot_budget_investimenti, tot_importo_transazioni, flag_budget_superiore_alla_media, flag_importo_superiore_alla_media)
VALUES ('Azienda_001', 300000, 50000, false, false);

INSERT INTO ft_kpi_valori_medi (azienda, tot_budget_investimenti, tot_importo_transazioni, flag_budget_superiore_alla_media, flag_importo_superiore_alla_media)
VALUES ('Azienda_002', 150000, 75000, false, false);

INSERT INTO ft_kpi_valori_medi (azienda, tot_budget_investimenti, tot_importo_transazioni, flag_budget_superiore_alla_media, flag_importo_superiore_alla_media)
VALUES ('Azienda_003', 200000, 100000, true, true);

create or replace function roi_get_somma_budget_azienda(idf_azienda varchar)
returns integer
language plpgsql
as $$
declare
    somma_budget integer;
begin
    select 
		coalesce(sum(tot_budget_investimenti), 0) --restituisce 0
    into somma_budget
    from 
		ft_kpi_valori_medi
    where 
		azienda = idf_azienda; 

    return somma_budget;
end;
$$;

select roi_get_somma_budget_azienda('Azienda_001');

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

create or replace function roi_get_somma_importo_transazioni(idf_azienda varchar)
returns integer
language plpgsql
as $$
declare
    somma_transazioni integer;
begin
    select 
		coalesce(sum(tot_importo_transazioni), 0) --restituisce 0
    into somma_transazioni
    from 
		ft_kpi_valori_medi
    where 
		azienda = idf_azienda; 

    return somma_transazioni;
end;
$$;

select roi_get_somma_importo_transazioni('Azienda_001');

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