--SOLUZIONI

---------------------------------------------------------------------------
-------------------ESERCIZI SQL--------------------------------------------
------------------(DISPENSE ROI)-------------------------------------------
-------------- R02c Scrittura di stored procedures e triggers_01 ----------
---------------------------------------------------------------------------


/*
***************************************************************************
***************************************************************************
1) Realizzare e testare una funzione chiamata: get_valore_doppio() che:
	accetti come parametro in entrata un valore numerico decimale
	e restituisca il valore doppio.
	TESTARE LA FUNZIONE scrivendo: select NOME_FUNZIONE(parametro);

***************************************************************************
***************************************************************************
*/

CREATE OR REPLACE FUNCTION public.get_valore_doppio(p_valore numeric)
 RETURNS numeric
 LANGUAGE plpgsql
AS $$
/*
 Questa funzione accetta come parametro in entrata un numero decimale e 
 restituisce il valore raddoppiato.
*/
declare
	valore_doppio numeric;
begin
	
	--setto la variabile con il valore raddoppiato
	valore_doppio := p_valore*2;

	--restituisco il risultato
	return valore_doppio;
end; $$




/*
***************************************************************************
***************************************************************************
2) Realizzare una funzione chiamata: get_valore_dimezzato() che:
	accetti come parametro in entrata un valore numerico decimale
	e restituisca il valore dimezzato

	Realizzare una procedura che esegua al suo interno la funzione: get_valore_dimezzato()

	TESTATE LA PROCEDURA PASSANDO COME PARAMETRO ALLA FUNZIONE: 0

***************************************************************************
***************************************************************************
*/



CREATE OR REPLACE FUNCTION public.get_valore_dimezzato(p_valore numeric)
 RETURNS numeric
 LANGUAGE plpgsql
AS $$
/*
 Questa funzione accetta come parametro in entrata un numero decimale e 
 restituisce il valore dimezzato.
*/
declare
	valore_dimezzato numeric;
begin
	
	--setto la variabile con il valore raddoppiato
	valore_dimezzato := p_valore/2;

	--restituisco il risultato
	return valore_dimezzato;
end; $$




---------------------------------------------------------------------------
-------------------ESERCIZI SQL--------------------------------------------
------------------(DISPENSE ROI)-------------------------------------------
-------------- R02c Scrittura di stored procedures e triggers_02 ----------
---------------------------------------------------------------------------

/*
***************************************************************************
***************************************************************************
3) Modificare la funzione dell'esercizio 1 (get_valore_doppio) 
	aggiungendo la gestione dell'inizio e fine in una tabella di LOG
	
	TESTARE L'esecuzione e la corretta scrittura del LOG
***************************************************************************
***************************************************************************
*/

------------------------------------------------------------------------------------------
--creo la tabella di log che utilizzerò per registrare le informazioni delle mie procedure
------------------------------------------------------------------------------------------
CREATE TABLE ft_log_monitoraggio (
	id_monitoraggio SERIAL NOT NULL,
	tracciato VARCHAR(255),
	livello VARCHAR(255),
	data_update timestamp DEFAULT now(),
	testo VARCHAR(255),
	CONSTRAINT const_ft_log_monitoraggio_pk PRIMARY KEY (id_monitoraggio)
);


------------------------------------------------------------------------------------------
--creo la procedura che scrive la tabella di log
------------------------------------------------------------------------------------------
CREATE OR REPLACE procedure scrivi_log (p_livello varchar(255), p_tracciato varchar(255), p_testo varchar(1000))
  LANGUAGE plpgsql
AS $$
-- Questa procedura serve per gestire la scrittura nella tabella di log.
declare
begin
	insert into ft_log_monitoraggio (livello, tracciato, testo) values (p_livello, p_tracciato, p_testo);
end;$$

DROP PROCEDURE scrivi_log(p_livello varchar(255), p_tracciato varchar(255), p_testo varchar(1000));

drop function get_valore_doppio(numeric);

drop function get_valore_dimezzato(numeric);


CREATE OR REPLACE FUNCTION public.get_valore_doppio(p_valore numeric)
 RETURNS numeric
 LANGUAGE plpgsql
AS $$
/*
 Questa funzione accetta come parametro in entrata un numero decimale e 
 restituisce il valore raddoppiato.
*/
declare
	valore_doppio numeric;
begin
	--scrivo nella tabella di log che la procedura è iniziata, lasciando un record vuoto per distanziare i log tra di loro.
	call scrivi_log('','get_valore_doppio ',' ');
	call scrivi_log('','get_valore_doppio ','inizio procedura.');
	
	--setto la variabile con il valore raddoppiato
	valore_doppio := p_valore*2;

	--scrivo nella tabella di log che la procedura è terminata
	call scrivi_log('','get_valore_doppio ','fine procedura.');

	--restituisco il risultato
	return valore_doppio;
end; 
$$

select * from scrivi_log;
select get_valore_doppio(a);

