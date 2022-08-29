# Reading data from the database

from connections import create_server_connection, create_db_connection, read_query

host = "localhost"
user = "root"
pw = "Arun@va_6isw@5#12345"
db = "ineuron"

serv_connection = create_server_connection(host, user, pw)
db_connection = create_db_connection(host, user, pw, db)

# q = "SELECT * FROM arunava"
q = "SHOW DATABASES"

results = read_query(db_connection, q)

for result in results:
    print(result)