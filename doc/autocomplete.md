# Autocomplete

## Query-time search-as-you-type

* Hack the `slop` factor
** Not the right way to do this **

```
curl -XGET '127.0.0.1:9200/movies/_search\?pretty' -d '
{
	"query": {
		"match_phrase_prefix": {
			"title": {
				"query": "star trek",
				"slop": 10,
			}
		}
	}
}
'
```

```
curl -XGET '127.0.0.1:9200/movies/_search\?pretty' -d '
{
	"query": {
		"match_phrase_prefix": {
			"title": {
				"query": "star tr",
				"slop": 10,
			}
		}
	}
}
'
```

Note:
- Title field is analyzed
- Prefix "t" matches "trek" and "the"
  - "star t" --> "star tr" and "star ... the"


## Index-time with N-grams

"star":

unigram: [s, t, a, r]
bigram: [st, ta, ar]
trigram: [sta, tar]
4-gram: [star]

### Indexing n-grams

1. Create an autocomplete analyzer

```
curl -XPUT '127.0.0.1:9200/movie\?pretty' -d '
{
}
'
```
