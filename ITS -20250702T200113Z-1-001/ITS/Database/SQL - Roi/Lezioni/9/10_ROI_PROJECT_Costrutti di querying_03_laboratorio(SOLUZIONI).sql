/*
 **************************************************************
 **************************************************************
 **                     ROI PROJECT
 **                 COSTRUTTI DI QUERYING
 **                   (laboratorio 03)
 **************************************************************
 **************************************************************
*/

/*
 **************************************************************
 **************************************************************
 **                    REVERSE ENGINEERING
 **************************************************************
 **************************************************************
*/

/*
 --------------------------------------------------------------
 1) Indentare e descivere con i commenti che cosa fa la seguente select:
 -------------------------------------------------------------- 
*/
SELECT 
	az.ragione_sociale as rag_soc 
FROM 
	ft_azienda AS az
;
 
/*
 --------------------------------------------------------------
 2) Indentare e descivere con i commenti che cosa fa la seguente select:
 -------------------------------------------------------------- 
*/
SELECT 
	roi.valore as valore_roi 
FROM 
	ft_roi AS roi 
WHERE 
	(roi.valore between 8 and 10 and roi.descrizione = 'Recensione positiva') 
	or (roi.valore > 10 and roi.descrizione = 'Recensione positiva')
;

/*
 --------------------------------------------------------------
 3) Indentare correttamente la seguente select:
 -------------------------------------------------------------- 
*/
SELECT 
	a.cd_chiave1, 
	a.cd_chiave2, 
	a.cd_chiave3,
	max(a.dt_transit_timestamp) as dt_transit_timestamp
FROM 
	[dbo].[VIEW_DAM_transit_logic] as a 
WHERE
	a.cd_chiave1 = '145' 
	and a.cd_logic_station_code = 'E'
	and a.cd_evento_code = 'T' 
	and a.dt_transit_timestamp > '2023-01-01'
GROUP BY  
	a.cd_chiave1, 
	a.cd_chiave2, 
	a.cd_chiave3
;

/*
 --------------------------------------------------------------
 4) Indentare e descivere con i commenti che cosa fa la seguente select:
 -------------------------------------------------------------- 
*/
SELECT 
	rs1.cd_chiave1, 
	rs1.cd_chiave2, 
	rs1.cd_chiave3, 
	rs1.cd_operation_code, 
	rs1.dt_operation_timestamp, 
	rs1.cd_operation_attempt_code, 
	sum(rs1.conta_nok) as oper_nok, 
	rs1.ds_note_desc, 
	rs1.cd_tool_type_code
from 
	(
	select 
		rs_item.cd_chiave1,
		rs_item.cd_chiave2,
		rs_item.cd_chiave3, 
		rs_item.cd_operation_code,
		rs_item.dt_operation_timestamp,
		rs_item.cd_operation_attempt_code, 
		rs_item.ds_operation_attempt_result_desc,
		case when rs_item.ds_operation_attempt_result_desc in ('OK', 'OK*', 'OK-OPERATOR', 'OKOPERATOR', 'SCL-OK*') 
			then 1 else 0 end as conta_ok,
		case when rs_item.ds_operation_attempt_result_desc in ('NOK', 'NOK-OPERATOR', 'NOKOPERATOR', 'NOK**') 
			then 1 else 0 end as conta_nok,
		rs_SCR.ds_note_desc, 
		rs_SCR.cd_tool_type_code
	from 
		(
		select 
			ite .*,
			vista2.cd_workplace_code
		from 
			dbo.vista1  as ite
		inner join
			dbo.vista2 as ope on
			ite.cd_chiave1 = ope.cd_chiave1
			and ite.cd_chiave2 = ope.cd_chiave2
			and ite.cd_chiave3 = ope.cd_chiave3
			and ite.cd_operation_code = ope.cd_operation_code
			and ite.dt_operation_timestamp = ope.dt_operation_timestamp
		where 
			ite.cd_chiave1 = '145'
		)as rs_item
	inner join  
		(
		select 
			distinct op.cd_operation_code,
			op.cd_workplace_code, op.ds_note_desc,
			op.cd_tool_type_code from vista3 as op
		where 
			op.cd_chiave1 = '145'
			and op.cd_operation_type_code = 'SCR'
		) as rs_SCR on 
			rs_SCR.cd_operation_code = rs_item.cd_operation_code
			and rs_SCR.cd_workplace_code = rs_item.cd_workplace_code
	where 
		rs_item.ds_operation_attempt_result_desc <> ''
	) as rs1 
group by 
	rs1.cd_chiave1, 
	rs1.cd_chiave2,
	rs1.cd_chiave3,
	rs1.cd_operation_code,
	rs1.dt_operation_timestamp,
	rs1.cd_operation_attempt_code,
	rs1.ds_note_desc, 
	rs1.cd_tool_type_code;

