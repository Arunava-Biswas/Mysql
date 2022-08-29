# Creating functions for database connection and running queries
# We need to install the following library
# pip install mysql-connector-python

# importing the modules
from genericpath import exists
import mysql.connector as conn
from mysql.connector import Error
import logging as lg

logger = lg.getLogger(__name__)
logger.setLevel(lg.INFO)
formatter = lg.Formatter('%(asctime)s : %(levelname)s : %(name)s : %(message)s', '%d/%m/%Y %I:%M:%S %p')
file_handler = lg.FileHandler('F:\\Pycharm_python\\mysql_database\\server_log\\database.log')
file_handler.setFormatter(formatter)
logger.addHandler(file_handler)


# creating connection
def create_server_connection(host_name, user_name, user_pwd):
    connection = None
    try:
        connection = conn.connect(host=host_name, user=user_name, passwd=user_pwd)

        logger.info("MySQL Database connection is successful.")

    except Error as err:
        logger.error(f"Error is: {err}")

    else:
        return connection


# creating database
def create_database(connection, query):
    cursor = connection.cursor()

    try:
        cursor.execute(query)
        logger.info("Database created successfully")

    except Error as err:
        logger.error(f"Error is: {err}")


# Connecting to the database
def create_db_connection(host_name, user_name, user_password, db_name):
    connection = None
    try:
        connection = conn.connect(host=host_name, user=user_name, passwd=user_password, database=db_name)
        logger.info("Connected to the Database Successfully")

    except Error as err:
        logger.error(f"Error is: {err}")

    else:
        return connection


# Executing query
def execute_query(connection, query):
    cursor = connection.cursor()

    try:
        cursor.execute(query)
        connection.commit()
        logger.info("Query execution was successful")

    except Error as err:
        logger.error(f"Error is: {err}")


# Showing query results
def read_query(connection, query):
    cursor = connection.cursor()
    result = None

    try:
        cursor.execute(query)
        result = cursor.fetchall()
        logger.info("Query reading was successful")

    except Error as err:
        logger.error(f"Error: {err}")

    else:
        return result
