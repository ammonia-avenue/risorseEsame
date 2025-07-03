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

create or replace function get_valore_doppio(valore decimal(5, 2))returns decimal(5, 2)
language plpgsql
as $$
declare  	
begin
	return valore * 2;
end; $$

select 
	get_valore_doppio(10.5);
-------------------------------------------------------
 --alternativa
/*
create or replace function get_valore_doppio(valore decimal(5, 2))returns decimal(5, 2)
language plpgsql
as $$
declare 
	valore_raddoppiato decimal(5, 2); 	
begin
	valore_raddoppiato = valore * 2;
	return valore_raddoppiato;
		
end; $$

select 
	get_valore_doppio(10.5);
*/
-------------------------------------------------------


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

create or replace function get_valore_dimezzato(valore decimal(5, 2)) returns decimal(5, 2)
language plpgsql
as $$ 
declare 
begin
	return valore / 2;
end; $$

select 	
	get_valore_dimezzato(8.2);
	


/*
*********************************************************************************
*********************************************************************************
*********************************************************************************
*********************************************************************************
*********************************************************************************
*/

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

create table log(
	id_sequenza serial not null,
	tracciato varchar(1000) not null,
	livello varchar(500) not null,
	data_update timestamp default current timestamp,
	testo varchar(2500) not null,
	
	constraint id_sequenza_pk primary key (id_sequenza)
);


create or replace procedure scrivi_log(new_tracciato varchar(1000), new_livello varchar(500), new_testo varchar(2500) default'')
language plpgsql
as $procedure$
begin 
	insert into log(tracciato, livello, testo) values (new_tracciato, new_livello, new_testo);
end; $procedure$

create or replace function get_valore_doppio(valore decimal(5, 2))returns decimal(5, 2)
language plpgsql
as $$
declare  	
	valore_doppio numeric;
begin
	call scrivi_log('tracciato1', 'START', 'calcolo moltiplicazione per 2');
	valore_doppio = valore * 2;
	call scrivi_log('tracciato1', 'END', 'calcolo moltiplicazione per 2');
	return valore_doppio ;
end; $$

select 
	get_valore_doppio(10.5);

select * from log;

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

create or replace function get_valore_dimezzato(valore decimal(5, 2)) returns decimal(5, 2)
language plpgsql
as $$ 
declare 
	valore_dimezzato numeric;
begin
	call scrivi_log('tracciato2', 'START', 'calcolo divisione per 2');
	valore_dimezzato = valore / 2;
	call scrivi_log('tracciato2', 'END', 'calcolo divisione per 2');
	return valore_dimezzato ;
end; $$

select 	
	get_valore_dimezzato(8.2);


/*
***************************************************************************
***************************************************************************
5) Inventare una funzione che abbia una reale utilità all'interno del
	progetto ROI_PROJECT e che gestisca anche il LOG
***************************************************************************
***************************************************************************
*/







