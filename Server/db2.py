from pymongo import MongoClient

# Create the client
client = MongoClient('localhost', 27017)

db = client["MyDB"]

collection = db["MyColl"]

import datetime
post = {"author": "Mike",
         "text": "My first blog post!",
         "tags": ["mongodb", "python", "pymongo"],
         "date": datetime.datetime.utcnow()}

post_id = collection.insert_one(post).inserted_id
print(post_id)

import pprint
from bson.objectid import ObjectId
pprint.pprint( collection.find_one({ "_id": ObjectId("5f6da3e604f50547f89e3b5c") }) )