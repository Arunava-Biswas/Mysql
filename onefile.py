# Using the class

from connections import create_server_connection, create_database, create_db_connection, execute_query, read_query

# "root"
# "Arun@va_6isw@5#12345"
# "Testing"

host = "localhost"
user = input("Enter user name: ")
pw = input("Enter the password: ")


# create server connection
connection = create_server_connection(host, user, pw)

# create database
query = "CREATE DATABASE IF NOT EXISTS Testing"
create_database(connection, query)

db = input("Enter the database name: ")

# create database connection
db_connection = create_db_connection(host, user, pw, db)


# writing query to the database
q1 = "CREATE TABLE IF NOT EXISTS new_table(stu_id INT(10), stu_name VARCHAR(80), stu_email VARCHAR(100), stu_fees INT(10), stu_attendance INT(3))"
execute_query(db_connection, q1)

# single data insertion
q2 = "INSERT INTO new_table VALUES(101, 'Test User1', 'test_user1@email.com', 15600, 24)"
# execute_query(db_connection, q2)

# multiple data insertion
q3 = """INSERT INTO new_table 
        VALUES 
            (102, 'Test User2', 'test_user2@email.com', 13200, 27), 
            (103, 'Test User3', 'test_user3@email.com', 14600, 22), 
            (104, 'Test User4', 'test_user4@email.com', 16700, 25), 
            (105, 'Test User5', 'test_user5@email.com', 17800, 21), 
            (106, 'Test User6', 'test_user6@email.com', 14300, 24), 
            (107, 'Test User7', 'test_user7@email.com', 16500, 26)"""
# execute_query(db_connection, q3)


# reading the inserted data
print("\nReading data: \n")
q4 = "SELECT * FROM new_table"

results = read_query(db_connection, q4)

for result in results:
    print(result)