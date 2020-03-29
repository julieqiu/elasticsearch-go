# Data Modeling

## Normalizing vs Denormalizing

Normalized data:

- Minimizes storage space
- Makes it easy to change titles
- Requires two queries, and storage is cheap!
- Look up movie - get all ratings

Denormalized data:

- Look up rating - instead of movie
- Titles are duplicated, but only one query
- Changing movie titles is rare, so it is fine

## Parent Child

Parent / Child Relationship

- Star Wars
  - A New Hope
  - Empire Strikes Back
  - Return of the Jedi
  - The Force Awakens


```
curl -XPUT 127.0.0.1:9200/series -d '
{
	"mappings": {
		"properties": {
			"film_to_franchise": {
				"type": "join",
				"relations": {"franchise": "film"}
			}
		}

	}
}
'
```
```
 ./curl_json.sh -XGET 127.0.0.1:9200/series/_search\?pretty -d '
{ "query": {
	"has_parent": {
			"parent_type": "franchise",
			"query": {
				"match": {
					"title": "Star Wars"
				}
			}
		}
	}
}'
```
```
./curl_json.sh -XGET 127.0.0.1:9200/series/_search\?pretty -d '
{ "query": {
        "has_parent": {
                        "parent_type": "franchise",
                        "query": {
                                "match": {
                                        "title": "Star Wars"
                                }
                        }
                }
        }
}'

{
  "took" : 591,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 7,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "series",
        "_type" : "_doc",
        "_id" : "260",
        "_score" : 1.0,
        "_routing" : "1",
        "_source" : {
          "id" : "260",
          "film_to_franchise" : {
            "name" : "film",
            "parent" : "1"
          },
          "title" : "Star Wars: Episode IV - A New Hope",
          "year" : "1977",
          "genre" : [
            "Action",
            "Adventure",
            "Sci-Fi"
          ]
        }
      },
      {
        "_index" : "series",
        "_type" : "_doc",
        "_id" : "1196",
        "_score" : 1.0,
        "_routing" : "1",
        "_source" : {
          "id" : "1196",
          "film_to_franchise" : {
            "name" : "film",
            "parent" : "1"
          },
          "title" : "Star Wars: Episode V - The Empire Strikes Back",
          "year" : "1980",
          "genre" : [
            "Action",
            "Adventure",
            "Sci-Fi"
          ]
        }
      },
      {
        "_index" : "series",
        "_type" : "_doc",
        "_id" : "1210",
        "_score" : 1.0,
        "_routing" : "1",
        "_source" : {
          "id" : "1210",
          "film_to_franchise" : {
            "name" : "film",
            "parent" : "1"
          },
          "title" : "Star Wars: Episode VI - Return of the Jedi",
          "year" : "1983",
          "genre" : [
            "Action",
            "Adventure",
            "Sci-Fi"
          ]
        }
      },
      {
        "_index" : "series",
        "_type" : "_doc",
        "_id" : "2628",
        "_score" : 1.0,
        "_routing" : "1",
        "_source" : {
          "id" : "2628",
          "film_to_franchise" : {
            "name" : "film",
            "parent" : "1"
          },
          "title" : "Star Wars: Episode I - The Phantom Menace",
          "year" : "1999",
          "genre" : [
            "Action",
            "Adventure",
            "Sci-Fi"
          ]
        }
      },
      {
        "_index" : "series",
        "_type" : "_doc",
        "_id" : "5378",
        "_score" : 1.0,
        "_routing" : "1",
        "_source" : {
          "id" : "5378",
          "film_to_franchise" : {
            "name" : "film",
            "parent" : "1"
          },
          "title" : "Star Wars: Episode II - Attack of the Clones",
          "year" : "2002",
          "genre" : [
            "Action",
            "Adventure",
            "Sci-Fi",
            "IMAX"
          ]
        }
      },
      {
        "_index" : "series",
        "_type" : "_doc",
        "_id" : "33493",
        "_score" : 1.0,
        "_routing" : "1",
        "_source" : {
          "id" : "33493",
          "film_to_franchise" : {
            "name" : "film",
            "parent" : "1"
          },
          "title" : "Star Wars: Episode III - Revenge of the Sith",
          "year" : "2005",
          "genre" : [
            "Action",
            "Adventure",
            "Sci-Fi"
          ]
        }
      },
      {
        "_index" : "series",
        "_type" : "_doc",
        "_id" : "122886",
        "_score" : 1.0,
        "_routing" : "1",
        "_source" : {
          "id" : "122886",
          "film_to_franchise" : {
            "name" : "film",
            "parent" : "1"
          },
          "title" : "Star Wars: Episode VII - The Force Awakens",
          "year" : "2015",
          "genre" : [
            "Action",
            "Adventure",
            "Fantasy",
            "Sci-Fi",
            "IMAX"
          ]
        }
      }
    ]
  }
}
```


Find franchise for a film:
```
 ./curl_json.sh -XGET 127.0.0.1:9200/series/_search\?pretty -d '{
"query": {
	"has_child": {
			"type": "film",
			"query": {
				"match": {
					"title": "The Force Awakens"
				}
			}
		}
	}
}'
```
```
{
  "took" : 2,
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
        "_index" : "series",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "_routing" : "1",
        "_source" : {
          "id" : "1",
          "film_to_franchise" : {
            "name" : "franchise"
          },
          "title" : "Star Wars"
        }
      }
    ]
  }
}
