# Inserts & Updates

1. Set year field to type=date
 ./curl_json.sh -XPUT 127.0.0.1:9200/movies -d '
quote> {
quote>  "mappings": {
quote>          "properties": {
quote>                  "year": { "type": "date" }
quote>          }
quote>  }
quote> }'
{"acknowledged":true,"shards_acknowledged":true,"index":"movies"}%


2.  Looking at mapping:

```
./curl_json.sh -XGET 127.0.0.1:9200/movies/_mapping
```

3. Insert a record:

```
./curl_json.sh -XPUT 127.0.0.1:9200/movies/_doc/109487 -d '{
        "genre": ["IMAX", "Sci-Fi"],
        "title": "Intersetller",
        "year": 2014
}'

{"_index":"movies","_type":"_doc","_id":"109487","_version":1,"result":"created","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":0,"_primary_term":1}%
```

4. Look at the results:

```
./curl_json.sh -XGET 127.0.0.1:9200/movies/_search\?pretty
{
  "took" : 3,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 1,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "movies",
        "_type" : "_doc",
        "_id" : "109487",
        "_score" : 1.0,
        "_source" : {
          "genre" : [
            "IMAX",
            "Sci-Fi"
          ],
          "title" : "Intersetller",
          "year" : 2014
        }
      }
    ]
  }
}
```

## Bulk Insert

- Format is a JSON stream so that Elasticsearch can process each line and hash
  each document to a shard

```
 ./curl_json.sh -XPUT 127.0.0.1:9200/_bulk\?pretty --data-binary @movies.json
{
  "took" : 53,
  "errors" : true,
  "items" : [
    {
      "create" : {
        "_index" : "movies",
        "_type" : "_doc",
        "_id" : "135569",
        "_version" : 1,
        "result" : "created",
        "_shards" : {
          "total" : 2,
          "successful" : 1,
          "failed" : 0
        },
        "_seq_no" : 1,
        "_primary_term" : 1,
        "status" : 201
      }
    },
    {
      "create" : {
        "_index" : "movies",
        "_type" : "_doc",
        "_id" : "122886",
        "_version" : 1,
        "result" : "created",
        "_shards" : {
          "total" : 2,
          "successful" : 1,
          "failed" : 0
        },
        "_seq_no" : 2,
        "_primary_term" : 1,
        "status" : 201
      }
    },
    {
      "create" : {
        "_index" : "movies",
        "_type" : "_doc",
        "_id" : "109487",
        "status" : 409,
        "error" : {
          "type" : "version_conflict_engine_exception",
          "reason" : "[109487]: version conflict, document already exists (current version [1])",
          "index_uuid" : "kjpbvjNoTUevrffFY3RrKg",
          "shard" : "0",
          "index" : "movies"
        }
      }
    },
    {
      "create" : {
        "_index" : "movies",
        "_type" : "_doc",
        "_id" : "58559",
        "_version" : 1,
        "result" : "created",
        "_shards" : {
          "total" : 2,
          "successful" : 1,
          "failed" : 0
        },
        "_seq_no" : 3,
        "_primary_term" : 1,
        "status" : 201
      }
    },
    {
      "create" : {
        "_index" : "movies",
        "_type" : "_doc",
        "_id" : "1924",
        "_version" : 1,
        "result" : "created",
        "_shards" : {
          "total" : 2,
          "successful" : 1,
          "failed" : 0
        },
        "_seq_no" : 4,
        "_primary_term" : 1,
        "status" : 201
      }
    }
  ]
}
```

### Search

```
 ./curl_json.sh -XGET 127.0.0.1:9200/movies/_search\?pretty
{
  "took" : 1017,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 5,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "movies",
        "_type" : "_doc",
        "_id" : "109487",
        "_score" : 1.0,
        "_source" : {
          "genre" : [
            "IMAX",
            "Sci-Fi"
          ],
          "title" : "Intersetller",
          "year" : 2014
        }
      },
      {
        "_index" : "movies",
        "_type" : "_doc",
        "_id" : "135569",
        "_score" : 1.0,
        "_source" : {
          "id" : "135569",
          "title" : "Star Trek Beyond",
          "year" : 2016,
          "genre" : [
            "Action",
            "Adventure",
            "Sci-Fi"
          ]
        }
      },
      {
        "_index" : "movies",
        "_type" : "_doc",
        "_id" : "122886",
        "_score" : 1.0,
        "_source" : {
          "id" : "122886",
          "title" : "Star Wars: Episode VII - The Force Awakens",
          "year" : 2015,
          "genre" : [
            "Action",
            "Adventure",
            "Fantasy",
            "Sci-Fi",
            "IMAX"
          ]
        }
      },
      {
        "_index" : "movies",
        "_type" : "_doc",
        "_id" : "58559",
        "_score" : 1.0,
        "_source" : {
          "id" : "58559",
          "title" : "Dark Knight, The",
          "year" : 2008,
          "genre" : [
            "Action",
            "Crime",
            "Drama",
            "IMAX"
          ]
        }
      },
      {
        "_index" : "movies",
        "_type" : "_doc",
        "_id" : "1924",
        "_score" : 1.0,
        "_source" : {
          "id" : "1924",
          "title" : "Plan 9 from Outer Space",
          "year" : 1959,
          "genre" : [
            "Horror",
            "Sci-Fi"
          ]
        }
      }
    ]
  }
}
```

## Updating Documents

- Every document has _version field
- Elasticsearch documents are immutable
- When you update an existing document:
  - a new document is created with an incremented_version
  - the old document is marked for deletion


### Partial Document
```
./curl_json.sh -XPOST 127.0.0.1:9200/movies/_doc/109487/_update -d '
{
        "doc": {
                "title": "Intersellar"
        }
}'
{"_index":"movies","_type":"_doc","_id":"109487","_version":2,"result":"updated","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":5,"_primary_term":1}%
```

### Full Update

```
./curl_json.sh -XPUT 127.0.0.1:9200/movies/_doc/109487\?pretty -d '
{

        "genres": ["IMAX", "Sci-Fi"],
        "title": "Interstellar foo",
        "year": 2014
}'

{
  "_index" : "movies",
  "_type" : "_doc",
  "_id" : "109487",
  "_version" : 3,
  "result" : "updated",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 6,
  "_primary_term" : 1
}
```
```
 ./curl_json.sh -XGET 127.0.0.1:9200/movies/_doc/109487\?pretty
{
  "_index" : "movies",
  "_type" : "_doc",
  "_id" : "109487",
  "_version" : 3,
  "_seq_no" : 6,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "genres" : [
      "IMAX",
      "Sci-Fi"
    ],
    "title" : "Interstellar foo",
    "year" : 2014
  }
}
```
