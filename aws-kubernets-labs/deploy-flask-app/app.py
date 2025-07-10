from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify(message="Hello World, this is a Flask app running on AWS! Say hello by visiting /hello/<name>")

@app.route('/hello/<name>')
def hello(name):
    return jsonify(message="Hello, {}!".format(name))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
