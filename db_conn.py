# creating database connection

from connections import create_server_connection, create_db_connection

user = "root"
pw = "Arun@va_6isw@5#12345"
host = "localhost"
db = "iNeuron"

serv_connection = create_server_connection(host, user, pw)
db_connection = create_db_connection(host, user, pw, db)