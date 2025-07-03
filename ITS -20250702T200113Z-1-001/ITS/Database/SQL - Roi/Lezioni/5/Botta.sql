--------------------------------------------
--------------------------------------------
/*

Visualizza tutti i dettagli della tabella ft_prodotto:

*/
--------------------------------------------
--------------------------------------------

-- dove il prezzo è compreso tra 250 e 5000
select 
	*
from 
	ft_prodotto as pd
where
	pd.prezzo between 250 and 5000;


-- dove il prezzo è uguale a 250 e l id_azienda è uguale a 3
select 
	*
from 
	ft_prodotto as pd
where
	pd.prezzo = 250 and id_azienda = 3;


-- dove il prezzo è uguale a 5000 oppure il prezzo è uguale a 0
select 
	*
from 
	ft_prodotto as pd
where
	pd.prezzo = 5000 or prezzo = 0;


-- dove il prezzo fa parte di questa lista di valori ('0,250,10000')
select 
	*
from 
	ft_prodotto as pd
where
	pd.prezzo in(0,250,10000);


-- dove la descrizione contiene la porzione di testo 'to'
select 
	*
from 
	ft_prodotto as pd
where
	pd.descrizione like '%to%';


-- dove la tipologia è nulla
select 
	*
from 
	ft_prodotto as pd
where
	pd.tipologia is null; 


-- dove la descrizione non è 'Conto corrente'
select 
	*
from 
	ft_prodotto as pd
where
	not pd.descrizione = 'Conto Corrente';







--------------------------------------------
--------------------------------------------
/*

Mostra della tabella ft_prodotto, per ogni tipologia:

*/
--------------------------------------------
--------------------------------------------

-- Il prezzo massimo
select 
	max(prezzo) as prezzo_max
from
	ft_prodotto;

-- il prezzo minimo
select 
	min(prezzo) as prezzo_min
from
	ft_prodotto;

-- il prezzo medio
select 
	avg(prezzo) as prezzo_medio
from
	ft_prodotto;

-- la quantità di prodotti
select 
	count(id_prodotto) as somma_prodotti
from
	ft_prodotto;

-- il totale dei prezzi
select 
	sum(prezzo) as somma_prezzi_prodotti
from
	ft_prodotto;

-----------------------------------------------------
-------------- PROVE DI RAGGRUPPAMENTO --------------
-----------------------------------------------------

select
	*
from
	ft_prodotto as pd;

select 
	*
from 
	ft_recensione as rcs;

select 
	*
from 
	ft_investimento as inv;



select 
	*
from 
	ft_investimento as inv
where 
	inv.nome = 'Obbligazioni'
group by 
	inv.id_investimento 
having 
	avg(inv.budget) > 2000
order by budget asc;
	


