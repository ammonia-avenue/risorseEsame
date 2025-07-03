/*
Consegna 1:
Scrivere ed eseguire il codice utile a gestire una relazione di tipo (N:N) creando
3 tabelle ed i relativi vincoli di integrità.

Tabella 1: ft_autore Contiene informazioni sugli autori di libri.
autore_id (INT, PRIMARY KEY)
nome (VARCHAR, non nullo)
nazionalità (VARCHAR)

Tabella 2: ft_libro Contiene informazioni sui libri disponibili.
libro_id (INT, PRIMARY KEY)
titolo (VARCHAR, non nullo)
prezzo (DECIMAL, non nullo)

Tabella 3: ft_autore_libro Gestisce le relazioni tra autori e libri.
autore_id (INT, FOREIGN KEY che fa riferimento a ft_autore.autore_id)
libro_id (INT, FOREIGN KEY che fa riferimento a ft_libro.libro_id)
anno_pubblicazione (YEAR)

Assicurati di gestire le foreign key in modo da garantire l'integrità dei dati tra le tabelle.
*/

CREATE TABLE ft_autore (
	autore_id int,
	nome varchar(100) NOT NULL,
	nazionalita varchar NOT NULL,
	CONSTRAINT autore_pk PRIMARY KEY (autore_id)
	
);

CREATE TABLE ft_libro (
	libro_id int,
	titolo varchar(100) NOT NULL,
	prezzo decimal(5, 2) NOT NULL,
	CONSTRAINT libro_pk PRIMARY KEY (libro_id)
	
);

CREATE TABLE ft_autore_libro (
	autore_id int,
	libro_id int,
	anno_pubblicazione int, 
	CONSTRAINT autore_libro_pk PRIMARY KEY (autore_id, libro_id),
	CONSTRAINT autore_fk foreign key (autore_id) references ft_autore(autore_id)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT libro_fk foreign key (libro_id) references ft_libro(libro_id)
		ON DELETE CASCADE ON UPDATE CASCADE
	
);



/*
Consegna 2:
- Realizzare una VISTA chiamata: v_libri_autore che mostra, per ogni libro, tutti i dettagli dell'autore e tutti i dettagli del libro.
- Realizzare una VISTA chiamata: v_fatturato_autore che mostra, "per ogni autore", il totale fatturato (totale dei prezzi dei libri pubblicati).
*/

create view
	v_libri_autore as
select
	a.autore_id,
	a.nome,
	a.nazionalita,
	l.libro_id,
	l.titolo,
	l.prezzo,
	al.anno_pubblicazione
from
	ft_autore a
left join
	ft_autore_libro al on a.autore_id = al.autore_id
left join 
    ft_libro l on al.libro_id = l.libro_id;
	
select * from v_libri_autore;
   

CREATE VIEW v_fatturato_autore AS
SELECT
    a.autore_id,
    a.nome AS nome_autore,
    SUM(l.prezzo) AS totale_fatturato
FROM
    ft_autore a
left JOIN
    ft_autore_libro al ON a.autore_id = al.autore_id
left JOIN
    ft_libro l ON al.libro_id = l.libro_id
GROUP BY
    a.autore_id, a.nome;
   
/*
Consegna_3 (su architettura ROI_PROJECT):
Realizzare la FUNZIONE: stima_budget() che, passato come parametro in entrata l' id_investimento:
• Legge il valore del budget
• Se tipo_investimento = 'Titoli azionari'
• ricalcola valore budget / 1.2
• invece se tipologia = 'Titoli obbligazionari'
• ricalcola valore budget / 1.3

• restituisce il valore del budget

P.S. La funzione deve gestire la scrittura su tabella monitoraggio_log di:
• quando inizia
• quando termina
• eventuali ECCEZIONI che si verifichino
*/

   /*
CREATE OR REPLACE FUNCTION stima_budget(id_investimento INT)
RETURNS DECIMAL(15, 2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_budget DECIMAL(15, 2);
    v_tipo_investimento VARCHAR(255);
BEGIN
    -- Log iniziale per la funzione
    INSERT INTO public.ft_log_monitoraggio(tracciato, livello, testo)
    VALUES ('stima_budget', 'INFO', 'Inizio elaborazione per investimento ' || id_investimento);

    -- Recupera il budget e il tipo di investimento per l'id_investimento dato
    SELECT budget, tipo_investimento
    INTO v_budget, v_tipo_investimento
    FROM public.ft_investimento
    WHERE id_investimento = id_investimento;

    -- Se l'investimento non è trovato, ritorna NULL e logga l'evento
    IF NOT FOUND THEN
        INSERT INTO public.ft_log_monitoraggio(tracciato, livello, testo)
        VALUES ('stima_budget', 'WARNING', 'Nessun investimento trovato per id_investimento ' || id_investimento);
        RETURN NULL;
    END IF;

    -- Calcola il budget in base al tipo di investimento
    IF v_tipo_investimento = 'Titoli azionari' THEN
        v_budget := v_budget / 1.2;
    ELSIF v_tipo_investimento = 'Titoli obbligazionari' THEN
        v_budget := v_budget / 1.3;
    ELSE
        -- Tipo di investimento non valido, restituisce NULL e logga l'evento
        INSERT INTO public.ft_log_monitoraggio(tracciato, livello, testo)
        VALUES ('stima_budget', 'WARNING', 'Tipo di investimento non valido per id_investimento ');
        RETURN NULL;
    END IF;

    -- Log finale per il successo della funzione
    INSERT INTO public.ft_log_monitoraggio(tracciato, livello, testo)
    VALUES ('stima_budget', 'INFO', 'Elaborazione completata per investimento ');

    -- Restituisce il budget stimato
    RETURN v_budget;

EXCEPTION
    -- Gestione di qualsiasi errore
    WHEN OTHERS THEN
        -- Log dell'errore
        INSERT INTO public.ft_log_monitoraggio(tracciato, livello, testo)
        VALUES ('stima_budget', 'ERROR', 'Errore nell''elaborazione per investimento ' || id_investimento || ': ' || SQLERRM);

        -- Ritorna NULL in caso di errore
        RETURN NULL;
END;
$$;
*/

