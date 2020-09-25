#!flask/bin/python
from flask import Flask, jsonify, send_file, make_response
import os.path
import config 

app = Flask(__name__)

@app.route('/')
def index():
    return "Only API-server"

@app.route('/dibilingo/api/v1.0/connectionTest', methods=['GET'])
def connectionTest():
    return jsonify( {'status': 'OK' } )


@app.route('/dibilingo/api/v1.0/image/<image>/')
def get_image(image):
    if image in config.cards:
        filename = image + ".jpg"
        if os.path.exists("img/{}".format(filename)):
            return send_file("img/{}".format(filename), mimetype='image/jpg', attachment_filename=filename)
        else:
            # must send default img
            return ""
    else:
        print("No {} in config.cards".format(image))
        return ""
        
@app.route('/dibilingo/api/v1.0/cardlist', methods=['GET'])
def get_cardlist():
    return jsonify({'cards': config.cards })

@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Not found'}), 404)

if __name__ == '__main__':
    app.run(debug=True)