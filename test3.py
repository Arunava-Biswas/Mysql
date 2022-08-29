# creating a table

import mysql.connector as conn

# creating connection to the database
mydb = conn.connect(host="localhost", user="root", passwd="Arun@va_6isw@5#12345")
# creating cursor
cursor = mydb.cursor()

# creating a table
q1 = "CREATE TABLE iNeuron.arunava(stu_id INT(10), stu_name VARCHAR(80), stu_email VARCHAR(100), stu_fees INT(10), stu_attendance INT(3))"
cursor.execute(q1)


