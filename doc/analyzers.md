# Intro

## Mapping

- Mapping = schema definition:
- ES has defaults, sometimes how to customize
- Use to customize:
  - Field types: string, byte, short, int, etc.
  - Field index: should this be analyzed/indexed for FTS?
  - Field analyzer: define tokenizer & token filter, whitespace, simple, english, etc.

### Analyzers

- Character filters: remove HTML encoding, convert & --> and
- Tokenizer: split strings on whitespace / punctuation / non-letters
- Token filter: lowercasing, stemming, synonyms, stopwords

#### Choices

- standard: splits on word boundaries
- simple: spliets on anything that isn't a letter
- whitspace
- language
  - can mix and match on same language

```
# movies = index

curl -XPUT 127.0.0.1:9200/movies -d '
{
	"mappings": {
		"properties": {
			"year": {"type": "date"}
		}

	}

}'
```

## Using Analyzers

- Sometimes text fields should be an exact-match: use keyword mapping
- Search on analyzed text fields will return anything remotely relevant
  - Can run analyzers: case-insensitive, stemming, stopwrods removed, etc.


Another mapping - so that genres are now keywords.
```
./curl_json.sh -XPUT 127.0.0.1:9200/movies -d '{
        "mappings": {
                "properties": {
                        "id": {"type": "integer"},
                        "year": {"type": "date"},
                        "genre": {"type": "keyword"},
                        "title": {"type": "text", "analyzer": "english"}
                }
        }
}'

{"acknowledged":true,"shards_acknowledged":true,"index":"movies"}%
```
```
./curl_json.sh -XPUT 127.0.0.1:9200/_bulk\?pretty --data-binary @movies.json
```

- Looking for:

```
curl -XGET 127.0.0.1:9200/moves/_search?pretty -d '
{
	"query": {
		"match": {
			"genre": "Sci-Fi" # "sci-fi" and "sci" won't work now; case-sensitive
		}
	}
}
'
```

```
curl -XGET 127.0.0.1:9200/moves/_search?pretty -d '
{
	"query": {
		"match": {
			"title": "star wars" # field is analyzed, since it is text
		}
	}
}
'
```
