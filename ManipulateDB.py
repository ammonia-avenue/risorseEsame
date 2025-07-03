import mysql.connector
import config as cf  # Importa config per ottenere la configurazione del database


def copia_errori_forgia():
    """
    Copia le righe dalla tabella sf_forgia alla tabella sf_erroriForgia
    dove TipoErrore non è 'Nessun incidente'. Aggiunge un controllo per evitare
    di copiare righe con Id già presenti nella tabella sf_erroriForgia.
    """
    try:
        # Connessione al database utilizzando i parametri di configurazione
        conn = mysql.connector.connect(**cf.DB_CONFIG)
        cursor = conn.cursor()

        # Creazione della nuova tabella sf_erroriForgia (se non esiste)
        cursor.execute(''' 
        CREATE TABLE IF NOT EXISTS sf_erroriForgia (
            Id VARCHAR(20) PRIMARY KEY,
            Data_Ora DATETIME NOT NULL,
            Id_Stampo INT,
            Id_Acciaio INT,
            Peso DECIMAL(10,3),
            Temperatura INT,
            TipoErrore VARCHAR(255),
            Id_Macchinario INT,
            ID_Operatore INT
        );
        ''')
        print("Tabella sf_erroriForgia creata con successo (se non esisteva).")

        # Verifica se l'Id esiste già nella tabella sf_erroriForgia
        cursor.execute('''SELECT Id FROM sf_erroriForgia''')
        existing_ids = {row[0] for row in cursor.fetchall()}

        # Copia i dati dalla tabella sf_forgia alla tabella sf_erroriForgia
        cursor.execute('''
        SELECT * FROM sf_forgia WHERE TipoErrore != 'Nessun incidente';
        ''')

        rows_to_insert = cursor.fetchall()

        # Filtro le righe che non sono già presenti in sf_erroriForgia
        new_rows = [row for row in rows_to_insert if row[0] not in existing_ids]

        if new_rows:
            cursor.executemany('''
            INSERT INTO sf_erroriForgia (Id, Data_Ora, Id_Stampo, Id_Acciaio, Peso, Temperatura, TipoErrore, Id_Macchinario, ID_Operatore)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s);
            ''', new_rows)
            conn.commit()

            # Conferma quante righe sono state inserite
            cursor.execute('SELECT COUNT(*) FROM sf_erroriForgia;')
            row_count = cursor.fetchone()[0]
            return f"Totale righe copiate nella tabella sf_erroriForgia: {row_count}"
        else:
            return "Nessuna nuova riga da inserire, tutti gli Id sono già presenti."

    except mysql.connector.Error as err:
        return f"Errore: {err}"

    finally:
        # Chiudi la connessione al database
        if conn.is_connected():
            cursor.close()
            conn.close()





def copia_errori_cnc():
    """
    Copia le righe dalla tabella sf_cnc alla tabella sf_erroriCnc
    dove TipoErrore non è 'Nessun incidente'. Aggiunge un controllo per evitare
    di copiare righe con Id già presenti nella tabella sf_erroriForgia.
    """
    try:
        # Connessione al database utilizzando i parametri di configurazione
        conn = mysql.connector.connect(**cf.DB_CONFIG)
        cursor = conn.cursor()

        # Creazione della nuova tabella sf_erroriCnc (se non esiste)
        cursor.execute(''' 
        CREATE TABLE IF NOT EXISTS sf_erroriCnc (
            Id VARCHAR(20) NOT NULL PRIMARY KEY,               -- Identificativo univoco
            Data_Ora DATETIME NOT NULL,                -- Data e ora dell'evento
            Id_Operatore INT NOT NULL,                 -- Identificativo dell'operatore
            Id_Pezzo INT NOT NULL,                     -- Identificativo del pezzo
            Numero_Pezzi INT ,                 -- Numero dei pezzi prodotti
            Tipo_Errore VARCHAR(255) DEFAULT NULL      -- Tipo di errore (se applicabile)
        );
        ''')
        print("Tabella sf_erroriCnc creata con successo (se non esisteva).")

        # Verifica se l'Id esiste già nella tabella sf_erroriCnc
        cursor.execute('''SELECT Id FROM sf_erroriCnc''')
        existing_ids = {row[0] for row in cursor.fetchall()}

        # Copia i dati dalla tabella sf_cnc alla tabella sf_erroriForgia
        cursor.execute('''
        SELECT * FROM sf_cncs WHERE Tipo_Errore != 'Nessun incidente';
        ''')

        rows_to_insert = cursor.fetchall()

        # Filtro le righe che non sono già presenti in sf_erroriForgia
        new_rows = [row for row in rows_to_insert if row[0] not in existing_ids]

        if new_rows:
            cursor.executemany('''
            INSERT INTO sf_erroriCnc (Id, Data_Ora, Id_Operatore, Id_Pezzo, Numero_Pezzi, Tipo_Errore)
            VALUES (%s, %s, %s, %s, %s, %s);
            ''', new_rows)
            conn.commit()

            # Conferma quante righe sono state inserite
            cursor.execute('SELECT COUNT(*) FROM sf_erroriCnc;')
            row_count = cursor.fetchone()[0]
            return f"Totale righe copiate nella tabella sf_erroriCnc: {row_count}"
        else:
            return "Nessuna nuova riga da inserire, tutti gli Id sono già presenti."

    except mysql.connector.Error as err:
        return f"Errore: {err}"

    finally:
        # Chiudi la connessione al database
        if conn.is_connected():
            cursor.close()
            conn.close()



