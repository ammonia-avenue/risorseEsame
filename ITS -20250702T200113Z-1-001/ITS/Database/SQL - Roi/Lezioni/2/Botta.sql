-- Botta Davide Esectizi
-------------------------------------------------------------------
--Esercizio 1: ESEGUIRE QUESTO CODICE PER VERIFICARE DI AVERE I PERMESSI IN LETTURA E SCRITTURA
-------------------------------------------------------------------

CREATE TABLE ft_utente (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    age INTEGER NOT NULL
);
INSERT INTO ft_utente (name, email, age) VALUES ('Mario Rossi', 'mario.rossi@example.com', 35);
INSERT INTO ft_utente (name, email, age) VALUES ('Paolo Bianchi', 'paolo.bianchi@example.com', 28);
INSERT INTO ft_utente (name, email, age) VALUES ('Chiara Neri', 'chiara.neri@example.com', 42);

-------------------------------------------------------------------
--Esercizio 2: CREARE LE SEGUENTI TABELLE:
-------------------------------------------------------------------
1. Tabella "studenti":
Campo "matricola": chiave primaria numerica auto-incrementale
Campo "nome": testuale con lunghezza massima di 50 caratteri
Campo "cognome": testuale con lunghezza massima di 50 caratteri
Campo "data_nascita": data
Campo "email": testuale con lunghezza massima di 100 caratteri

create table studenti (
	matricola serial,
	nome varchar(50),
	cognome varchar(50),
	data_nascita date,
	email varchar(100),		
	constraint matricola_pk primary key(matricola)
);


2. Tabella "prodotti":
Campo "id_prodotto": chiave primaria numerica auto-incrementale
Campo "nome_prodotto": testuale con lunghezza massima di 100 caratteri
Campo "prezzo": numerico con 2 decimali
Campo "quantita": numerico intero

create table prodotti (
	id_prodotto serial,
	nome_prodotto varchar(100),
	prezzo numeric(10, 2),
	quantita integer,
	constraint id_prodotto_pk primary key(id_prodotto)
);



3. Tabella "clienti":
Campo "id_cliente": chiave primaria testuale con lunghezza massima di 10 caratteri
Campo "nome": testuale con lunghezza massima di 50 caratteri
Campo "cognome": testuale con lunghezza massima di 50 caratteri
Campo "indirizzo": testuale con lunghezza massima di 100 caratteri
Campo "citta": testuale con lunghezza massima di 50 caratteri
Campo "stato": testuale con lunghezza massima di 50 caratteri

create table clienti (
	id_cliente varchar(10),
	nome varchar(50),
	cognome varchar(50),
	indirizzo varchar(100),
	citta varchar(50),
	stato varchar(50),
	constraint id_cliente_pk primary key (id_cliente)
);



4. Tabella "libri":
Campo "id_libro": chiave primaria numerica auto-incrementale
Campo "titolo": testuale con lunghezza massima di 100 caratteri
Campo "autore": testuale con lunghezza massima di 50 caratteri
Campo "genere": testuale con lunghezza massima di 50 caratteri
Campo "prezzo": numerico con 2 decimali

create table libri(
	id_libro serial,
	titolo varchar(100),
	autore varchar(50),
	genere varchar(50),
	prezzo decimal(10, 2),
	constraint id_libro_pk primary key(id_libro)
);



5. Tabella "ordini":
Campo "id_ordine": chiave primaria numerica auto-incrementale
Campo "data_ordine": data
Campo "quantita": numerico intero
Campo "prezzo_totale": numerico con 2 decimali
Campo "id_prodotto": chiave esterna alla tabella "prodotti"
Campo "id_cliente": chiave esterna alla tabella "clienti"

create table ordini(
	id_ordine serial,
	data_ordine date,
	quantita integer,
	prezzo_totale decimal(10, 2),
	id_prodotto serial,
	id_cliente varchar(10),
	constraint id_ordine_pk primary key(id_ordine),
	constraint id_prodotto_fk foreign key (id_prodotto) references prodotti(id_prodotto),
	constraint id_cliente_fk foreign key (id_cliente) references clienti(id_cliente)
);


-------------------------------------------------------------------
--Esercizio 3: CREARE LA SEGUENTE ARCHITETTURA DB
-------------------------------------------------------------------
Obiettivo:
Creare un database con tre tabelle relazionate tra loro, contenenti informazioni su una scuola.

Descrizione:
Il database deve contenere le seguenti tabelle:

La tabella "studente" deve contenere le informazioni su ogni studente, 
tra cui il nome, il cognome, la data di nascita e l'anno di iscrizione alla scuola.

La tabella "classe" deve contenere le informazioni su ogni classe, 
tra cui il nome della classe, il livello scolastico e l'anno scolastico.

La tabella "iscrizione" deve contenere le informazioni su quali studenti sono iscritti a quali classi, 
con un riferimento alle tabelle "Studenti" e "Classi" tramite i loro identificatori univoci.

L'esercizio consiste nel creare le tre tabelle e popolarle con alcuni dati di esempio. 
In particolare, devono essere create almeno tre classi e almeno cinque studenti, 
e ogni studente deve essere iscritto a almeno una classe.

Suggerimenti:

Usa il tipo di dato "SERIAL" per generare identificatori univoci per le tabelle "Studente" e "Classe".
Usa il tipo di dato "DATE" per la data di nascita degli studenti e il tipo di dato "INTEGER" per l'anno di iscrizione e il livello scolastico delle classi.
Usa la clausola "REFERENCES" per creare le relazioni tra le tabelle "Iscrizione", "Studente" e "Classe".
Usa la clausola "ON DELETE CASCADE" per assicurarti che le iscrizioni vengano eliminate automaticamente quando uno studente o una classe viene eliminato dal database.

create database scuola;

create table studente(
	matricola serial,
	nome varchar(50),
	cognome varchar(50),
	data_nascita date,
	anno_iscrizione integer,
	constraint id_studente_pk primary key(matricola)
);


create table classe(
	id_classe serial,
	nome varchar(50),
	lvl_scolastico integer,
	anno_scolastico integer,
	constraint id_classe_pk primary key(id_classe),
	constraint nome_unique unique (nome)
);


create table iscrizione(
	id_iscrizione serial,
	id_studente integer,
	id_classe integer,
	constraint id_iscrizione_unique unique (id_iscrizione),
	constraint id_studente_fk foreign key (id_studente) references studente(matricola) on delete cascade,
	constraint id_classe_fk foreign key (id_classe) references classe(id_classe) on delete cascade
);
