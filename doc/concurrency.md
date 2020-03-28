# Concurrency

## Optimistic concurrency control

Unique chronological record for each document based on:
- Sequence number
- Primary term

These can be specified explicitly in updates.

Use `retry_on_conflicts=N` to automatically retry.


```
curl -XGET 127.0.0.1:9200/movies/_doc/109487\?pretty
{
  "_index" : "movies",
  "_type" : "_doc",
  "_id" : "109487",
  "_version" : 3,
  "_seq_no" : 6,  # <-- Sequenece number
  "_primary_term" : 1, # <-- Primary term
  "found" : true,
  "_source" : {
    "genres" : [
      "IMAX",
      "Sci-Fi"
    ],
    "title" : "Interstellar foo",
    "year" : 2014
  }
}``

Use synthax:

- First update will work

```

 ./curl_json.sh -XPUT "127.0.0.1:9200/movies/_doc/109487?if_seq_no=6&if_primary_term=1" -d '{
        "genres": ["IMAX", "Sci-Foo"],
        "title": "Interstellar bar",
        "year": 2014
}'

{"_index":"movies","_type":"_doc","_id":"109487","_version":4,"result":"updated","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":8,"_primary_term":1}%
```


Next one will not:

 - Need to update sequence number

```
./curl_json.sh -XPUT "127.0.0.1:9200/movies/_doc/109487?if_seq_no=6&if_primary_term=1" -d '{
        "genres": ["IMAX", "Sci-Foo"],
        "title": "Interstellar bar",
        "year": 2014
}'

{"error":{"root_cause":[{"type":"version_conflict_engine_exception","reason":"[109487]: version conflict, required seqNo [6], primary term [1]. current document has seqNo [8] and primary term [1]","index_uuid":"kjpbvjNoTUevrffFY3RrKg","shard":"0","index":"movies"}],"type":"version_conflict_engine_exception","reason":"[109487]: version conflict, required seqNo [6], primary term [1]. current document has seqNo [8] and primary term [1]","index_uuid":"kjpbvjNoTUevrffFY3RrKg","shard":"0","index":"movies"},"status":409}%
```

Retrying automatically:

```
./curl_json.sh -XPOST "127.0.0.1:9200/movies/_doc/109487/_update?retry_on_conflict=5" -d '
{
"doc": { "title": "Interstellar again" } }'
{"_index":"movies","_type":"_doc","_id":"109487","_version":5,"result":"updated","_shards":{"total":2,"successful":1,"failed":0},"_seq_no":9,"_primary_term":1}%
```
