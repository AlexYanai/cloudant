# Cloudant

[![Build Status](https://travis-ci.org/AlexYanai/cloudant.svg?branch=master)](https://travis-ci.org/AlexYanai/cloudant)
[![Coverage Status](https://coveralls.io/repos/github/AlexYanai/cloudant/badge.svg?branch=master)](https://coveralls.io/github/AlexYanai/cloudant?branch=master)
[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](https://github.com/AlexYanai/cloudant/blob/master/LICENSE.txt)

Ruby Cloudant is a simple Ruby interface for [IBM Cloudant's](https://cloudant.com/) API. Cloudant is a NoSQL database built on [CouchDB](http://couchdb.apache.org/).

This gem is still in [development](##Contributing) and is a work in progress. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cloudant'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cloudant

## Usage
Create a Cloudant account and find your credentials.

**Creating a new client**

If valid credentials are provided a `POST` request will be made to `/_session` and the user will be logged in via [cookie authentication](https://docs.cloudant.com/authentication.html#cookie-authentication)
```ruby
credentials = {
  :username => ENV['username'],
  :password => ENV['password'],
  :database => ENV['database'] # Can leave blank.
}

client = Cloudant::Client.new(credentials)
```

Ending a session
```ruby
client.close
```

**Setting and changing databases**

If this is your first time accessing a new Cloudant instance, or don't have a database existing, create one:
```ruby
client.all_dbs # See existing databases
client.create_db(database_name)
```

Or delete an existing database:

```ruby
client.delete_db(database_name)
```

You can then set (or change, if one is already set) a new database:
```ruby
client.database = database_name
client.db_info # See database information, including name and size
```

**Basic Usage**
```ruby
# Create a single document
doc = {'_id'=>'1', 'field_one'=>'your content'}
response = client.create(doc)
# => {'ok'=>true, 'id'=>'1', 'rev'=>'1-be74a68c2105f3d9d0245eb8736ca9f1'}

# Find a single document by id
doc_id = response['id']
client.doc(doc_id)

# Update a single document (requires an existing doc's id and current rev)
new_doc = {'id'=>'1', 'rev'=>'1-bf74a68c2105f3d9d0245fc836ca9f3', 'field_two'=>'more content'}
client.update(new_doc)

# Delete a single doc
client.delete_doc(doc_id)
```

**Multiple Documents**
```ruby
# Creating multiple documents
docs = [
  {'_id'=>'1', 'field_one' => 'your content'}, 
  {'_id'=>'2', 'field_two' => 'more content'},
  {'_id'=>'3', 'field_three' => 'new content'}
]

client.create_docs(docs)

# Updating multiple docs
# Note: updating and creating multiple documents are equivalent
client.update_docs(docs)

# Deleting multiple docs
client.delete_docs(docs)
```
`:delete_docs` is a convenience method; deleting multiple documents at once is best performed by adding `['_deleted']` to each document and performing an update. [Bulk operations](https://docs.cloudant.com/document.html#bulk-operations)

**Indices, Design Docs**
```ruby
# Create a new index
client.create_index({index: {}, type: 'text', name: 'test_index'})

# See all indices
client.get_indices # Or client.get_indexes

# Create a new design doc named 'test'
ddoc = {'language' => 'javascript', 'views' => {} }
client.create_design_doc('test',ddoc)
```

**Querying and Views**
```ruby
# Perform a single query
q = {'selector': {'test_field': {'$exists': true}},'fields': ['_id', '_rev'],'limit': 1,'skip': 0}
client.query(q)

# Performing a paginated query using a bookmark
q = {"selector": {"test_field": {"$exists": true}},"fields": ["_id", "_rev"],"limit": 1,"skip": 0}
client.bookmark_query(q) do |docs| 
  # Do something with the returned documents
end
```

[Querying](https://docs.cloudant.com/cloudant_query.html#finding-documents-using-an-index)

```ruby
# Creating a view
client.create_view('test',{"current"=>{"reduce"=>"_count","map"=>"function (doc) {\n  if (doc.status === \"name\") {\n    emit(doc._id,1);\n  }\n}"}})

# Querying an existing view
database = 'test'
view_to_query = 'current'

client.view(database,view_to_query) # If a reduce function is given will return a 'rows' array with a single record, the value of the reduce
# => {"rows"=>[{"key"=>nil, "value"=>2}]} 

client.view(database,view_to_query, :reduce => false, :include_docs => true)
# => {"total_rows"=>2, "offset"=>0, "rows"=>[{"id"=>"5d8e6c99198dfdde8accd8e019ba052", "key"=>"5d8e6c99198dfdde8accd8e019ba052", "value"=>1, "doc"=>{"_id"=>"5d8e6c99198dfdde8accd8e019ba052", "_rev"=>"1-7ebdb5b82e1cc4eaf2e27a711e9857c6", "a"=>10, "b"=>92, "c"=>31}}, {"id"=>"5d8e6c99898dcdd08accd8e019badab", "key"=>"5d8e6c99898dcdd0daccd8e019badab", "value"=>1, "doc"=>{"_id"=>"5d8e6c99898dcdd8daccd8e019badab", "_rev"=>"1-d36298f4391da575df61e170af2efa34", "b"=>12, "c"=>33}}]}
```

For a full list of options, see [Using Views](https://docs.cloudant.com/creating_views.html#using-views)

## To Do
- Add database replication functionality - `/_replicator`
- Allow new user creation - `/_security`
- Add more robust options handling for various queries (expanding the `QueryBuilder` module, as used in view querying)
    -   Currently, options have to be added to a query string by the user.
- Add support for `attachments`   


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright (c) 2016 Alex Yanai. Released under the [MIT License](http://opensource.org/licenses/MIT).