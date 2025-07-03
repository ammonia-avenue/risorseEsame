------------------------------------------------------------

-------------------ESERCIZI SQL-----------------------------

------------------(DISPENSE ROI)----------------------------

------------------------------------------------------------

-- considerazioni: durante lo sviluppo delle richieste fornite, sono stati utilizzati 
-- metodi per la proiezione degi attributi: selezionati singolarmente oppure attraverso il carattere "*"
-- utilizzo di alias: tramite "as" è stato possibile rinominare tabelle e colonne per migliorare la ricerca e visualizzazione delle richieste 

-------------

--SELECT FROM

-------------

--1) visualizzare tutti i dettagli dei prodotti
select 
	id_prodotto,
	nome,
	descrizione, 
	prezzo, 
	id_azienda,
	id_categoria,
	valutazione_media,
	tipologia,
	dt_update 
from 
	ft_prodotto; 


--2) visualizzare tutti i dettagli dei clienti 
select 
	*
from 
	ft_cliente;


--3) visualizzare tutti i dettagli degli investimenti
select
	*
from 
	ft_investimento;


-------------

--WHERE------

-------------



--4) visualizzare tutti i dati dei clienti nati dopo il 01-01-1989
select 
	*
from 
	ft_cliente
where 
	data_nascita > '01-01-1989';


--5) visualizzare nome, cognome e indirizzo dei clienti nati dopo il 01-01-1989
select 
	nome,
	cognome,
	indirizzo
from 
	ft_cliente
where 
	data_nascita > '01-01-1989';


--6) visualizzare i dettagli delle aziende appartenenti al settore 'Banca'
select 
	*
from 
	ft_azienda
where 
	settore = 'Banca';


--------------

--ALIAS-------

--------------

--7) visualizzare ragione sociale e descrizione delle aziende con l'anno fondate dal 1 Gennaio 2000 in poi, rinominando tramite ALIAS:

--   ragione_sociale -> rag_soc

--   descrizione -> desc

select 
	ragione_sociale as rag_soc,
	descrizione as desc
from
	ft_azienda
where 
	anno_fondazione > 2000;



--8) visualizzare il nome e il budget degli investimenti che hanno come tipo_investimento "Titoli azionari" 

--   e che hanno un budget compreso tra 5000 e 9000, ordinati per budget (descescente)

select 
	nome,
	budget
from 
	ft_investimento
where 
	tipo_investimento = 'Titoli azionari'
	and budget < 9000
	and budget > 5000
order by 
	budget desc;


--9)  visualizzare nome e cognome dei clienti usando l'alias <cli> per la tabella e gli alias <name> e <surname> per le colonne

------------------------------------------------------------

-- DA QUI IN AVANTI UTILIZZARE SEMPRE GLI ALIAS PER LE TABELLE

------------------------------------------------------------

select 
	cli.nome as name,
	cli.cognome as surname
from
	ft_cliente as cli;
	

---------------

--ORDER BY-----

---------------

--10) visualizzare la descrizione ed il prezzo dei prodotti che hanno una valutazione media superiore a 4.5

--   ed un prezzo maggiore di 100, ordinandoli per prezzo (crescente)

select 
	prdt.descrizione as description,
	prdt.prezzo as price
from
	ft_prodotto as prdt
where 
	prdt.valutazione_media > 4.5
	and prdt.prezzo > 100
order by 
	prdt.prezzo asc;
	


--11) visualizzare i dettagli dei clienti, ordinandoli per cognome acendente

select 
	*
from 
	ft_cliente as cli
order by 
	cli.cognome asc;



--12) visualizzare voto e testo delle recensioni che hanno voto superiore a 3, ordinandoli per voto discendente
select 
	rcn.voto as rate,
	rcn.testo as expectation
from 
	ft_recensione as rcn
where 
	rcn.voto > 3
order by 
	rcn.voto desc;

