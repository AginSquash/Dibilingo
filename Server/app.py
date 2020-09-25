#!flask/bin/python
from flask import Flask, jsonify, send_file

app = Flask(__name__)

@app.route('/')
def index():
    return "Only API-server"

@app.route('/dibilingo/api/v1.0/connectionTest', methods=['GET'])
def connectionTest():
    return jsonify( {'status': 'OK' } )


@app.route('/get_image')
def get_image():
    return send_file("img/pic.jpeg", mimetype='image/jpeg', attachment_filename="pic.jpeg")

if __name__ == '__main__':
    app.run(debug=True)