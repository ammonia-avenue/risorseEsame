import os

import mysql
from flask import Flask, render_template, redirect, url_for, flash, request, jsonify, session

from ManipulateDB import copia_errori_forgia, copia_Validi_forgia, copia_Infortuni_forgia,copia_errori_cnc,copia_validi_cnc,truncate_table_forgia,truncate_table_cnc,backup_forgia,backup_cnc,ripristina_forgia,ripristina_cnc
from connect import connect_to_sharepoint, download_and_clean_csv, insert_data_into_db,download_and_clean_csv_cnc,insert_data_cnc_into_db
import config as cf

app = Flask(__name__)

app.secret_key = 'supersecretkey'  # Necessario per i messaggi flash

# Genera una chiave segreta diversa ogni volta che l'app viene avviata
#app.secret_key = os.urandom(24)  # Questo invalida le sessioni precedenti



# Funzione per connettersi al database MySQL
def get_db_connection():
    connection = mysql.connector.connect(
        host=cf.DB_CONFIG['host'],
        port=cf.DB_CONFIG['port'],
        user=cf.DB_CONFIG['user'],
        password=cf.DB_CONFIG['password'],
        database=cf.DB_CONFIG['database']
    )
    return connection


@app.before_request
def ensure_login():
    allowed_routes = ['login', 'static']
    if 'logged_in' not in session and request.endpoint not in allowed_routes:
        return redirect(url_for('login'))




@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        try:
            username = request.form['username']
            password = request.form['password']

            # Logica per la connessione a SharePoint
            ctx = connect_to_sharepoint(username, password)

            if ctx:
                session['logged_in'] = True
                session['username'] = username
                session['password'] = password  # Memorizza la password nella sessione

                # Verifica se la sessione è aggiornata correttamente
                print("Sessione dopo login:", session)

                user_info = get_user_info(ctx)
                flash('Connessione a SharePoint riuscita!', 'success')

                return jsonify({"redirect_url": url_for('home')}), 200  # Ritorna il reindirizzamento in JSON

            else:
                return jsonify({"error": "Credenziali non valide"}), 401

        except Exception as e:
            print(f"Errore durante l'autenticazione: {e}")
            return jsonify({"error": "Credenziali errate"}), 401

    return render_template('login.html')  # Mostra il modulo di login quando viene richiesta una GET

@app.route('/scarica_e_pulisci', methods=['GET'])
def scarica_e_pulisci():
    try:
        # Recupera il contesto SharePoint dalla sessione
        username = session.get('username')
        password = session.get('password')
        print(username, password)
        if not username or not password:
            return jsonify({"error": "Utente non autenticato"}), 401

        # Connetti a SharePoint
        ctx = connect_to_sharepoint(username, password)

        if ctx:
            # Percorso della cartella e del file definiti nella configurazione
            folder = cf.SHAREPOINT_CONFIG['folder']
            file_name = cf.SHAREPOINT_CONFIG['file_name']

            # Specifica dove vuoi salvare il file localmente
            local_path = './downloads'

            # Assicurati che la directory esista
            os.makedirs(local_path, exist_ok=True)

            # Scarica e pulisci il file
            cleaned_file = download_and_clean_csv(ctx, folder, file_name, local_path)

            # Inserisci i dati nel DB
            insert_data_into_db(cleaned_file)

            return jsonify({"message": f"File scaricato, pulito e dati inseriti nel DB: {cleaned_file}"}), 200
        else:
            return jsonify({"error": "Errore di connessione a SharePoint"}), 500

    except Exception as e:
        print(f"Errore durante il download o la pulizia del file: {e}")
        return jsonify({"error": "Errore durante il download o la pulizia del file"}), 500





