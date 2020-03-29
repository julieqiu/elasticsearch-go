# Search

## Queries and filters

- Filters: ask a yes/no question of your data
  - Use when you can b/c they are very efficient: fast and cacheable
- Queries: return data in terms of relevance

```
curl -XGET 127.0.0.1:9200/movies/_search?pretty-d '
{
  "query": {
     "bool": {
       "must": {"term": {"title": "trek"}},
       "filter": {"range": {"year": {"gte": 2010}}}
     }
  }
}'
```

- queries are wrapped in a "query": {} block
- filters are wrapped in a "filter": {} block
- you can combine filters inside queries, or queries inside filters too

## Types of filters

1. term: filter by exact values
  `{"term": {"year": 2014} }`

2. terms: match if any exact values in a list match
  `{"terms": { "genre": ["Sci-Fi", "Adventure"] } }`

3. range: find numbers or dates in a given range (gt, gte, lt, lte)
  `{"range": {"year": ["gte": 2010]} }`

4. exists: find documents where a field exists
  `{"exists": {"field": "tags" } }`

5. missing: find doucments where a field is missing
 `{"missing": {"field": "tags" } }`

6. bool: combine filters with boolean logic (must, must_not, should)

## Types of queries

1. match_all: returns all documents and is the default. normally used within a filter
  `{ "match_all": {}}`

2. match: searches analyzed results, such as full text search
  `{ "match": { "title": "star" }}`

3. multi_match: run the same query on multiple fields
  `{ "multi_match": { "query": "star", "fields": ["title": "synopsis" ] }}`

4. bool: works like a bool filter, but results are scored by relevance

## Phrase Matching

1. must find all terms, in the right order

```
curl -XGET 127.0.0.1:9200/movies/_search?pretty -d '
{
  "query": {
    "match_phrase": {
      "title": {
        "query": "star beyond",
        "slop": 1
      }
    }
  }
}'
```

2. slop: use  `slop` to represent how far you're willing to let a term move to satisfy a phrase (in either direction)
3. proximity queries: use slop to get any documents that contain the words in your phrase, but want documents that have the words closer together scored higher (set slop = 100). B/c results are sorted by relevance.

## Pagination

- use `size` & `from`
- deep pagination can kill performance
  - every result must be retrieved, collected, and sorted
  - enforce an upper bound on how many results you'll return to users


## Sorting

- use `sort=<field>`
- strings cannot be used to sort documents
  - bc exists in the inverted index as individual terms, not as the entire string
  - need to map a keyword copy

```
curl -XGET '127.0.0.1:9200/movies/_search?sort=title.raw&pretty'

{
	"mappings": {
		"properties": {
			"title": {
				"type": "text",
				"fields": {
					"raw": {
						"type": "keyword"
					}
				}
			}
		}
	}
}

```

Things you can't changed: field types & # of shards


## More with filters

```
curl -XGET '127.0.0.1:9200/movies/_search?pretty -d
'{
   "query":{
      "bool":{
         "must":{
            "match":{
               "genre":"Sci-Fi"
            }
         },
         "must_not":{
            "match":{
               "title":"trek"
            }
         },
         "filter":{
            "range":{
               "year":{
                  "gte":2010,
                  "lt":2015
               }
            }
         }
      }
   }
}
'
```
