import pymysql

host = 'localhost'
user = 'admin'
password = 'abc@123'
db = 'mysqlDB'


def get_db():
    return pymysql.connect(
        host=host,
        user=user,
        password=password,
        database=db,
        charset='utf8'
    )        
