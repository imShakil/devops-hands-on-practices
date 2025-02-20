from flask import Flask
from flask_mysql import MySQL
from dotenv import dotenv


app = Flask(__name__)

app.config('MYSQL_HOST') = {MYSQL_HOST}
app.config('MYSQL_USER') = {MYSQL_USER}
app.config('MYSQL_PASSWORD') = {MYSQL_PASSWORD}
app.config('MYSQL_DB') = {MYSQL_DB}

@app.route('/')
def hello_world():
    return 'Hello, World!'

@app.route('/redis-test')
def redis_test():
    return 'Redis test'

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=3000)
