# Notes Client Ruby

Accessing NotesServer and work with notes

## Instalation

Just in console

``` ruby
gem install notes-client-ruby
```

Or put into Gemfile

``` ruby
gem "notes-client-ruby"
```

and somewhere before use (not rails - they will require gem automaticaly)
``` ruby
require "notes-client-ruby"
```

## Initialization

Setup your config values

``` ruby
NotesClient.api_token = "YOUR_TOKEN"
NotesClient.taxonomy = "YOUR_TAXONOMY"

#optional settings
NotesClient.version = :v1
#default is :v1

#url where is slim api located
NotesClient.url = "http://notes.ataxo.com"
```

## Working with Gem

You can access Main classes: Notes

### How classes works

[Notes documentation](http://notes.ataxo.com/doc/v1)

``` ruby
# Find some objects:
notes = NotesClient::Note.find
# you got [ <Client:..>, ... ] and choose first one
note = notes.first
# then you can ask for something
notes.client #=> "Client Name"
```

Arguments from api is hash, this hash is saved by hashr directly into instance.
**Instance is still Hash, you can do all stuf like with normal hash.**

### Find
``` ruby

#to find client by id
notes = NoteClient::Notes.find :id => 12345678
#=> [ <Note:..>, ... ]
# find will always return array!
```

### Order 
 
You can order you find requests:

```ruby
NotesClient::Notes.find :order => 'client desc'
```

### Pagination

we added some functionality to array returned by method find

``` ruby
#default pagination setup
NotesClient.find_options
#=> { limit: 10, offset: 0 }
# and you can setup it by:
NotesClient.find_options = { limit: 20, offset: 0 }
#this is default configuration for all find methods, 
#but you can easily overwrite for one call it by adding limit/offset to find method:
NotesClient::Notes.find limit: 15

#get first page of clients (in db is 25 clients mathching find, but you will get only 10 default find limit)
notes = NotesClient::Notes.find
#=> [ <Note: 1..>, <Note: 2..>, <Note: 3..> .., <Note: 10..>]
notes.total_count
#=> 25 #this will tell you how many items can be getted
notes.has_next_page?
#=> true #this will tell you if you can do .next_page
notes.limit
#=> 10 #show find limit
notes.offset
#=> 0 #show find current offset
notes.page_count
#=> 3 #show how many pages you can get
notes.actual_page
#=> 1 #show current page

# this will return you new array with new data, but with offset changed to offset + limit
second_page_of_notes = notes.next_page
#=> [ <Client: 11..>, <Client: 12..>, <Client: 13..> .., <Client: 20..>]

second_page_of_notes.offset
#=> 10
second_page_of_notes.actual_page
#=> 2
```

## Copyright

Copyright (c) 2013 Ondrej Bartas. See LICENSE.txt for
further details.lient: 10..>]
clients.total_count
#=> 25 #this will tell you how many items can be getted
clients.has_next_page?
#=> true #this will tell you if you can do .next_page
clients.limit
#=> 10 #show find limit
clients.offset
#=> 0 #show find current offset
clients.page_count
#=> 3 #show how many pages you can get
clients.actual_page
#=> 1 #show current page

# this will return you new array with new data, but with offset changed to offset + limit
second_page_of_clients = clients.next_page
#=> [ <Client: 11..>, <Client: 12..>, <Client: 13..> .., <Client: 20..>]

second_page_of_clients.offset
#=> 10
second_page_of_clients.actual_page
#=> 2
```

## Copyright

Copyright (c) 2012 Ondrej Bartas. See LICENSE.txt for
further details.