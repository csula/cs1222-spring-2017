
## To import

Type

```bash
mongoimport --db name-of-db --collection name-of-collection --file restaurants.json
```

Note that `name-of-db` can be anything and `name-of-collection` can also be anything, but call it `restaurants` for now so that the commands from the tutorial below works by simply cut and paste.

We will do lab based on the tutorial found here on [docs.mongodb.com](https://docs.mongodb.com/getting-started/shell/introduction/)


-- Find restaurant with "tito" or "Tito" in its name:

```
db.restaurants.find( { "name" : {$regex : "[Tt]ito"} } );
```


### Addition MongoDB Exercises

To find restaurants with a score in the range 80 to 100.

```
db.restaurants.find({grades : { $elemMatch:{"score":{$gt : 80 , $lt :100}}}});
```


To display the fields `restaurant_id`, `name`, `borough` and `cuisine`.

```
db.restaurants.find({},{"restaurant_id" : 1,"name":1,"borough":1,"cuisine" :1});
```

Recall that the `find()` parameters are `find(filter [, projection])`

Find all the `White Castle` restaurants in `Queens`
