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
