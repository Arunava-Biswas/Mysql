# inserting data

import mysql.connector as conn

mydb = conn.connect(host="localhost", user="root", passwd="Arun@va_6isw@5#12345")
cursor = mydb.cursor()
# query to insert data
q1 = "INSERT INTO iNeuron.arunava VALUES(101, 'Arunava Biswas', 'arunavabiswas@email.com', 17000, 26)"
cursor.execute(q1)
mydb.commit()

# query to read data from the table
q2 = "SELECT * FROM iNeuron.arunava"
cursor.execute(q2)
for i in cursor.fetchall():
    print(i)