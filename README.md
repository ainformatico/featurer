[![Build Status](https://travis-ci.org/ainformatico/featurer.svg)](https://travis-ci.org/ainformatico/featurer)

# Featurer
Easy _feature flag_ for your project.

By default `featurer` saves all the data in Redis, although you can create your own adapter.

## Features

* Shipped with Redis support by default
  * Fast
  * Doesn't overload your main database
  * Doesn't save data in your application's memory(don't lose it when restarting)
  * Redis goodies :D
* Non-framework dependent
  * Plug it wherever you want, Sinatra, Padrino, Rails, your own scripts...
* Create your own adapter

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'featurer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install featurer

## Usage

### Configure your connection:
```ruby
Featurer.configure(host: host, port: port)
```

or use the default _localhost_ connection:

```ruby
Featurer.init
```

### Start using it:

#### Per user feature

For different users:

```ruby
Featurer.register(:feature, [first_user_id, sercond_users_id, third_user_id])
```

or single:

```ruby
Featurer.register(:feature, user_id)
```

Then request the enabled feature:

```ruby
Featurer.on?(:feature, user_id)
```

#### Global feature

```ruby
Featurer.register(:feature, true)
```

Then request the enabled feature:

```ruby
Featurer.on? :feature
```

#### Deleting features

```ruby
Featurer.delete(:feature)
```

#### Create your own adapter

Just extend `Featurer::Adapter`, add the basic methods and your are done! e.g

```ruby
class TestAdapter < Featurer::Adapter
  def prepare
    # if defined this is called automatically
    # in order to initialize your adapter
    # e.g: @redis = Redis.new
  end

  def register(name, value = true)
    # your logic
  end

  def on?(name, value = true)
    # your logic
  end

  def delete(name)
    # your logic
end
```

**This will automatically register your adapter in the adapters list**.
Also it will give it an _id_, in this case `test`, is the lowercase _class name_ without
the adapter keyword.

Then initialize your `featurer`:

```ruby
Featurer.configure(adapter: :test, custom: :option)
```

Your are ready to go! No need to call `.init`


## Contributing

1. Fork it ( https://github.com/ainformatico/featurer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a [new Pull Request](https://github.com/ainformatico/featurer/compare)

## License

Copyright (c) 2014 Alejandro El Informático

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
