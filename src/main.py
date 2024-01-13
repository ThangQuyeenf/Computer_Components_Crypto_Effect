from connection import SQLServerConnection
from DataLoader import DataLoader
from dotenv import load_dotenv
# from util import Logger
import os
import pandas as pd
import logging
logging.basicConfig(filename='log.log', level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logging.basicConfig(filename='log.log', level=logging.ERROR, format='%(asctime)s - %(levelname)s - %(message)s')

WORK_DIR = os.path.dirname(os.path.dirname(__file__))
DATA_DIR = os.path.join(WORK_DIR, 'data')
SCRIPTS_DIR = os.path.join(WORK_DIR, 'scripts')

def create_new_database(sql_server, db_name):
    query = f"CREATE DATABASE {db_name}"
    sql_server.execute_commit(query)
    print(f"Database '{db_name}' created successfully.")
    logging.info(f"Database '{db_name}' created successfully.")

def load_config():
    load_dotenv()
    server_name = os.getenv('SERVER_NAME')
    database =  os.getenv('DATABASE_NAME') if os.getenv('DATABASE_NAME') else 'master'
    username = os.getenv('USER_NAME')
    password = os.getenv('PASSWORD')
    return server_name, database, username, password

def load_data(file_path):   
    data_loader = DataLoader()
    data = data_loader.load_data(file_path=file_path)
    columns = data_loader.extract_dtypes(data)
    return data, columns

def implement_database(sql_server: SQLServerConnection): 
    files = os.listdir(DATA_DIR)
    try:
        for file in files:
            filename = file.split('.')[0]
            file_path = os.path.join(DATA_DIR, file)
            data, columns = load_data(file_path)
            sql_server.create_table(table_name=filename, columns=columns)
            sql_server.insert_data(table_name=filename, data_file=file_path)
        print('Implement Database Successfully')
        logging.info('Implement Database Successfully')
    except Exception as e:
        print(f"Error: {e}")
        logging.error(e)

def connect_db(server_name, database, username, password):
    target_db = None
    try: 
        sql_server = SQLServerConnection(server_name, database, username, password)
        sql_server.connect()
    except Exception as e:
        print(f"Error: {e}")
        logging.error(e)
        target_db = database
        database = 'master'
        sql_server = SQLServerConnection(server_name, database, username, password)
        sql_server.connect()
        print(f"Create a new database: {target_db}")
        logging.info(f"Create a new database: {target_db}")
        create_new_database(sql_server, target_db)
    finally: 
        if target_db is not None:
            print(f"Reconnect to new Database {target_db}")
            logging.info(f"Reconnect to new Database {target_db}")
            sql_server = SQLServerConnection(server_name, target_db, username, password)
            sql_server.connect()
        return sql_server
    
    
def main():
    server_name, database, username, password = load_config()
    sql_server = connect_db(server_name, database, username, password)
    implement_database(sql_server)

def generate_insert_sql(data: pd.DataFrame, table_name):
    with open(os.path.join(SCRIPTS_DIR,f'{table_name}.sql'), 'w') as file:
        file.write("USE [Computer_Components]\n")
        for row in data.itertuples():
            script = f"""SET ANSI_NULLS ON\nGO\nSET QUOTED_IDENTIFIER ON\nGO\nINSERT INTO {table_name} ({', '.join(data.columns)})\nVALUES ({', '.join((str(val) if val is not None else 'NULL' for val in row))})\nGO\n"""
            file.write(script)
                
        

if __name__ == "__main__":
    # main()
    files = os.listdir(DATA_DIR)
    for file in files:
        filename = file.split('.')[0]
        file_path = os.path.join(DATA_DIR, file)
        # print(file_path)
        data, columns = load_data(file_path)
        data = data.head(20)
        generate_insert_sql(data, filename)