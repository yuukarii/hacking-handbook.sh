# Example
{
  "store": {
    "book": [
      {"title": "Book A", "price": 10, "category": "fiction"},
      {"title": "Book B", "price": 25, "category": "reference"}
    ],
    "bicycle": {"color": "red", "price": 100}
  }
}

$.store.bicycle.color → "red"
$.store.book[0].title → "Book A"
$.store.book[*].title → ["Book A", "Book B"]
$.store.book[-1] → last book
$[-1:]
$[-4:]
$[-8:-2]
$.store.book[0:1] → first book (slice)
$..price → all prices anywhere: [10, 25, 100]
$.store.book[?(@.price > 15)] → books with price > 15
$.store.book[?(@.category=='fiction')].title → "Book A"


# Advanced chain
cat q11.json | jpath '$.prizes[?(@.year=='2014')].laureates[?(@.id=='914')]'
cat q13.json | jpath '$[0,3]'

# Applied on Kubernetes
