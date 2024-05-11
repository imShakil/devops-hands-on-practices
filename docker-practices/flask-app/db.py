from flask import current_app, g
import mysql.connector

db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'abCD#123',
    'database': 'mydb',
    'port': '3306'
}

def getdb():
    if 'db' not in g or not g.db.is_connected():
        g.db = mysql.connector.connect(**db_config)
    return g.db

def setup_db():
    cnx = getdb()
    cur = cnx.cursor()
    with open('./schema.sql', 'r') as f:
        commands = f.read().split(';')
        for command in commands:
            try:
               if command.strip() != '':
                    cur.execute(command)
                    cnx.commit()
            except IOError as e:
                print("Command skipped: ", e)
    cnx.close()

def close_db(e=None):
    db = g.pop('db', None)

    if db is not None:
        db.close()

def fmt_json(data):
    jsonObj = []
    for task in data:
        jsonObj.append(
            {
            'id': task[0],
            'title': task[1],
            'description': task[2]
            })
    return jsonObj
    

