# EveStatic

EveStatic is a gem designed to access the eve online static database dump, and provides convenience methods,
especially for industry calculations.

## Installation

Add this line to your application's Gemfile:

    gem 'eve_static'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install eve_static

## Usage

There is only one class at the moment, `EveStatic::Database`. It is based on the sequel gem,
and takes the same parameters as the `Sequel.connect` method, the `:adapter` parameter defaults to 
the `mysql2` adapter.

Example:

    db = EveStatic::Database.new(:user => "some_user", :database => "evestatic")
    db.materials("Raven") # output omitted

You'll need to supply the current eve static database dump yourself.

Any method requiring a type works with either the `typeID` or `typeName`, and automatically coerces
blueprint names as well (so if you supply `Raven`, it will automatically lookup `Raven Blueprint` in
`invBlueprintTypes` for manufacture times et al).

If you want to query for data yourself, the sequel database object is exposed as `instance` on the `EveStatic::Database` object.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
