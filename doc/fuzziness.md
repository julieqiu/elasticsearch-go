# Fuzziness

A way to account for typos and misspellings

Levenshtein edit distance accounts for:

- Subsitutions of characters
- Insertions of characters
- Deletion of characters

All of the above have an edit distance of 1.

Fuzziness = willingness to tolerate typos.

AUTO:
0: 1-2 character strings
1: 3-5 character strings
2: anything else

```
curl -XGET 127.0.0.1:9200/movies/_search?pretty -d '
{
	"query": {
		"fuzzy": {
			"title": {"value": "intrsteller", "fuzziness": 2}
		}
	}
}
'
```

```
{
  "took" : 59,
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
    "max_score" : 1.5947597,
    "hits" : [
      {
        "_index" : "movies",
        "_type" : "_doc",
        "_id" : "109487",
        "_score" : 1.5947597,
        "_source" : {
          "id" : "109487",
          "title" : "Interstellar",
          "year" : 2014,
          "genre" : [
            "Sci-Fi",
            "IMAX"
          ]
        }
      }
    ]
  }
}
```