/*
 **************************************************************
 **************************************************************
 **                    SELECT ANNIDATE
 **************************************************************
 **************************************************************
*/

/*
 --------------------------------------------------------------
 6) Visualizzare tutti i dettagli del cliente più giovane 
(usando la SELECT annidata nel costrutto di WHERE)
 -------------------------------------------------------------- 
*/
select 
	cl.*
from
	public.ft_cliente as cl
where 
	cl.data_nascita = 
		/*prendo la data_nascita del cliente più giovane*/
		(
		select
			max(cl2.data_nascita) as max_data_nascita
		from 
			public.ft_cliente as cl2
		)
;

/*
 --------------------------------------------------------------
 7) Visualizzare tutti i dettagli del cliente più giovane 
 (usando la SELECT annidata in JOIN nel costrutto di FROM)
 -------------------------------------------------------------- 
*/
select 
	cl.*
from
	public.ft_cliente as cl
inner join
	/*prendo la data_nascita del cliente più giovane*/
	(
	select
		max(cl2.data_nascita) as max_data_nascita
	from 
		public.ft_cliente as cl2
	) as rs1 on
		cl.data_nascita =rs1.max_data_nascita
;

/*
 --------------------------------------------------------------
 8) Visualizzare i dettagli dell'investimento con il BUDGET minore
 (usando la SELECT annidata nel costrutto di WHERE)
 la SELECT annidata nel costrutto di WHERE)
 -------------------------------------------------------------- 
*/
select 
	inv.*
from
	public.ft_investimento as inv
where 
	inv.budget =
		/*prendo il budget minimo assoluto*/
		(
		select
			min(inv2.budget) as min_budget
		from 
				public.ft_investimento as inv2
		)
;

/*
 --------------------------------------------------------------
 9) Visualizzare i dettagli dell'investimento con il BUDGET minore
(usando la SELECT annidata in JOIN nel costrutto di FROM)
 -------------------------------------------------------------- 
*/
select 
	inv.*
from
	public.ft_investimento as inv
inner join
	/*prendo il budget minimo assoluto*/
	(
	select
		min(inv2.budget) as min_budget
	from 
			public.ft_investimento as inv2
	) as rs1 on
		inv.budget = rs1.min_budget
;

/*
 --------------------------------------------------------------
 10) Visualizzare il nome di "tutte" le Aziende, la quantità di investimenti fatti e la quantità di prodotti
 (usando le 2 SELECT annidate in JOIN nel costrutto di FROM)
 -------------------------------------------------------------- 
*/
select
	az.ragione_sociale,
	/*ricodifico con 0 per le aziende che non trovano investimenti*/
	case 
		when rs1.qta_investimenti is null
			then 0
		else
			rs1.qta_investimenti
	end as qta_investimenti,
	/*ricodifico con 0 per le aziende che non trovano prodotti*/
	case 
		when rs2.qta_prodotti is null
			then 0
		else
			rs2.qta_prodotti
	end as qta_prodotti
from 
	public.ft_azienda as az
/*metto in JOIN le aziende con le quantità investimenti*/
left join
	/*RS1 prende le quantità di investimenti raggruppate per azienda*/
	(
	select
		inv.id_azienda,
		count(*) as qta_investimenti
	from 
		public.ft_investimento as inv
	group by 
		inv.id_azienda
	) as rs1 on
		az.id_azienda =rs1.id_azienda
/*metto in JOIN le aziende con le quantità di prodotti*/
left join
	/*RS2 prende le quantità di prodotti raggruppati per azienda*/
	(
	select
		pr.id_azienda,
		count(*) as qta_prodotti
	from 
		public.ft_prodotto as pr
	group by 
		pr.id_azienda 
	) as rs2 on
		az.id_azienda =rs2.id_azienda
;

/*
 --------------------------------------------------------------
 11) Visualizzare nome e cognome di "tutti" i clienti, la quantità di transazioni effettuate, la quantità di feedback effettuati
(usando le 2 SELECT annidate in JOIN nel costrutto di FROM)
 -------------------------------------------------------------- 
*/
select
	cli.nome,
	cli.cognome,
	/*ricodifico con 0 per i clienti che non hanno fatto transazioni*/
	case 
		when rs1.qta_transazioni is null
			then 0
		else
			rs1.qta_transazioni
	end as qta_transazioni,
	/*ricodifico con 0 per i clienti che non hanno scritto feedback*/
	case 
		when re2.qta_feedback is null
			then 0
		else
			re2.qta_feedback
	end as qta_feedback
