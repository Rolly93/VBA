import os
import bcrypt
import sqlite3
import getpass



def setup_database(db_name='XMLScript//proyect//db//transportapp.db'):
    """
    Creates an SQLite database and an 'sftp_configs' table if it doesn't exist.

    Args:
        db_name (str): The name of the database file.
    """
    conn = None
    try:
        # Connect to the database. This will create the file if it doesn't exist.
        print(f"Connecting to database: {db_name}")
        conn = sqlite3.connect(db_name)
        cursor = conn.cursor()

        # Define the table creation statement.
        # The "IF NOT EXISTS" clause is crucial as it prevents errors if the table already exists.
        create_table_sql = """
        CREATE TABLE IF NOT EXISTS sftp_configs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            sftp_user TEXT NOT NULL,
            sftp_password TEXT,
            sftp_host TEXT NOT NULL,
            remote_directory TEXT NOT NULL,
            sftp_port INTEGER);
        """

        # Execute the SQL statement to create the table
        cursor.execute(create_table_sql)
        conn.commit()
        print("Table 'sftp_configs' created or already exists.")

    except sqlite3.Error as e:
        print(f"SQLite error: {e}")
    finally:
        # condicion para poder cerrar la base de datos si o si
        if conn:
            conn.close()
            print("Connection to database closed.")

def add_sftp_config(host, user, port, password, remote_dir, db_name='XMLScript//proyect//db//transportapp.db'):
    """
    Hashes the password and adds a new SFTP configuration to the database.

    Args:
        host (str): SFTP host address.
        user (str): SFTP username.
        port (int): SFTP port number.
        password (str): The plaintext password to be hashed.
        remote_dir (str): The remote directory path.
        db_name (str): The name of the database file.
    """
    conn = None
    if not port:
        port = 22
    
    try:

        conn = sqlite3.connect(db_name)
        cursor = conn.cursor()

        # SQL statement to insert data
        insert_sql = """
        INSERT INTO sftp_configs (sftp_user, sftp_password, sftp_host, remote_directory,sftp_port)
        VALUES (?, ?, ?, ?, ?);
        """
        
        # Execute the SQL statement with the hashed password
        cursor.execute(insert_sql, (user,password,host,remote_dir,port))
        conn.commit()
        print(f"Configuration for user '{user}' added successfully.")
        
    except sqlite3.Error as e:
        print(f"SQLite error: {e}")
    finally:
        if conn:
            conn.close()
def get_sftp_config_connect(username,db_name = 'XMLScript//proyect//db//transportapp.db'):

        conn = None
        print(f"Username: {username}")
        data=[]
        try:
            conn = sqlite3.connect(db_name)
            
            conn.row_factory = sqlite3.Row
            Cursor = conn.cursor()
            
            #Extraer la informacion del base de datos
            
            Cursor.execute("SELECT * FROM sftp_configs WHERE sftp_user = ?;", (username,))
            print(Cursor)
            config = Cursor.fetchone()
            print(config,"from database")
            if config:
                data = dict(config)
                
                print(f"Attempting to connect to SFTP as User: {username}")
                
                
        
        except Exception as e:
            print ("something went wrong:" , e)
            
        finally:
            if conn:
                conn.close()
                return data
                
    
