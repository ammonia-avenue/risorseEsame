/**
 * Verifica intermedia 
 * Data: 2024-07-02
 * Autore: Botta Davide
 */
 
---------------------------------------------------------------------------------------------------------------------
-- CREAZIONE DELLE TABELLE
/**
 * La seguente tabella creerà l'entità cliente composta da 
 * 	un identidicativo univoco, l'attributo codice, impostato 
 * 	come un numero incrementante per ogni cliente che verrà inserito,
 * 	il nome e cognome del cliente,
 * 	e il rating_bancario come numero intero.
 */
create table cliente(
	codice serial,
	nome varchar(50),
	cognome varchar(50),
	rating_bancario integer,
	constraint codice_cliente_pk primary key(codice)
);

/**
 * La seguente tabella creerà l'entità prodotto composta da 
 * 	un identidicativo univoco, l'attributo codice, impostato 
 * 	come un numero incrementante per ogni cliente che verrà inserito
 * 	la descrizione del prodotto  
 */
create table prodotto(
	codice serial,
	descrizione varchar(100),
	constraint codice_prodotto_pk primary key(codice)
);

/**
 * La seguente tabella creerà l'entità transazione composta da 
 * 	gli identificativi delle tabelle cliente e prodotto impostate come valori interi e a seguire come chiavi esterne  
 * 	(simulando un cliente che effettua la transazione di un prodotto),
 * 	la data della transazione,
 * 	l'importo della transazione da inserire.
 */
create table transazione(
	codice_prodotto integer,
	codice_cliente integer,
	data_transazione date,
	importo decimal(10, 2),
	constraint transazione_pk  primary key(data_transazione, codice_prodotto, codice_cliente),
	constraint fk_codice_prodotto foreign key(codice_prodotto)
		references prodotto(codice) on delete cascade,
	constraint fk_codice_cliente foreign key(codice_cliente)
		references cliente(codice) on delete cascade
	
);

---------------------------------------------------------------------------------------------------------------------
-- INSERIMENTO DATI NELLE TABELLE			
/**
 * A seguire troverà dei dati che sono stati inseriti nelle tabelle create precedentemente.
 * Sono state caricate 5 istanze per ogni tabella, specificando gli attributi delle entità
 * e a seguire i valori.
 */

insert into cliente(nome, cognome, rating_bancario)
values 
	('Mario', 'Rossi', 24),
	('Luigi', 'Verdi', 60),
	('Paola', 'Bianchi', 57),
	('Daniela', 'Miglio', 75),
	('Ciro', 'Esposito', 35);

insert into prodotto(descrizione)
values 
	('Conto Corrente Standard'),
	('Conto Risparmio Plus'),
	('Carta di Credito Gold'),
	('Prestito Personale'),
	('Mutuo Casa');

insert into transazione(codice_cliente, codice_prodotto, data_transazione, importo)
values 
	(1, 1, '2024-07-02', 5000),
	(3, 2, '2023-06-03', 3000),
	(3, 5, '2023-06-04', 15000),
	(2, 4, '2020-05-03', 8000),
	(2, 4, '2021-04-03', 500);

---------------------------------------------------------------------------------------------------------------------
-- ELABORAZIONE DELLE QUERY
-- 1)
/**
 * Con questa query si selezionano tutte le informazioni dei clienti
 * che abbiano un rating bancario superiore a 50.
 * 
 * Inoltre la visualizzazione è stata ordinata per rating_bancario in modo discendente.
 */
select 
	*
from 
	cliente as c
where 
	c.rating_bancario > 50
order by 
	c.rating_bancario desc;
	
    
-- 2)
/**
 * il seguente codice permette di proietta il nome, cognome, il codice del prodotto,
 * l'importo e la data della transazione eseguite dal cliente.
 * 
 * attraverso l'utilizzo delle left join è possibile visualizzare elementi di più tabelle differenti
 * utilizzando le chiavi esterne (nel nostro caso, caricate nella tabella transazione).
 */
select 
	c.nome as nome_cliente,
	c.cognome as cognome_cliente,
	t.codice_prodotto,
	t.importo,
	t.data_transazione
from
	transazione as t
left join
	cliente as c
on
	c.codice = t.codice_cliente
left join 
	prodotto as p
on 
	p.codice = t.codice_prodotto;
	
    
-- 3)
/**
 * Con questa query si andranno a visualizzare il codice del prodotto, 
 * la quantità delle transazioni, l'importo più alto e la somma totale 
 * degli importi presenti nella tabella transazioni, il tutto raggruppato per
 * il codice prodotto.
 * 
 * Inoltre con la imposizione del having è stato possibile filtrare
 * la visualizzazione, con condizione che la media dell'importo fosse 
 * superiore all'importo medio di tutte le transazioni.
 * Per elaborare questa azione, è stata utilizzata una subquery che visualizzasse la
 * media dell'importo di tutte le transazioni.
 */
select 
	t.codice_prodotto,
	count(*) as quantita_transazioni,
	max(t.importo) as importo_piu_alto,
	sum(t.importo) as somma_totale_importi,
	avg(t.importo) as media_importi
from 
	transazione as t
group by
	t.codice_prodotto
having 
	avg(t.importo) > (
		select 
			avg(importo) 
		from 
			transazione
	);


-- 4)
/**
 * Quest'ultima query caricherà a video la descrizione dei prodotti con i quali
 * non hanno eseguito alcuna transazione.
 * Per permettere ciò bisognava fare uso della left join sulla tabella transazione per verificare quali prodotti
 * non avessero eseguito transazioni.
 */
select
    p.descrizione
from
    prodotto p
left join
    transazione t 
on 
	p.codice = t.codice_prodotto
where
    t.codice_prodotto is null;


