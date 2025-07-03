create table esami (
	id int not null auto_increment,
    studente_id int not null,
    corso_id int not null,
    voto int not null,
    data_esame date,
    primary key (id)
);

drop table esami;

describe corsi;
desc esami;
desc studenti;

show create table corsi;

truncate table corsi;

select * from corsi;

alter table corsi add prof varchar(50);

insert into corsi (nome, prof, ore) values 
			('programmazione java', 'mauro', 100),
            ('fondamenti basi di dati', 'mauro', 100),
            ('inglese', 'elisabetta', 100),
			('fondamenti di programmazione', 'valentino', 100);

truncate corsi;

select nome from its_2024.studenti order by nome;
select nome from its_2024.studenti order by cognome;
select nome, cognome from its_2024.studenti order by cognome;
select cognome, nome from its_2024.studenti order by cognome;

select cognome, nome from its_2024.studenti where id =1;

select * from corsi where id =1;

select * from esami;

select studenti.cognome, corsi.nome, esami.data_esame, esami.voto 
	from esami, studenti, corsi 
	where studenti.id=esami.studente_id 
	and corsi.id=esami.corso_id;
    
select * from  studenti;
select * from  corsi;