def copia_validi_cnc():
    """
    Copia le righe dalla tabella sf_cnc alla tabella sf_NoErroriCnc
    dove TipoErrore non è un qualsiasi errore. Aggiunge un controllo per evitare
    di copiare righe con Id già presenti nella tabella sf_erroriForgia.
    """
    try:
        # Connessione al database utilizzando i parametri di configurazione
        conn = mysql.connector.connect(**cf.DB_CONFIG)
        cursor = conn.cursor()

        # Creazione della nuova tabella sf_erroriCnc (se non esiste)
        cursor.execute(''' 
        CREATE TABLE IF NOT EXISTS sf_NoErroriCnc (
            Id VARCHAR(20) NOT NULL PRIMARY KEY,               -- Identificativo univoco
            Data_Ora DATETIME NOT NULL,                -- Data e ora dell'evento
            Id_Operatore INT NOT NULL,                 -- Identificativo dell'operatore
            Id_Pezzo INT NOT NULL,                     -- Identificativo del pezzo
            Numero_Pezzi INT ,                 -- Numero dei pezzi prodotti
            Tipo_Errore VARCHAR(255) DEFAULT NULL      -- Tipo di errore (se applicabile)
        );
        ''')
        print("Tabella sf_NoErroriCnc creata con successo (se non esisteva).")

        # Verifica se l'Id esiste già nella tabella sf_erroriCnc
        cursor.execute('''SELECT Id FROM sf_NoErroriCnc''')
        existing_ids = {row[0] for row in cursor.fetchall()}

        # Copia i dati dalla tabella sf_cnc alla tabella sf_erroriForgia
        cursor.execute('''
        SELECT * FROM sf_cncs WHERE Tipo_Errore = 'Nessun incidente';
        ''')

        rows_to_insert = cursor.fetchall()

        # Filtro le righe che non sono già presenti in sf_erroriForgia
        new_rows = [row for row in rows_to_insert if row[0] not in existing_ids]

        if new_rows:
            cursor.executemany('''
            INSERT INTO sf_NoErroriCnc (Id, Data_Ora, Id_Operatore, Id_Pezzo, Numero_Pezzi, Tipo_Errore)
            VALUES (%s, %s, %s, %s, %s, %s);
            ''', new_rows)
            conn.commit()

            # Conferma quante righe sono state inserite
            cursor.execute('SELECT COUNT(*) FROM sf_NoErroriCnc;')
            row_count = cursor.fetchone()[0]
            return f"Totale righe copiate nella tabella sf_NoErroriCnc: {row_count}"
        else:
            return "Nessuna nuova riga da inserire, tutti gli Id sono già presenti."

    except mysql.connector.Error as err:
        return f"Errore: {err}"

    finally:
        # Chiudi la connessione al database
        if conn.is_connected():
            cursor.close()
            conn.close()


