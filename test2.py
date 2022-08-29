# creating a database

import mysql.connector as conn

# creating connection to the database
mydb = conn.connect(host="localhost", user="root", passwd="Arun@va_6isw@5#12345")
# creating cursor
cursor = mydb.cursor()
# creating the database query
q1 = "CREATE DATABASE iNeuron"
# cursor.execute(q1)

cursor.execute("SHOW DATABASES")
for i in cursor.fetchall():
    print(i)