@app.route('/scarica_e_pulisci_cnc', methods=['GET'])
def scarica_e_pulisci_cnc():
    try:
        # Recupera il contesto SharePoint dalla sessione
        username = session.get('username')
        password = session.get('password')
        if not username or not password:
            return jsonify({"error": "Utente non autenticato"}), 401

        # Connetti a SharePoint
        ctx = connect_to_sharepoint(username, password)

        if ctx:
            # Percorso della cartella e del file definiti nella configurazione
            folder = cf.SHAREPOINT_CONFIG['folder']
            file_name = cf.SHAREPOINT_CONFIG['file_cnc']

            # Specifica dove vuoi salvare il file localmente
            local_path = './downloads'

            # Assicurati che la directory esista
            os.makedirs(local_path, exist_ok=True)

            # Scarica e pulisci il file
            cleaned_file = download_and_clean_csv_cnc(ctx, folder, file_name, local_path)

            # Inserisci i dati nel DB
            insert_data_cnc_into_db(cleaned_file)

            return jsonify({"message": f"File scaricato, pulito e dati inseriti nel DB: {cleaned_file}"}), 200
        else:
            return jsonify({"error": "Errore di connessione a SharePoint"}), 500

    except Exception as e:
        print(f"Errore durante il download o la pulizia del file: {e}")
        return jsonify({"error": "Errore durante il download o la pulizia del file"}), 500






@app.route('/copia_errori_forgia', methods=['GET'])
def copia_errori():
    """
    Endpoint API per eseguire la copia degli errori da sf_forgia a sf_erroriForgia.
    """
    result = copia_errori_forgia()  # Chiama la funzione dal file ManipulateDB
    return jsonify({"message": result}), 200


@app.route('/copia_errori_cnc', methods=['GET'])
def copia_erroriCnc():
    """
    Endpoint API per eseguire la copia degli errori da sf_forgia a sf_erroriForgia.
    """
    result = copia_errori_cnc()  # Chiama la funzione dal file ManipulateDB
    return jsonify({"message": result}), 200



@app.route('/copia_noerrori_forgia', methods=['GET'])
def copia_Noerrori():
    """
    Endpoint API per eseguire la copia degli errori da sf_forgia a sf_erroriForgia.
    """
    result = copia_Validi_forgia()  # Chiama la funzione dal file ManipulateDB
    return jsonify({"message": result}), 200


@app.route('/copia_noerrori_cnc', methods=['GET'])
def copia_NoErroriCnc():
    """
    Endpoint API per eseguire la copia degli errori da sf_forgia a sf_erroriForgia.
    """
    result = copia_validi_cnc()  # Chiama la funzione dal file ManipulateDB
    return jsonify({"message": result}), 200



@app.route('/copia_infortuni_forgia', methods=['GET'])
def copia_infortuni():
    """
    Endpoint API per eseguire la copia degli errori da sf_forgia a sf_erroriForgia.
    """
    result = copia_Infortuni_forgia()  # Chiama la funzione dal file ManipulateDB
    return jsonify({"message": result}), 200




@app.route('/truncate_table_forgia', methods=['GET'])
def truncate_sf_forgia():
    """
    Endpoint API per eseguire il truncate della tabella sf_forgia.
    """
    result = truncate_table_forgia()  # Chiama la funzione dal file ManipulateDB
    return jsonify({"message": result}), 200


@app.route('/truncate_table_cnc', methods=['GET'])
def truncate_sf_cnc():
    """
    Endpoint API per eseguire il truncate della tabella sf_forgia.
    """
    result = truncate_table_cnc()  # Chiama la funzione dal file ManipulateDB
    return jsonify({"message": result}), 200



@app.route('/backup_tabella_forgia', methods=['GET'])
def backup_tabella_forgia():
    """
    Endpoint API per eseguire il backup della tabella sf_forgia.
    """
    result = backup_forgia()  # Chiama la funzione dal file ManipulateDB
    return jsonify({"message": result}), 200



@app.route('/backup_tabella_cnc', methods=['GET'])
def backup_tabella_cnc():
    """
    Endpoint API per eseguire il backup della tabella sf_forgia.
    """
    result = backup_cnc()  # Chiama la funzione dal file ManipulateDB
    return jsonify({"message": result}), 200

@app.route('/ripristino_tabella_forgia', methods=['GET', 'POST'])
def ripristino_forgia():
    if request.method == 'GET':
        # Verifica se la tabella è vuota
        try:
            conn = mysql.connector.connect(**cf.DB_CONFIG)
            cursor = conn.cursor()
            query = "SELECT COUNT(*) FROM sf_forgia;"
            cursor.execute(query)
            count = cursor.fetchone()[0]
            cursor.close()
            conn.close()

            is_empty = count == 0
            return jsonify({"success": True, "message": is_empty}), 200
        except Exception as e:
            return jsonify({"success": False, "message": str(e)}), 500

    if request.method == 'POST':
        # Esegui il ripristino
        result = ripristina_forgia()
        if result:
            return jsonify({"success": True, "message": "Dati ripristinati con successo."}), 200
        else:
            return jsonify({"success": False, "message": "Errore durante il ripristino dei dati."}), 500