def copia_Validi_forgia():
    """
    Copia le righe dalla tabella sf_forgia alla tabella sf_erroriForgia
    dove TipoErrore non è 'Nessun incidente'. Aggiunge un controllo per evitare
    di copiare righe con Id già presenti nella tabella sf_erroriForgia.
    """
    try:
        # Connessione al database utilizzando i parametri di configurazione
        conn = mysql.connector.connect(**cf.DB_CONFIG)
        cursor = conn.cursor()

        # Creazione della nuova tabella sf_NoErroriForigia (se non esiste)
        cursor.execute(''' 
        CREATE TABLE IF NOT EXISTS sf_NoErroriForigia (
            Id VARCHAR(20) PRIMARY KEY,
            Data_Ora DATETIME NOT NULL,
            Id_Stampo INT,
            Id_Acciaio INT,
            Peso DECIMAL(10,3),
            Temperatura INT,
            TipoErrore VARCHAR(255),
            Id_Macchinario INT,
            ID_Operatore INT
        );
        ''')
        print("Tabella sf_NoErroriForigia creata con successo (se non esisteva).")

        # Verifica se l'Id esiste già nella tabella sf_NoErroriForigia
        cursor.execute('''SELECT Id FROM sf_NoErroriForigia''')
        existing_ids = {row[0] for row in cursor.fetchall()}

        # Copia i dati dalla tabella sf_forgia alla tabella sf_NoErroriForigia
        cursor.execute('''
        SELECT * FROM sf_forgia WHERE TipoErrore = 'Nessun incidente';
        ''')

        rows_to_insert = cursor.fetchall()

        # Filtro le righe che non sono già presenti in sf_erroriForgia
        new_rows = [row for row in rows_to_insert if row[0] not in existing_ids]

        if new_rows:
            cursor.executemany('''
            INSERT INTO sf_NoErroriForigia (Id, Data_Ora, Id_Stampo, Id_Acciaio, Peso, Temperatura, TipoErrore, Id_Macchinario, ID_Operatore)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s);
            ''', new_rows)
            conn.commit()

            # Conferma quante righe sono state inserite
            cursor.execute('SELECT COUNT(*) FROM sf_erroriForgia;')
            row_count = cursor.fetchone()[0]
            return f"Totale righe copiate nella tabella sf_NoErroriForigia: {row_count}"
        else:
            return "Nessuna nuova riga da inserire, tutti gli Id sono già presenti."

    except mysql.connector.Error as err:
        return f"Errore: {err}"

    finally:
        # Chiudi la connessione al database
        if conn.is_connected():
            cursor.close()
            conn.close()


def copia_Infortuni_forgia():
    """
    Copia le righe dalla tabella sf_forgia alla tabella sf_Infortuni
    dove TipoErrore è 'Infortunio'. Evita di copiare righe con Id già presenti
    nella tabella sf_Infortuni.
    """
    try:
        # Connessione al database utilizzando i parametri di configurazione
        conn = mysql.connector.connect(**cf.DB_CONFIG)
        cursor = conn.cursor()

        # Creazione della nuova tabella sf_Infortuni (se non esiste)
        cursor.execute(''' 
        CREATE TABLE IF NOT EXISTS sf_Infortuni (
            Id VARCHAR(20) PRIMARY KEY,
            Data_Ora DATETIME NOT NULL,
            TipoErrore VARCHAR(255),
            Id_Macchinario INT,
            ID_Operatore INT
        );
        ''')
        print("Tabella sf_Infortuni creata con successo (se non esisteva).")

        # Recupero degli Id già presenti nella tabella sf_Infortuni
        cursor.execute('''SELECT Id FROM sf_Infortuni''')
        existing_ids = {row[0] for row in cursor.fetchall()}

        # Selezione dei dati desiderati dalla tabella sf_forgia
        cursor.execute('''
        SELECT Id, Data_Ora, TipoErrore, Id_Macchinario, ID_Operatore
        FROM sf_forgia
        WHERE TipoErrore = 'Infortunio';
        ''')

        rows_to_insert = cursor.fetchall()

        # Filtro delle righe che non sono già presenti in sf_Infortuni
        new_rows = [row for row in rows_to_insert if row[0] not in existing_ids]

        if new_rows:
            cursor.executemany('''
            INSERT INTO sf_Infortuni (Id, Data_Ora, TipoErrore, Id_Macchinario, ID_Operatore)
            VALUES (%s, %s, %s, %s, %s);
            ''', new_rows)
            conn.commit()

            # Conferma quante righe sono state inserite
            cursor.execute('SELECT COUNT(*) FROM sf_Infortuni;')
            row_count = cursor.fetchone()[0]
            return f"Totale righe copiate nella tabella sf_Infortuni: {len(new_rows)}"
        else:
            return "Nessuna nuova riga da inserire, tutti gli Id sono già presenti."

    except mysql.connector.Error as err:
        return f"Errore: {err}"

    finally:
        # Chiusura della connessione al database
        if conn.is_connected():
            cursor.close()
            conn.close()


