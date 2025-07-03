-- progetto di Gruppo Bordino Botta Panzica



-- Richieste del cliente

-- descrizione aziende e recapiti (ft_azienda)
select
	 az.ragione_sociale as RagioneSociale,
	 az.settore,
	 az.descrizione,
	 az.sito_web as SitoWeb
from
	ft_azienda as az
order by
	az.ragione_sociale asc;


--  Visualizzazione del nome, descrizione, prezzo e valutazione media 
--  dei prodotti ordinati per prezzo discendente (ft_prodotto)
select 
	prd.nome,
	prd.descrizione,
	prd.prezzo,
	prd.valutazione_media as rating
from 
	ft_prodotto as prd
order by 
	prd.prezzo desc;


--  Visualizzare le recensioni negative,
-- in base al voto inferiore o uguale a 4) (ft_recensione)
select
	rec.voto as rating,	
	rec.testo as commento
from 
	ft_recensione as rec
where 
	rec.voto <= 4
order by
	rec.voto desc;

-- visualizzare nome, cognome e data di nascita dei clienti nati dopo il 01-01-1989
select
	cli.nome,
	cli.cognome,
	cli.data_nascita 
from 
	ft_cliente as cli
where 
	data_nascita >= '1989-01-01';


Stefania Bordino
11:36 (0 minuti fa)
a me

-- Transazioni ordinate per data (ft_transazione)

select 
	t.data_transazione,
	t.id_cliente as cliente,
	t.importo,
	t.metodo_pagamento 
from
	ft_transazione as t
order by 
	t.data_transazione asc;

-- visualizzare nome, tipo di investimento, budget, data di investimento e descrizione
-- dove il budget è superiore a 5000 euro e l'attività sono state effettuate dopo il 01-01-2020
select 
	inv.nome,
	inv.tipo_investimento,
	inv.budget,
	inv.data_investimento,
	inv.descrizione 
from 
	ft_investimento as inv
where 
	budget > 5000 and data_investimento > '01-01-2020';
	

