/*
***************************************************************************
***************************************************************************
4) Modificare la funzione dell'esercizio 2 (get_valore_dimezzato) 
	aggiungendo la gestione dell'inizio e fine in una tabella di LOG

	TESTARE L'esecuzione e la corretta scrittura del LOG
	TESTARE L'esecuzione passando come parametro il valore: 0
***************************************************************************
***************************************************************************
*/

CREATE OR REPLACE FUNCTION public.get_valore_dimezzato(p_valore numeric)
 RETURNS numeric
 LANGUAGE plpgsql
AS $$
/*
 Questa funzione accetta come parametro in entrata un numero decimale e 
 restituisce il valore dimezzato.
*/
declare
	valore_dimezzato numeric;
begin
	--scrivo nella tabella di log che la procedura è iniziata, lasciando un record vuoto per distanziare i log tra di loro.
	call scrivi_log('','get_valore_dimezzato ',' ');
	call scrivi_log('','get_valore_dimezzato ','inizio procedura.');
		
	--setto la variabile con il valore raddoppiato
	valore_dimezzato := p_valore/2;

	--scrivo nella tabella di log che la procedura è terminata
	call scrivi_log('','get_valore_dimezzato ','fine procedura.');

	--restituisco il risultato
	return valore_dimezzato;
end; 
$$

select get_valore_dimezzato(0);

CREATE OR REPLACE FUNCTION public.divisione(dividendo numeric, divisore numeric)
RETURNS numeric
LANGUAGE plpgsql
AS $$
declare
	quoziente numeric;
begin
	call scrivi_log('','divisione ',' ');
	call scrivi_log('','divisione ','inizio procedura.');
	
	quoziente := dividendo/divisore;	
	call scrivi_log('','divisione ','fine procedura.');
	return quoziente;

	exception 
		when division_by_zero then
			begin 
				call scrivi_log('ERROR', 'divisione', sqlerrm || ' ' || sqlstate);
				return null;
			end;
end; 
$$

select divisione(50, 0);

select * from ft_log_monitoraggio;



/*
***************************************************************************
***************************************************************************
5) Inventare una funzione che abbia una reale utilità all'interno del
	progetto ROI_PROJECT e che gestisca anche il LOG
***************************************************************************
***************************************************************************
*/

-- tentativo 1: inserire id azienda in una funzione che ritorna le informazioni degli investimenti dell'azienda
create or replace function investimento_azienda(aziendaid integer) 
returns table(id_investimento integer, nome varchar, tipo_investimento varchar, budget numeric)
language plpgsql
as $$
begin
    -- Restituisci direttamente i risultati della query
	call scrivi_log('','esecuzione query ',' ');
	call scrivi_log('','esecuzione query ','inizio procedura.');
	
    return QUERY
    select distinct
        inv.id_investimento, inv.nome, inv.tipo_investimento, inv.budget
    from
        ft_investimento as inv
    where 
        inv.id_azienda = aziendaid;

	call scrivi_log('','esecuzione query ','fine procedura.');

	exception 
		when no_data_found then
			begin 
				call scrivi_log('ERROR', 'esecuzione query ', sqlerrm || ' ' || sqlstate);
			end;
end; 
$$;


DROP function investimento_azienda(integer);


select investimento_azienda(10);

select * from ft_log_monitoraggio flm;

CREATE OR REPLACE FUNCTION investimento_azienda(aziendaid integer) 
RETURNS TABLE(id_investimento integer, nome varchar, tipo_investimento varchar, budget numeric)
LANGUAGE plpgsql
AS $$
DECLARE
    row_count integer;
BEGIN
    -- Scrivi log di inizio procedura
    CALL scrivi_log('', 'esecuzione query', ' ');
    CALL scrivi_log('', 'esecuzione query', 'inizio procedura.');
    
    -- Conta il numero di righe che verranno restituite
    SELECT COUNT(*) INTO row_count
    FROM ft_investimento AS inv
    WHERE inv.id_azienda = aziendaid;
    
    -- Se non ci sono righe, registra un log di errore
    IF row_count = 0 THEN
        CALL scrivi_log('ERROR', 'esecuzione query', 'Nessun dato trovato per id_azienda = ' || aziendaid);
    END IF;
    
    -- Restituisci i risultati della query
    RETURN QUERY
    SELECT DISTINCT
        inv.id_investimento, inv.nome, inv.tipo_investimento, inv.budget
    FROM
        ft_investimento AS inv
    WHERE 
        inv.id_azienda = aziendaid;
    
    -- Scrivi log di fine procedura
    CALL scrivi_log('', 'esecuzione query', 'fine procedura.');
    
EXCEPTION 
    WHEN OTHERS THEN
        -- Gestione di eventuali eccezioni
        CALL scrivi_log('ERROR', 'esecuzione query', SQLERRM || ' ' || SQLSTATE);
END; 
$$;

--tentativo 2