def truncate_table_forgia():
    """
    Funzione per troncare la tabella 'sf_forgia'.
    """
    try:
        # Connessione al database utilizzando i parametri di configurazione
        conn = mysql.connector.connect(**cf.DB_CONFIG)
        cursor = conn.cursor()

        # Comando SQL per il truncate
        tables_to_truncate = ["sf_forgia", "sf_erroriForgia", "sf_Infortuni","sf_NoErroriForigia"]

        for table in tables_to_truncate:
            truncate_query = f"TRUNCATE TABLE {table}"
            cursor.execute(truncate_query)

        conn.commit()

        print("La tabella 'sf_forgia' è stata troncata con successo.")
        return True

    except mysql.connector.Error as e:
        print(f"Errore durante l'esecuzione del truncate: {e}")
        return False

    finally:
        # Chiudi la connessione al database
        if 'conn' in locals() and conn.is_connected():
            cursor.close()
            conn.close()
            print("Connessione al database chiusa.")


def truncate_table_cnc():
    """
    Funzione per troncare la tabella 'sf_forgia'.
    """
    try:
        # Connessione al database utilizzando i parametri di configurazione
        conn = mysql.connector.connect(**cf.DB_CONFIG)
        cursor = conn.cursor()

        table_to_truncate=["sf_cncs","sf_erroriCnc","sf_NoErroriCnc"]

        for table in table_to_truncate:
            truncate_query = f"TRUNCATE TABLE {table}"
            cursor.execute(truncate_query)


        conn.commit()

        print("La tabella 'sf_cnc' e collegate sono state troncate con successo.")
        return True

    except mysql.connector.Error as e:
        print(f"Errore durante l'esecuzione del truncate: {e}")
        return False

    finally:
        # Chiudi la connessione al database
        if 'conn' in locals() and conn.is_connected():
            cursor.close()
            conn.close()
            print("Connessione al database chiusa.")



def backup_forgia():
    try:
        # Connessione al db
        conn = mysql.connector.connect(**cf.DB_CONFIG)
        cursor = conn.cursor()

        # Creazione tabella di backup
        create_backup_table = """
        CREATE TABLE IF NOT EXISTS Backup_Forgia (
            Id VARCHAR(20) NOT NULL PRIMARY KEY,
            Data_Ora DATETIME,
            Id_Stampo INT,
            Id_Acciaio INT,
            Peso DECIMAL(10,3),
            Temperatura INT,
            TipoErrore VARCHAR(255),
            Id_Macchinario INT,
            ID_Operatore VARCHAR(255)
        );
        """
        cursor.execute(create_backup_table)
        conn.commit()

        # Comando per creare il backup dei dati con controllo sugli ID esistenti
        backup_dati = """
        INSERT IGNORE INTO Backup_Forgia (Id, Data_Ora, Id_Stampo, Id_Acciaio, Peso, Temperatura, TipoErrore, Id_Macchinario, ID_Operatore)
        SELECT Id, Data_Ora, Id_Stampo, Id_Acciaio, Peso, Temperatura, TipoErrore, Id_Macchinario, ID_Operatore
        FROM sf_forgia;
        """
        cursor.execute(backup_dati)
        conn.commit()

        print("Backup della tabella sf_forgia avvenuto con controllo sugli ID.")
        return True
    except mysql.connector.Error as e:
        print(f"Errore durante l'esecuzione del backup: {e}")
        return False
    finally:
        # Chiudi connessione al database
        if 'conn' in locals() and conn.is_connected():
            cursor.close()
            conn.close()
            print("Connessione al database chiusa.")