CREATE OR REPLACE FUNCTION stima_budget(id_investimento INT)
RETURNS DECIMAL(15, 2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_budget DECIMAL(15, 2);
    v_tipo_investimento VARCHAR(255);
BEGIN
    -- Log iniziale per la funzione
    INSERT INTO public.ft_log_monitoraggio(tracciato, livello, testo)
    VALUES ('stima_budget', 'INFO', 'Inizio elaborazione per investimento ' || id_investimento);

    -- Recupera il budget e il tipo di investimento per l'id_investimento dato
    SELECT budget, tipo_investimento
    INTO v_budget, v_tipo_investimento
    FROM public.ft_investimento
    WHERE id_investimento = id_investimento;  -- Utilizzare l'ID dell'investimento

    -- Se l'investimento non è trovato, ritorna NULL e logga l'evento
    IF NOT FOUND THEN
        INSERT INTO public.ft_log_monitoraggio(tracciato, livello, testo)
        VALUES ('stima_budget', 'WARNING', 'Nessun investimento trovato per id_investimento ' || id_investimento);
        RETURN NULL;
    END IF;

    -- Log del tipo di investimento trovato
    INSERT INTO public.ft_log_monitoraggio(tracciato, livello, testo)
    VALUES ('stima_budget', 'INFO', 'Tipo investimento trovato: ' || v_tipo_investimento || ', Budget: ' || v_budget);

    -- Calcola il budget in base al tipo di investimento
    IF v_tipo_investimento = 'Titoli azionari' THEN
        v_budget := v_budget / 1.2;
    ELSIF v_tipo_investimento = 'Titoli obbligazionari' THEN
        v_budget := v_budget / 1.3;
    ELSE
        -- Tipo di investimento non valido, restituisce NULL e logga l'evento
        INSERT INTO public.ft_log_monitoraggio(tracciato, livello, testo)
        VALUES ('stima_budget', 'WARNING', 'Tipo di investimento non valido per id_investimento ' || id_investimento || ': ' || v_tipo_investimento);
        RETURN NULL;
    END IF;

    -- Log finale per il successo della funzione
    INSERT INTO public.ft_log_monitoraggio(tracciato, livello, testo)
    VALUES ('stima_budget', 'INFO', 'Elaborazione completata per investimento ' || id_investimento || ': Budget stimato ' || v_budget);

    -- Restituisce il budget stimato
    RETURN v_budget;

EXCEPTION
    -- Gestione di qualsiasi errore
    WHEN OTHERS THEN
        -- Log dell'errore
        INSERT INTO public.ft_log_monitoraggio(tracciato, livello, testo)
        VALUES ('stima_budget', 'ERROR', 'Errore nell''elaborazione per investimento ' || id_investimento || ': ' || SQLERRM);

        -- Ritorna NULL in caso di errore
        RETURN NULL;
END;
$$;


SELECT stima_budget(15); -- Dove '1' è l'id dell'investimento.


/*
Consegna_4 (su architettura ROI_PROJECT):
Realizzare la PROCEDURA: calcola_nuovi_budget() che scrive nella tabella: monitoraggio_log per ogni investimento:

• id_investimento
• descrizione_investimento
• stima_del_budget
richiamando la funzione: stima_budget().

P.S. La procedura deve gestire la scrittura su tabella monitoraggio_log di:
• quando inizia
• quando termina
• eventuali ECCEZIONI che si verifichino
*/

CREATE OR REPLACE PROCEDURE calcola_nuovi_budget()
LANGUAGE plpgsql
AS $$
DECLARE
    v_stima_budget DECIMAL(15, 2);
BEGIN
    -- Log per l'inizio del processo
    INSERT INTO public.ft_log_monitoraggio(tracciato, livello, testo)
    VALUES ('calcola_nuovi_budget', 'INFO', 'Inizio calcolo nuovi budget per tutti gli investimenti');

    -- Esegui l'aggiornamento per tutti gli investimenti in un'unica query
    -- Chiamo la funzione stima_budget per ogni investimento e inserisco il log
    INSERT INTO public.ft_log_monitoraggio(tracciato, livello, testo)
    SELECT
        'calcola_nuovi_budget' AS tracciato,
        'INFO' AS livello,
        'Budget calcolato per investimento ' || id_investimento || 
        ' (' || descrizione || '): ' || COALESCE(stima_budget(id_investimento)::text, 'Nessun budget')
    FROM public.ft_investimento;

    -- Log per la fine del processo
    INSERT INTO public.ft_log_monitoraggio(tracciato, livello, testo)
    VALUES ('calcola_nuovi_budget', 'INFO', 'Fine calcolo nuovi budget per tutti gli investimenti');

EXCEPTION
    -- Gestione errori globale
    WHEN OTHERS THEN
        -- Logga l'errore
        INSERT INTO public.ft_log_monitoraggio(tracciato, livello, testo)
        VALUES ('calcola_nuovi_budget', 'ERROR', 'Errore nella procedura calcola_nuovi_budget: ' || SQLERRM);
END;
$$;

CALL calcola_nuovi_budget();


select * from ft_log_monitoraggio flm ;


