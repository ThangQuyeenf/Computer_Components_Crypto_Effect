import pyodbc
import logging
logging.basicConfig(filename='log.log', level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logging.basicConfig(filename='log.log', level=logging.ERROR, format='%(asctime)s - %(levelname)s - %(message)s')

class SQLServerConnection:
    def __init__(self, server, database, username, password, driver='ODBC Driver 17 for SQL Server'):
        self.server = server
        self.database = database
        self.username = username
        self.password = password
        self.driver = driver
        self.logger = logging.getLogger(__name__)
        self.connection = None
        self.cursor = None
        
    def connect(self):
        connection_string = f'DRIVER={self.driver};SERVER={self.server};DATABASE={self.database};UID={self.username};PWD={self.password}'
        # self.cursor = self.connection.cursor()
        self.connection = pyodbc.connect(connection_string)
        self.cursor = self.connection.cursor()
        self.logger.info("connect successfully")
        print("connect successfully")
    
    def execute_query(self, query):
        self.cursor.execute(query)
        rows = self.cursor.fetchall()
        return rows

    def execute_commit(self, query):
        self.connection.autocommit = True
        self.cursor.execute(query)
        self.connection.commit()

    def table_exists(self, table_name):
        query = f"IF OBJECT_ID('{table_name}', 'U') IS NOT NULL SELECT 'Table Exists' ELSE SELECT 'Table Does Not Exist'"

        
        self.cursor.execute(query)
        result = self.cursor.fetchone()

        return result[0] == 'Table Exists'
    
    def create_table(self, table_name, columns):
        try:
            if self.table_exists(table_name):
                print(f"Table {table_name} already exist")
                self.logger.info(f"Table {table_name} already exist")
                return
            else:
                create_table_query = f"""CREATE TABLE {table_name} (
                    {', '.join(f'{key} {value}' for key, value in columns.items())}
                )"""
                print(create_table_query)
                self.execute_commit(create_table_query)
                print(f"Table '{table_name}' created successfully.")
                self.logger.info(f"Table '{table_name}' created successfully.")
        except Exception as e:
            print(f"Error: {e}")
            self.logger.error(e)

    def bulk_insert(self, data_file, table_name):
        sql = f"""
            BULK INSERT {table_name}
            FROM '{data_file}'
            WITH
            (
                FORMAT='CSV',
                FIRSTROW=2,
                FIELDTERMINATOR=',',
                ROWTERMINATOR='0x0a'
            )
        """.strip()
        return sql
    
    def insert_data(self, table_name, data_file):
        try:
            if data_file.endswith('.csv'):
                sql = self.bulk_insert(data_file, table_name)
                self.execute_commit(sql)
            print(f"Data inserted into table '{table_name}'.")
            self.logger.info(f"Data inserted into table '{table_name}'.")
        except Exception as e:
            print(f"Error: {e}")
            self.logger.error(e)

    def close_connection(self):
        if self.connection:
            self.connection.close()