@app.route('/ripristino_tabella_cnc', methods=['GET', 'POST'])
def ripristino_cnc():
    if request.method == 'GET':
        # Verifica se la tabella è vuota
        try:
            conn = mysql.connector.connect(**cf.DB_CONFIG)
            cursor = conn.cursor()
            query = "SELECT COUNT(*) FROM sf_cncs;"
            cursor.execute(query)
            count = cursor.fetchone()[0]
            cursor.close()
            conn.close()

            is_empty = count == 0
            return jsonify({"success": True, "message": is_empty}), 200
        except Exception as e:
            return jsonify({"success": False, "message": str(e)}), 500

    if request.method == 'POST':
        # Esegui il ripristino
        result = ripristina_cnc()
        if result:
            return jsonify({"success": True, "message": "Dati ripristinati con successo."}), 200
        else:
            return jsonify({"success": False, "message": "Errore durante il ripristino dei dati."}), 500





@app.route('/')
def home():
    if not session.get('logged_in'):  # Controlla se l'utente è loggato
        return redirect(url_for('login'))  # Se non è loggato, reindirizza al login
    return render_template('index.html')  # Mostra la home page


def get_user_info(ctx):
    # Esegui una richiesta a SharePoint per ottenere le informazioni dell'utente
    user = ctx.web.current_user.get().execute_query()

    # Ritorna le informazioni sull'utente
    return {
        "username": user.properties.get("LoginName"),
        "email": user.properties.get("Email"),
        "display_name": user.properties.get("Title")
    }




# API per ottenere i dati da una tabella
@app.route('/get_table_data_materiali', methods=['GET'])
def get_table_data_materiali():
    try:
        # Connessione al database
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)  # Usa 'dictionary=True' per restituire i risultati come dizionari

        # Esegui una query sulla tabella
        query = "SELECT * FROM materiali"  # Sostituisci con il nome della tua tabella
        cursor.execute(query)

        # Recupera i dati
        result = cursor.fetchall()

        # Chiudi la connessione
        cursor.close()
        connection.close()

        # Restituisci i dati in formato JSON
        return jsonify(result)

    except Exception as e:
        # Gestione degli errori
        print(f"Errore durante l'interrogazione del database: {e}")
        return jsonify({"error": "Si è verificato un errore nel recupero dei dati"}), 500




@app.route('/get_table_data_stampi', methods=['GET'])
def get_table_data_stampi():
    try:
        # Connessione al database
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)  # Usa 'dictionary=True' per restituire i risultati come dizionari

        # Esegui una query sulla tabella
        query = "SELECT * FROM stampi"  # Sostituisci con il nome della tua tabella
        cursor.execute(query)

        # Recupera i dati
        result = cursor.fetchall()

        # Chiudi la connessione
        cursor.close()
        connection.close()

        # Restituisci i dati in formato JSON
        return jsonify(result)

    except Exception as e:
        # Gestione degli errori
        print(f"Errore durante l'interrogazione del database: {e}")
        return jsonify({"error": "Si è verificato un errore nel recupero dei dati"}), 500





@app.route('/get_table_data_dipendenti', methods=['GET'])
def get_table_data_dipendeti():
    try:
        # Connessione al database
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)  # Usa 'dictionary=True' per restituire i risultati come dizionari

        # Esegui una query sulla tabella
        query = "SELECT * FROM operatori"  # Sostituisci con il nome della tua tabella
        cursor.execute(query)

        # Recupera i dati
        result = cursor.fetchall()

        # Chiudi la connessione
        cursor.close()
        connection.close()

        # Restituisci i dati in formato JSON
        return jsonify(result)

    except Exception as e:
        # Gestione degli errori
        print(f"Errore durante l'interrogazione del database: {e}")
        return jsonify({"error": "Si è verificato un errore nel recupero dei dati"}), 500



if __name__ == '__main__':
    app.run(debug=True)
