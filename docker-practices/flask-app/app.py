from flask import Flask, jsonify, request
from flask_cors import CORS, cross_origin
import db
import pymysql

app = Flask(__name__)
cors = CORS(app)

@app.route('/')
def helloWorld():
  return "Hello, cross-origin-world!"

# Route to get all tasks
@app.route('/tasks', methods=['GET'])
def get_tasks():
    cur = db.get_db().cursor()
    cur.execute('SELECT * FROM tasks')
    tasks = cur.fetchall()
    cur.close()
    return jsonify({'tasks': tasks})

# Route to get a specific task by id
@app.route('/tasks/<int:task_id>', methods=['GET'])
def get_task(task_id):
    cur = db.get_db().cursor()
    cur.execute('SELECT * FROM tasks WHERE id = %s', (task_id,))
    task = cur.fetchone()
    cur.close()
    if not task:
        return jsonify({'error': 'Task not found'}), 404
    return jsonify({'task': task})

# Route to create a new task
@app.route('/tasks', methods=['POST'])
def create_task():
    title = request.json.get('title', '')
    description = request.json.get('description', '')
    cur = db.get_db().cursor()
    cur.execute('INSERT INTO tasks (title, description) VALUES (%s, %s)', (title, description))
    db.get_db().commit()
    task_id = cur.lastrowid
    cur.close()
    return jsonify({'task_id': task_id}), 201

if __name__ == '__main__':
    app.run(debug=True)
