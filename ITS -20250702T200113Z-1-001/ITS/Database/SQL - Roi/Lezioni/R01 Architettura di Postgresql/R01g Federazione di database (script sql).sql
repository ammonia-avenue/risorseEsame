CREATE TABLE clienti (
    id INT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    telefono VARCHAR(20) NOT NULL
);

CREATE TABLE ordini (
    id INT PRIMARY KEY,
    data_ordine DATE NOT NULL,
    importo DECIMAL(10,2) NOT NULL,
    cliente_id INT,
    FOREIGN KEY (cliente_id)
        REFERENCES clienti(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 10 inserimenti nella tabella "clienti"
INSERT INTO clienti (id, nome, cognome, email, telefono)
VALUES
(1, 'Mario', 'Rossi', 'mario.rossi@email.com', '+39 333 1234567'),
(2, 'Luigi', 'Verdi', 'luigi.verdi@email.com', '+39 333 2345678'),
(3, 'Giovanni', 'Neri', 'giovanni.neri@email.com', '+39 333 3456789'),
(4, 'Marco', 'Bianchi', 'marco.bianchi@email.com', '+39 333 4567890'),
(5, 'Giuseppe', 'Gialli', 'giuseppe.gialli@email.com', '+39 333 5678901'),
(6, 'Antonio', 'Marroni', 'antonio.marroni@email.com', '+39 333 6789012'),
(7, 'Roberto', 'Blu', 'roberto.blu@email.com', '+39 333 7890123'),
(8, 'Paolo', 'Viola', 'paolo.viola@email.com', '+39 333 8901234'),
(9, 'Riccardo', 'Arancione', 'riccardo.arancione@email.com', '+39 333 9012345'),
(10, 'Fabrizio', 'Fucsia', 'fabrizio.fucsia@email.com', '+39 333 0123456');

-- 10 inserimenti nella tabella "ordini"
INSERT INTO ordini (id, data_ordine, importo, cliente_id)
VALUES
(1, '2022-01-01', 100.00, 1),
(2, '2022-01-02', 200.00, 2),
(3, '2022-01-03', 300.00, 3),
(4, '2022-01-04', 400.00, 4),
(5, '2022-01-05', 500.00, 5),
(6, '2022-01-06', 600.00, 6),
(7, '2022-01-07', 700.00, 7),
(8, '2022-01-08', 800.00, 8),
(9, '2022-01-09', 900.00, 9),
(10, '2022-01-10', 1000.00, 10);


------------------------------------------
  
--Creare un utente per la federazione:
CREATE USER utente_federazione WITH PASSWORD 'password';

--Creare una estensione per la federazione:
CREATE EXTENSION postgres_fdw;

--Creare una connessione remota dal database locale  al database esterno:
CREATE SERVER db_server_esterno
  FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'nome_host_esterno', port 'numero_porta', dbname 'nome_utente_esterno');  

--Creare un mapping tra gli utenti locali e gli utenti remoti:
CREATE USER MAPPING FOR nome_utente_locale
  SERVER db_server_esterno
  OPTIONS (user 'nome_utente_esterno', password 'password_esterna');
  
--Creare un foreign table nel database locale che rappresenti la tabella "clienti" del database esterno:
CREATE FOREIGN TABLE clienti
  (id int4, nome varchar(50), cognome varchar(50), email varchar(50), telefono varchar(20))
  SERVER db_server_esterno
  OPTIONS (schema_name 'public', table_name 'clienti');
  
  