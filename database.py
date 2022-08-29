# creating database

from connections import create_server_connection, create_database

user = "root"
pw = "Arun@va_6isw@5#12345"
host = "localhost"

connection = create_server_connection(host, user, pw)

query = "CREATE DATABASE Testing"
create_database(connection, query)