from 
	public.ft_cliente as cli
/*metto in JOIN i clienti con le transazioni*/
left join
	/*RS1 prende le quantità di transazioni raggruppate per cliente*/
	(
	select
		tra.id_cliente,
		count(*) as qta_transazioni
	from 
		public.ft_transazione as tra
	group by 
		tra.id_cliente
	) as rs1 on
		cli.id_cliente =rs1.id_cliente
/*metto in JOIN i clienti con le recensioni*/		
left join
	/*RS2 prende le quantità di recensioni raggruppate per cliente*/
	(
	select
		re.id_cliente,
		count(*) as qta_feedback
	from 
		public.ft_recensione as re
	group by 
		re.id_cliente 
	) as re2 on
		cli.id_cliente =re2.id_cliente
;

/*
 --------------------------------------------------------------
 12)  Visualizzare il nome di "tutti" i prodotti, il numero di feedback ricevuti ed il numero di transazioni in cui sono presenti.
 -------------------------------------------------------------- 
*/
select
	pro.nome,
	/*ricodifico con 0 per i prodotti che non hanno ricevuto recensioni*/	
	case 
		when rs1.qta_feedback is null
			then 0
		else
			rs1.qta_feedback
	end as qta_feedback,
	/*ricodifico con 0 per i prodotti che non sono presenti in nessuna transazione*/	
	case 
		when tra2.qta_transazioni is null
			then 0
		else
			tra2.qta_transazioni
	end as qta_transazioni
from 
	public.ft_prodotto as pro
/*metto in JOIN i prodotti con le recensioni*/	
left join
	/*RS1 prende le quantità di recensioni raggruppate per prodotto recensito*/
	(
	select
		re.id_prodotto,
		count(*) as qta_feedback
	from 
		public.ft_recensione as re
	group by 
		re.id_prodotto 
	) as rs1 on
		pro.id_prodotto =rs1.id_prodotto
/*metto in JOIN i prodotti con le transazioni in cui sono presenti*/		
left join
	/*RS2 prende le quantità di transazioni raggruppate per prodotto*/
	(
	select
		tra.id_prodotto,
		count(*) as qta_transazioni
	from 
		public.ft_transazione as tra
	group by 
		tra.id_prodotto
	) as tra2 on
		pro.id_prodotto =tra2.id_prodotto;
	
/*
 --------------------------------------------------------------
 13) Visualizzare i dettagli dei clienti che hanno acquistato tutti i prodotti disponibili
 (usando la SELECT annidata nel costrutto di HAVING)
 -------------------------------------------------------------- 
*/
select 
	cli.*
from 
	public.ft_cliente as cli
inner join
	/*prendo in numero di investimenti raggruppato per aziende e */
	(
	select
		rs1.id_cliente,
		count(*) as qta
	from
		/*RS1 contiene la lista raggruppata di clienti e prodotti*/
		(
		select 
			tra.id_cliente,
			tra.id_prodotto
		from
			public.ft_transazione as tra
		group by 
			tra.id_cliente,
			tra.id_prodotto
		) as rs1
	group by 
		rs1.id_cliente
	having 
		/*prendo solo i clienti che hanno il numero di prodotti uguale al totale dei prodotti*/
		count(*) =
			/*conta quanti sono i prodotti*/
			(
			select 
				count(*) as qta_prodotti
			from
				public.ft_prodotto as pr
			)
	) as rs2 on
		cli.id_cliente = rs2.id_cliente
;	

/*
 --------------------------------------------------------------
 14) Visualizzare i dettagli dei clienti che hanno acquistato tutti i prodotti disponibili
(usando la SELECT annidata in JOIN nel costrutto di FROM)
 -------------------------------------------------------------- 
*/
select 
	cli.*
from 
	public.ft_cliente as cli
inner join
	/*RS2 prende da RS1 il cliente e la quantità di prodotti acquistati, raggruppato per cliente*/
	(
	select
		rs1.id_cliente,
		count(*) as qta
	from
		/*RS1 contiene la lista delle transazioni raggruppata per clienti e prodotti*/
		(
		select 
			tra.id_cliente,
			tra.id_prodotto
		from
			public.ft_transazione as tra
		group by 
			tra.id_cliente,
			tra.id_prodotto
		) as rs1
	group by 
		rs1.id_cliente
	) as rs2 on
		cli.id_cliente = rs2.id_cliente
/*prendo solo i record di RS2 che hanno la stessa quantità di RS3*/		
inner join 
	/*RS3 contiene la quantità totale dei prodotti*/
	(
	select 
		count(*) as qta
	from
		public.ft_prodotto as pr
	) as rs3 on
		rs2.qta = rs3.qta
;