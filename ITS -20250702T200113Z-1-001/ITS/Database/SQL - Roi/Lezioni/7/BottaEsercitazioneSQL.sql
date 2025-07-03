-------------------------------------------------------------
--CREAZIONE DELLE TABELLE RICHIESTE

create table studente(
	matricola serial,
	nome varchar(50),
	cognome varchar(50),
	data_nascita date,
	punteggio_ammissione decimal(4, 2),
	
	constraint matricola_pk primary key(matricola)
);

create table materia(
	codice serial,
	descrizione varchar(100),
	monte_ore decimal(10, 2),
	
	constraint codice_pk primary key(codice)
);

create table esame(
	codice integer,
	matricola integer,
	data_esame date,
	voto decimal(4, 2),
	
	constraint esame_pk primary key (codice, matricola, data_esame),
	constraint fk_codice_materia foreign key(codice)
		references materia(codice) on delete cascade,
	constraint fk_matricola_studente foreign key(matricola)
		references studente(matricola) on delete cascade
);

-------------------------------------------------------------
--INSERIMENTO DATI RICHIESTI

insert into studente(nome, cognome, data_nascita, punteggio_ammissione)
values
	('Mario', 'Rossi', '2000-01-01', 24),
	('Luigi', 'Verdi', '2003-05-26', 27),
	('Paola', 'Bianchi', '2002-10-15', 22),
	('Daniela', 'Miglio', '2001-09-11', 17),
	('Ciro', 'Esposito', '2000-12-12', 10);

insert into materia(descrizione, monte_ore)
values
	('Fondamenti di Basi di Dati SQL', 90),
	('Fondamenti di Programmazione Java', 100),
	('Fondamenti di Programmazione HTML/CSS/JS', 60),
	('Fondamenti di Basi di Dati NoSQL', 80),
	('Fondamenti di Programmazione Python', 75);

insert into esame(data_esame, codice, matricola, voto)
values
	('2024-02-07', 3, 1, 20),
	('2024-07-02', 5, 2, 18),
	('2024-10-15', 4, 2, 27),
	('2024-09-06', 2, 3, 30),
	('2024-11-01', 2, 3, 22);

-------------------------------------------------------------

--REALIZZAZIONE DELLE QUERY RICHIESTE

-- 1)
select
	s.nome, 
	s.cognome, 
	s.punteggio_ammissione
from 
	studente as s
where 
	s.punteggio_ammissione > 18
order by 
	s.punteggio_ammissione desc;
	
-- 2)
select 
    s.nome as nome_studente, 
    s.cognome as cognome_studente, 
    e.codice as codice_materia, 
    e.voto as voto_materia, 
    e.data_esame 
from 
    studente as s
join 
    esame as e
on 
    s.matricola = e.matricola;
   
-- 3)
select 	
	e.codice as codice_materia,
	count(*) as esami_dati,
	max(voto) as voto_piu_alto,
	min(voto) as voto_piu_basso,
	avg(voto) as media_voto
from 
	esame as e
group by
    e.codice
having
    count(*) > 1;

-- 4)
select 
    m.descrizione 
from 
    materia as m
join 
    esame as e
on 
    m.codice = e.codice
where 
	e.codice is null;

	