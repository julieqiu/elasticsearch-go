# Deleting Documents

## Find the document ID

```
./curl_json.sh -XGET 127.0.0.1:9200/movies/_search\?q=Dark
{"took":2,"timed_out":false,"_shards":{"total":1,"successful":1,"skipped":0,"failed":0},"hits":{"total":{"value":1,"relation":"eq"},"max_score":1.5442266,"hits":[{"_index":"movies","_type":"_doc","_id":"58559","_score":1.5442266,"_source":{ "id": "58559", "title" : "Dark Knight, The", "year":2008 , "genre":["Action", "Crime", "Drama", "IMAX"] }}]}}
```


## Delete by ID

```
curl -XDELETE 127.0.0.1:9200/movies/_doc/58559\?pretty
{
  "_index" : "movies",
  "_type" : "_doc",
  "_id" : "58559",
  "_version" : 2,
  "result" : "deleted",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 7,
  "_primary_term" : 1
}
```

## Look for it again

Nothing will show up.
```
./curl_json.sh -XGET 127.0.0.1:9200/movies/_search\?q=Dark
{"took":2,"timed_out":false,"_shards":{"total":1,"successful":1,"skipped":0,"failed":0},"hits":{"total":{"value":0,"relation":"eq"},"max_score":null,"hits":[]}}%
```

## Deleting the Index

```
curl -XDELETE 127.0.0.1:9200/movies
{"acknowledged":true}%
```
