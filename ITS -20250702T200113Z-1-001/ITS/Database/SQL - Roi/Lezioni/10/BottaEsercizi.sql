--------------------------------
--UNION
--------------------------------
/*
1) Creare una query di monitoraggio che legga i dati da tutte le tabelle del DATABASE e mostri per ogni record:
      nome della tabella
      numero totale record
*/
select 	
	'ft_cliente' as table_name,
	count(*) as tot_record
from
	ft_cliente 
union
select 	
	'ft_azienda' as table_name,
	count(*) as tot_record
from
	ft_azienda 
union
select 	
	'ft_investimento' as table_name,
	count(*) as tot_record
from
	ft_investimento 
union
select 	
	'ft_recensione' as table_name,
	count(*) as tot_record
from
	ft_recensione 
union
select 	
	'ft_roi' as table_name,
	count(*) as tot_record
from
	ft_roi ;



/*
2) Creare 2 tabelle a propria scelta che contemplino anche la presenza di una colonna chiamata "dt_update" 
   che si valorizza automaticamente con la data al momento dell'inserimento del record.

   Inserire almeno 5 record per ogni tabella

   Creare una query di monitoraggio che mostri in una unica proiezione:
      nome della tabella
      record più recente inserito
*/
create table tb_one(
	id serial,
	info varchar(45),
	dt_update timestamp default current_timestamp,
	constraint id_pk_one primary key (id),
	constraint uni_one unique (info)
);
create table tb_two(
	id serial,
	info varchar(45),
	dt_update timestamp default current_timestamp,
	constraint id_pk_two primary key (id),
	constraint uni_two unique (info)
);

insert into tb_one (info)
values 
	('info 1'),
	('info 2'),
	('info 3'),
	('info 4'),
	('info 5');
insert into tb_two (info)
values 
	('info 6'),
	('info 7'),
	('info 8'),
	('info 9'),
	('info 10');

select 	
	'tb_one' as table_name,
	min(o.dt_update) as dt_update
from
	tb_one as o
union
select 	
	'tb_two' as table_name,
	min(t.dt_update) as dt_update
from
	tb_two as t;



--------------------------------
--UNION ALL
--------------------------------

/*
3) Creare una query di monitoraggio che legga i dati da tutte le tabelle del DATABASE e mostri per ogni record:
      numero_record_tabella
   ordinati in modo discendente, mantenendo anche eventuali record duplicati
*/
select 	
	'ft_cliente' as table_name,
	count(*) as numero_record_tabella
from
	ft_cliente 
union all
select 	
	'ft_azienda' as table_name,
	count(*) as numero_record_tabella
from
	ft_azienda 
union all
select 	
	'ft_investimento' as table_name,
	count(*) as numero_record_tabella
from
	ft_investimento 
union all
select 	
	'ft_recensione' as table_name,
	count(*) as numero_record_tabella
from
	ft_recensione 
union all
select 	
	'ft_roi' as table_name,
	count(*) as numero_record_tabella
from
	ft_roi 
order by numero_record_tabella desc;



/*
4) Ipotizza di avere due tabelle che registrano le vendite di due diversi anni. Devi combinare tutte le vendite in una singola lista includendo i duplicati.

   Tabelle:
      vendite_2022: (id_vendita, prodotto, quantità, data)
      vendite_2023: (id_vendita, prodotto, quantità, data)

   Obiettivo:
   Crea una query che combini tutte le vendite di entrambe le tabelle, includendo i duplicati.
*/

create table vendite_2022(
	id_vendita serial,
	prodotto varchar(50),
	qta decimal(7,2),
	dt_update timestamp default current_timestamp,
	constraint id_22_pk primary key(id_vendita),
	constraint un_prd_22 unique(prodotto)
);

create table vendite_2023(
	id_vendita serial,
	prodotto varchar(50),
	qta decimal(7,2),
	dt_update timestamp default current_timestamp,
	constraint id_23_pk primary key(id_vendita),
	constraint un_prd_23 unique(prodotto)
);

insert into
	vendite_2022 (prodotto, qta, dt_update) 
values
	('Prodotto A', 10.00, '2022-01-10 10:30:00'),
	('Prodotto B', 15.50, '2022-02-15 11:00:00'),
	('Prodotto C', 20.75, '2022-03-20 12:45:00'),
	('Prodotto D', 8.25, '2022-04-25 14:15:00'),
	('Prodotto E', 5.50, '2022-05-30 09:30:00');

insert into
	vendite_2023 (prodotto, qta, dt_update) 
values
	('Prodotto F', 12.00, '2023-01-12 10:30:00'),
	('Prodotto G', 18.50, '2023-02-18 11:00:00'),
	('Prodotto H', 25.75, '2023-03-22 12:45:00'),
	('Prodotto I', 9.25, '2023-04-28 14:15:00'),
	('Prodotto J', 6.50, '2023-05-31 09:30:00');

select 	
	'vendite_2022' as table_name,
	v22.prodotto as nome_prodotto,
	v22.dt_update as dt_update
from
	vendite_2022 as v22
union all
select 	
	'vendite_2023' as table_name,
	v23.prodotto as nome_prodotto,
	v23.dt_update as dt_update
from
	vendite_2023 as v23;



/*
5) Ipotizza di avere due tabelle di dipendenti per due diverse sedi aziendali. Devi combinare le liste dei dipendenti in un'unica lista completa.

   Tabelle:
      dipendenti_sede_a: (id_dipendente, nome, cognome, ruolo)
      dipendenti_sede_b: (id_dipendente, nome, cognome, ruolo)

   Obiettivo:
   Crea una query che elenchi tutti i dipendenti di entrambe le sedi, includendo i duplicati.
*/

create table dipendenti_sede_a(
	id_dipendente serial,
	nome varchar(50),
	cognome varchar(50),
	ruolo varchar(100),
	constraint dip_a_pl primary key(id_dipendente));
create table dipendenti_sede_b(
	id_dipendente serial,
	nome varchar(50),
	cognome varchar(50),
	ruolo varchar(100),
	constraint dip_b_pl primary key(id_dipendente));

insert into 
	dipendenti_sede_a (nome, cognome, ruolo) 
values
	('Marco', 'Rossi', 'Amministratore'),
	('Sara', 'Mancini', 'Responsabile IT'),
	('Luca', 'Bianchi', 'Responsabile IT'),
	('Giulia', 'Verdi', 'Contabile'),
	('Francesca', 'Neri', 'HR Manager'),
	('Davide', 'Russo', 'HR Manager'),
	('Andrea', 'Gialli', 'Marketing Manager');
insert into 
	dipendenti_sede_b (nome, cognome, ruolo) 
values
	('Paolo', 'Esposito', 'Amministratore'),
	('Sara', 'Mancini', 'Responsabile IT'),
	('Elena', 'Ferri', 'Contabile'),
	('Davide', 'Russo', 'HR Manager'),
	('Laura', 'Marini', 'Marketing Manager'),
	('Francesca', 'Neri', 'HR Manager');

select 	
	'dipendenti_sede_a' as table_name,
	da.nome as nome_dipendente,
	da.cognome as cognome_dipendente,
	da.ruolo as ruolo_dipendente
from
	dipendenti_sede_a as da
union all
select 	
	'dipendenti_sede_b' as table_name,
	db.nome as nome_dipendente,
	db.cognome as cognome_dipendente,
	db.ruolo as ruolo_dipendente
from
	dipendenti_sede_a as db;	
	
