#!flask/bin/python
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/dibilingo/api/v1.0/connectionTest', methods=['GET'])
def index():
    return jsonify( {'status': 'OK' } )

if __name__ == '__main__':
    app.run(debug=True)