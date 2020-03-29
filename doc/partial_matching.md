# Partial Matching

## Prefix queries on strings

- If we remapped year to be a string:

```
curl -XGET '127.0.0.1:9200/movies/_search\?pretty' -d '
{
	"query": {
		"prefix": {
			"year": "201"
		}
	}

}
'
```

## Wildcard queries

```
curl -XGET '127.0.0.1:9200/movies/_search\?pretty' -d '
{
	"query": {
		"wildcard": {
			"year": "1*"
		}
	}
}'
```

Note: year needs to be a text type and not a date type for partial matching.
