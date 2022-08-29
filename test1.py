import mysql.connector as conn

mydb = conn.connect(host="localhost", user="root", passwd="Arun@va_6isw@5#12345")
print(mydb)
cursor = mydb.cursor()

cursor.execute("SHOW DATABASES")

# cursor.execute("CREATE TABLE iNeuron.arunava(stu_id INT(10), stu_name VARCHAR(80), stu_email VARCHAR(100), stu_fees INT(10), stu_attendance INT(3))")

# to see all the databases
for i in cursor.fetchall():
    print(i)