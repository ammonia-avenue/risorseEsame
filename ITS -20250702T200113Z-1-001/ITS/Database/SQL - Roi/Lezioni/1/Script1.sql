create database aaa;
drop database aaa;

create table paziente(
	id integer not null,
	cod_fiscale varchar(16) not null,
	nome varchar(50) not null,
	cognome varchar(50) not null,
	data_nascita date,
	indirizzo text not null,
	cap integer not null,
	constraint cliente_pk primary key(id, cod_fiscale)
	
);

select * from paziente;

drop table paziente;
