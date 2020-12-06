#!flask/bin/python
from flask import Flask, jsonify, send_file, make_response, request
import json

from pymongo import MongoClient
from bson.objectid import ObjectId

from os import path, listdir
import checksumdir
import pprint
from datetime import datetime, timezone

imgPath = "data/img/"
app = Flask(__name__)
cards = []
dataHash = ""

client = MongoClient('localhost', 27017)
db = client["Dibilingo"]
collection = db["users"]

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
        if path.exists(imgPath + filename):
            return send_file(imgPath + filename, mimetype='image/png', attachment_filename=filename)
        else:
            # must send default img
            return ""
    else:
        print("No {} in config.cards".format(image))
        return ""
        
@app.route('/dibilingo/api/v1.0/cardlist', methods=['GET'])
def get_cardlist():
    return jsonify({'cards': cards }) 

@app.route('/dibilingo/api/v1.0/verbs', methods=['GET'])
def get_verbs():
    return send_file("data/irregVerb.json", mimetype="application/json", attachment_filename="rregVerb.json")

@app.route('/dibilingo/api/v1.0/datahash', methods=['GET'])
def get_datahash():
    return jsonify({'dataHash': dataHash }) 

@app.route('/dibilingo/api/v1.0/login/<name>/')
def login(name):
    user = collection.find_one({ "name": name }) 

    userID = ObjectId()
    if user == None:
        lastUpdatedTime = datetime.now(timezone.utc)
        newUser = {
            "lastUpdated": lastUpdatedTime.strftime("%Y-%m-%dT%H:%M:%S%z"), 
            "name": name,
            "coins": 0,
            "coinsInCategories": {"level1":0} #json.dumps([[]])
            }
        userID = collection.insert_one(newUser).inserted_id
        user = collection.find_one({ "name": name }) 
    else:
        userID = user["_id"]

    callback = { 
        "id": str(userID),
        "lastUpdated": user["lastUpdated"],
        "name": name,
        "coins": int( user["coins"] ),                 
        "coinsInCategories": user["coinsInCategories"] 
        }
    print(callback)
    return jsonify(callback)

@app.route('/dibilingo/api/v1.0/userupdate/', methods=['GET', 'POST'])
def userupdate():
    up_client = request.json
    userID = ObjectId(up_client["id"])
    up_db = collection.find_one({ "_id": userID })

    date_client = datetime.strptime(up_client["lastUpdated"], "%Y-%m-%dT%H:%M:%S%z") 
    date_db = datetime.strptime(up_db["lastUpdated"], "%Y-%m-%dT%H:%M:%S%z") 

    callback = ""
    if date_client > date_db:
        result = collection.update_one({
            '_id': userID
        }, {
            '$set': {
             'coins': int(up_client['coins']),
             'coinsInCategories': up_client["coinsInCategories"]
        }
        }, upsert=False)
        print("Updated count: {}".format(result.modified_count))
        callback = "updated"
    else:
        callback = "no_update"

    return jsonify({"result":callback})

@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Not found'}), 404)

def updateCardList():
    for name in listdir(imgPath):
        if name.endswith(".png"):
            cards.append(name[0: -4])
    print(cards)

if __name__ == '__main__':
    updateCardList()
    dataHash = checksumdir.dirhash("data/")
    print("DataHash: {}".format(dataHash))
    app.run(host="0.0.0.0", port="5000", debug=True)