def backup_cnc():
    try:
        # Connessione al db
        conn = mysql.connector.connect(**cf.DB_CONFIG)
        cursor = conn.cursor()

        # Creazione tabella di backup
        create_backup_table = """
        CREATE TABLE IF NOT EXISTS Backup_Cncs (
            Id VARCHAR(20) NOT NULL PRIMARY KEY,               -- Identificativo univoco
            Data_Ora DATETIME NOT NULL,                -- Data e ora dell'evento
            Id_Operatore INT NOT NULL,                 -- Identificativo dell'operatore
            Id_Pezzo INT NOT NULL,                     -- Identificativo del pezzo
            Numero_Pezzi INT ,                 -- Numero dei pezzi prodotti
            Tipo_Errore VARCHAR(255) DEFAULT NULL      -- Tipo di errore (se applicabile)
        );
        """
        cursor.execute(create_backup_table)
        conn.commit()

        # Comando per creare il backup dei dati con controllo sugli ID esistenti
        backup_dati = """
        INSERT IGNORE INTO Backup_Cncs (Id, Data_Ora,Id_Operatore,Id_Pezzo,Numero_Pezzi,Tipo_Errore)
        SELECT Id, Data_Ora,Id_Operatore,Id_Pezzo,Numero_Pezzi,Tipo_Errore
        FROM sf_cncs;
        """
        cursor.execute(backup_dati)
        conn.commit()

        print("Backup della tabella sf_cncs avvenuto con controllo sugli ID.")
        return True
    except mysql.connector.Error as e:
        print(f"Errore durante l'esecuzione del backup: {e}")
        return False
    finally:
        # Chiudi connessione al database
        if 'conn' in locals() and conn.is_connected():
            cursor.close()
            conn.close()
            print("Connessione al database chiusa.")



def ripristina_forgia():
    try:
        # Connessione al DB
        conn = mysql.connector.connect(**cf.DB_CONFIG)
        cursor = conn.cursor()

        # Log
        print("Connessione al database stabilita.")

        # Query per contare il numero di righe nella tabella sf_forgia
        query = "SELECT COUNT(*) FROM sf_forgia;"
        cursor.execute(query)

        # Recupero il risultato
        count = cursor.fetchone()[0]
        print(f"Numero di righe nella tabella sf_forgia: {count}")

        if count == 0:
            # La tabella è vuota, quindi esegui il ripristino
            copy = """INSERT INTO sf_forgia
                      SELECT * FROM Backup_Forgia;
                    """
            cursor.execute(copy)
            conn.commit()
            print("Dati ripristinati con successo.")
            return True
        else:
            # La tabella non è vuota, non eseguire il ripristino
            print("La tabella principale non è completamente vuota.")
            return False

    except mysql.connector.Error as e:
        print(f"Errore durante l'esecuzione del ripristino: {e}")
        return False

    finally:
        # Chiudi la connessione al DB
        if 'conn' in locals() and conn.is_connected():
            cursor.close()
            conn.close()
            print("Connessione al database chiusa.")





def ripristina_cnc():
    try:
        # Connessione al DB
        conn = mysql.connector.connect(**cf.DB_CONFIG)
        cursor = conn.cursor()

        # Log
        print("Connessione al database stabilita.")

        # Query per contare il numero di righe nella tabella sf_forgia
        query = "SELECT COUNT(*) FROM sf_cncs;"
        cursor.execute(query)

        # Recupero il risultato
        count = cursor.fetchone()[0]
        print(f"Numero di righe nella tabella sf_forgia: {count}")

        if count == 0:
            # La tabella è vuota, quindi esegui il ripristino
            copy = """INSERT INTO sf_cncs
                      SELECT * FROM Backup_Cncs;
                    """
            cursor.execute(copy)
            conn.commit()
            print("Dati ripristinati con successo.")
            return True
        else:
            # La tabella non è vuota, non eseguire il ripristino
            print("La tabella principale non è completamente vuota.")
            return False

    except mysql.connector.Error as e:
        print(f"Errore durante l'esecuzione del ripristino: {e}")
        return False

    finally:
        # Chiudi la connessione al DB
        if 'conn' in locals() and conn.is_connected():
            cursor.close()
            conn.close()
            print("Connessione al database chiusa.")





