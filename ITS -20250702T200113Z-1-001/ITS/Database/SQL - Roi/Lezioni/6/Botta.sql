------------------------------------------------------------
-------------------ESERCIZI SQL-----------------------------
------------------(DISPENSE ROI)----------------------------
---------------------- JOIN --------------------------------


INNER JOIN

1) visualizzare la "ragione_sociale" delle aziende che hanno degli investimenti, con i "nomi" di tutti i propri investimenti

select 
	az.ragione_sociale, 
	inv.nome
from 
	ft_azienda as az
inner join 
	ft_investimento as inv
		on az.id_azienda = inv.id_azienda 
;

2) visualizzare i nomi degli investimenti che hanno dei ROI con i  "nomi" dei propri ROI

select 
	inv.nome,
	roi.descrizione 
from 
	ft_investimento as inv
inner join
	ft_roi as roi
		on inv.id_investimento = roi.id_investimento
;

3) visualizzare la "ragione_sociale" e "settore" delle aziende che hanno dei prodotti, con i "nomi" e "prezzi" dei propri prodotti

select 
	az.ragione_sociale,
	az.settore, 
	prd.nome,
	prd.prezzo 
from 
	ft_azienda as az
inner join
	ft_prodotto as prd	
		on az.id_azienda = prd.id_azienda
; 

4) visualizzare il nome dei prodotti che hanno una categoria ed il nome delle relative categorie di appartenenza

select 
	prd.nome as nome_prodotto, 
	cat.nome as nome_categoria
from 
	ft_prodotto as prd
inner join
	dm_categoria as cat
		on prd.id_categoria = cat.id_categoria
; 


5) visualizzare il nome dei prodotti che hanno delle transazioni e la "data" e "importo" delle relative transazioni

select 
	prd.nome,
	trz.data_transazione,
	trz.importo
from
	ft_prodotto as prd
inner join
	ft_transazione as trz
		on prd.id_prodotto = trz.id_prodotto
; 

LEFT JOIN

6) visualizzare la "ragione_sociale" di tutte le aziende ed i "nomi" degli investimenti laddove presenti.

select 
	az.ragione_sociale,
	inv.nome
from
	ft_azienda as az
left join
	ft_investimento as inv 
		on az.id_azienda = inv.id_azienda
; 


7) visualizzare i nomi di tutti gli investimenti ed i "nomi" dei ROI laddove presenti

select 
	inv.nome,
	roi.descrizione 
from 
	ft_investimento as inv
left join
	ft_roi as roi
		on inv.id_investimento = roi.id_investimento
;

8) visualizzare la "ragione_sociale" e "settore" di tutte le aziende con i "nomi" e "prezzi" dei  prodotti laddove presenti.

select 
	az.ragione_sociale,
	az.settore, 
	prd.nome,
	prd.prezzo 
from 
	ft_azienda as az
left join
	ft_prodotto as prd	
		on az.id_azienda = prd.id_azienda
; 

9) visualizzare il nome di tutti i prodotti ed il nome delle relative categorie se presenti

select 
	prd.nome as nome_prodotto, 
	cat.nome as nome_categoria
from 
	ft_prodotto as prd
left join
	dm_categoria as cat
		on prd.id_categoria = cat.id_categoria
; 

10) visualizzare il nome di tutti i prodotti e la "data" e "importo" delle transazioni laddove presenti

select 
	prd.nome,
	trz.data_transazione,
	trz.importo
from
	ft_prodotto as prd
left join
	ft_transazione as trz
		on prd.id_prodotto = trz.id_prodotto
;

RIGHT JOIN

11) visualizzare i "nomi" degli investimenti  e la "ragione_sociale" delle aziende.
Le aziende ci devono essere tutte, mentre degli investimenti soltanto quelli che hanno una azienda.

12) visualizzare il testo delle recensioni ed i nomi dei clienti che le hanno fatte.
I clienti ci devono essere tutti mentre delle recensioni soltanto quelle che sono state fatte dai clienti.

13) visualizzare il voto delle recensioni ed i nomi dei prodotti.
I prodotti ci devono essere tutti mentre delle recensioni soltanto quelle che sono state fatte su dei prodotti.

14) visualizzare la descrizione dei ROI ed il nome degli investimenti.
Gli investimenti devono esseci tutti mentre dei ROI soltanto quelli che hanno un collegamento con gli investimenti


LEFT JOIN esclusiva

15) visualizzare i dettagli delle aziende che non hanno investimenti.

select 
	*
from 
	ft_azienda as az
left join
	ft_investimento as inv
		on az.id_azienda = inv.id_azienda
where 
	inv.id_azienda is null
;

16) visualizzare i dettagli degli investimenti che non hanno ROI.

select 
	*
from 
	ft_investimento as inv
left join
	ft_roi as roi
		on inv.id_investimento = roi.id_investimento 
where roi.id_investimento is null
;

17) visualizzare i dettagli delle aziende che non hanno prodotti.

18) visualizzare i dettagli dei prodotti che non sono presenti in nessuna transazione.

19) visualizzare i dettagli dei clienti che non hanno effettuato recensioni.


RIGHT JOIN esclusiva

15) visualizzare i dettagli delle aziende che non hanno investimenti, scrivendo prima la tabella degli investimenti.

16) visualizzare i dettagli degli investimenti che non hanno ROI, scrivendo prima la tabella dei ROI.

17) visualizzare i dettagli delle aziende che non hanno prodotti, scrivendo prima la tabella dei prodotti.

18) visualizzare i dettagli dei prodotti che non sono presenti in nessuna transazione, scrivendo prima la tabella delle transazioni.

19) visualizzare i dettagli dei clienti che non hanno effettuato recensioni, scrivendo prima la tabella delle recensioni.


FULL JOIN

20) visualizzare i dettagli di tutte le aziende e tutti gli investimenti.

21) visualizzare i dettagli di tutti gli investimenti e tutti i ROI.

22) visualizzare i dettagli di tuttie le aziende e tutti i prodotti.

23) visualizzare i dettagli di tutti i prodotti e tutte le transazioni.

24) visualizzare i dettagli di tutti i clienti e tutte le recensioni.


FULL JOIN esclusiva

25) visualizzare i dettagli di tutte le aziende che non hanno investimenti e tutti gli investimenti che non hanno aziende.

26) visualizzare i dettagli di tutti gli investimenti che non hanno ROI e tutti i ROI che non hanno investimenti.

27) visualizzare i dettagli di tuttie le aziende che non hanno prodotti e tutti i prodotti che non hanno aziende.

28) visualizzare i dettagli di tutti i prodotti che non hanno transizioni e tutte le transazioni che non hanno prodotti.

29) visualizzare i dettagli di tutti i clienti che non hanno recensioni e tutte le recensioni che non hanno clienti.




---------------------------------------------
---------------------------------------------
----RICHIESTE DEL CLIENTE--------------------
---------------------------------------------
---------------------------------------------

30) Mostrare i ROI che non trovano corrispondenza con nessun investimento

31) Mostrare le aziende che non hanno prodotti

32) Mostrare le Aziende che hanno prodotti che non sono presenti in nessuna transazione.

select 
	az.*,
	prd.*
from
	ft_azienda as az
inner join
	ft_prodotto as prd on
		az.id_azienda = prd.id_azienda 
left join 
	ft_transazione as trz on
		prd.id_prodotto = trz.id_prodotto 
where 
	trz.id_prodotto is null
;

