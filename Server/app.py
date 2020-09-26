#!flask/bin/python
from flask import Flask, jsonify, send_file, make_response
from os import path, listdir


app = Flask(__name__)
cards = []

@app.route('/')
def index():
    return "Only API-server"

@app.route('/dibilingo/api/v1.0/connectionTest', methods=['GET'])
def connectionTest():
    return jsonify( {'status': 'OK' } )


@app.route('/dibilingo/api/v1.0/image/<image>/')
def get_image(image):
    if image in cards:
        filename = image + ".png"
        if path.exists("img/{}".format(filename)):
            return send_file("img/{}".format(filename), mimetype='image/png', attachment_filename=filename)
        else:
            # must send default img
            return ""
    else:
        print("No {} in config.cards".format(image))
        return ""
        
@app.route('/dibilingo/api/v1.0/cardlist', methods=['GET'])
def get_cardlist():
    return jsonify({'cards': cards }) 

@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Not found'}), 404)

def updateCardList():
    for name in listdir("img"):
        if name.endswith(".png"):
            cards.append(name[0: -4])
    print(cards)

if __name__ == '__main__':
    updateCardList()
    app.run(host="0.0.0.0", port="5000", debug=True)