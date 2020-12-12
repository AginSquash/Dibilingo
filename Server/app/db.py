from peewee import MySQLDatabase, Model
from peewee import IntegerField, FloatField, CharField, PrimaryKeyField, TimestampField, fn
from peewee import InternalError
import pymysql

db = MySQLDatabase(
    'cards', user="root", password="//pass here//", host="localhost"
)

class Cards(Model):
    id = PrimaryKeyField(unique=True, null=False)
    image_name = CharField()
    object_name = CharField()
    real_name = CharField()

    class Meta:
        db_table = 'cards'
        database = db

try:
    db.connect()
    Cards.create_table()
    Cards.create(
        image_name = "fox.png",
        object_name = "fox",
        real_name = "fox"
    )
except InternalError as px:
    print(str(px))

random = Cards.select().order_by(fn.Rand()).limit(2)

for c in random:
    print(c.image_name)