from pymongo import MongoClient

# Create the client
client = MongoClient('localhost', 27017)

db = client["Dibilingo"]

collection = db["users"]

import datetime
post = {"name": "Mike"}

post_id = collection.insert_one(post).inserted_id
print(post_id)

import pprint
from bson.objectid import ObjectId
pprint.pprint( collection.find_one({ "_id": ObjectId("5f6da3e604f50547f89e3b5c") }) )