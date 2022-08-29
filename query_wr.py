# Uploading data to the Database

from connections import create_server_connection, create_db_connection, execute_query

host = "localhost"
user = "root"
pw = "Arun@va_6isw@5#12345"
db = "ineuron"

serv_connection = create_server_connection(host, user, pw)
db_connection = create_db_connection(host, user, pw, db)

# q = "INSERT INTO arunava VALUES(102, 'Test User', 'test_user@email.com', 15600, 24)"
q = "CREATE TABLE new_table(stu_id INT(10), stu_name VARCHAR(80), stu_email VARCHAR(100), stu_fees INT(10), stu_attendance INT(3))"
execute_query(db_connection, q)