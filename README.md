# Concurrent Ruby
[![Gem Version](https://badge.fury.io/rb/concurrent-ruby.png)](http://badge.fury.io/rb/concurrent-ruby) [![Build Status](https://travis-ci.org/ruby-concurrency/concurrent-ruby.svg?branch=master)](https://travis-ci.org/ruby-concurrency/concurrent-ruby) [![Coverage Status](https://coveralls.io/repos/ruby-concurrency/concurrent-ruby/badge.png)](https://coveralls.io/r/ruby-concurrency/concurrent-ruby) [![Code Climate](https://codeclimate.com/github/ruby-concurrency/concurrent-ruby.png)](https://codeclimate.com/github/ruby-concurrency/concurrent-ruby) [![Inline docs](http://inch-ci.org/github/ruby-concurrency/concurrent-ruby.png)](http://inch-ci.org/github/ruby-concurrency/concurrent-ruby) [![Dependency Status](https://gemnasium.com/ruby-concurrency/concurrent-ruby.png)](https://gemnasium.com/ruby-concurrency/concurrent-ruby) [![Gitter chat](https://badges.gitter.im/ruby-concurrency/concurrent-ruby.png)](https://gitter.im/ruby-concurrency/concurrent-ruby)

<table>
  <tr>
    <td align="left" valign="top">
      <p>
        Modern concurrency tools for Ruby. Inspired by
        <a href="http://www.erlang.org/doc/reference_manual/processes.html">Erlang</a>,
        <a href="http://clojure.org/concurrent_programming">Clojure</a>,
        <a href="http://akka.io/">Scala</a>,
        <a href="http://www.haskell.org/haskellwiki/Applications_and_libraries/Concurrency_and_parallelism#Concurrent_Haskell">Haskell</a>,
        <a href="http://blogs.msdn.com/b/dsyme/archive/2010/02/15/async-and-parallel-design-patterns-in-f-part-3-agents.aspx">F#</a>,
        <a href="http://msdn.microsoft.com/en-us/library/vstudio/hh191443.aspx">C#</a>,
        <a href="http://docs.oracle.com/javase/7/docs/api/java/util/concurrent/package-summary.html">Java</a>,
        and classic concurrency patterns.
      </p>
      <p>
        The design goals of this gem are:
        <ul>
          <li>Be an 'unopinionated' toolbox that provides useful utilities without debating which is better or why</li>
          <li>Remain free of external gem dependencies</li>
          <li>Stay true to the spirit of the languages providing inspiration</li>
          <li>But implement in a way that makes sense for Ruby</li>
          <li>Keep the semantics as idiomatic Ruby as possible</li>
          <li>Support features that make sense in Ruby</li>
          <li>Exclude features that don't make sense in Ruby</li>
          <li>Be small, lean, and loosely coupled</li>
        </ul>
      </p>
    </td>
    <td align="right" valign="top">
      <img src="https://raw.githubusercontent.com/wiki/ruby-concurrency/concurrent-ruby/logo/concurrent-ruby-logo-300x300.png"/>
    </td>
  </tr>
</table>

## Install

```shell
gem install concurrent-ruby
```

or add the following line to Gemfile:

```ruby
gem 'concurrent-ruby'
```

and run `bundle install` from your shell.

_NOTE: There is an old gem from 2007 called "concurrent" that does not appear to be under active development. That isn't us. Please do not run* `gem install concurrent`*. It is not the droid you are looking for._

## Features & Documentation

Please see the [Concurrent Ruby Wiki](https://github.com/ruby-concurrency/concurrent-ruby/wiki)
or the [API documentation](http://ruby-concurrency.github.io/concurrent-ruby/frames.html)
for more information or join our [mailing list](http://groups.google.com/group/concurrent-ruby).

There are many concurrency abstractions in this library. These abstractions can be broadly categorized
into several general groups:

* Asynchronous concurrency abstractions including
  [Agent](http://ruby-concurrency.github.io/concurrent-ruby/Concurrent/Agent.html),
  [Async](http://ruby-concurrency.github.io/concurrent-ruby/Concurrent/Async.html),
  [Future](http://ruby-concurrency.github.io/concurrent-ruby/Concurrent/Future.html),
  [Promise](http://ruby-concurrency.github.io/concurrent-ruby/Concurrent/Promise.html),
  [ScheduledTask](http://ruby-concurrency.github.io/concurrent-ruby/Concurrent/ScheduledTask.html),
  and [TimerTask](http://ruby-concurrency.github.io/concurrent-ruby/Concurrent/TimerTask.html) 
* Fast, light-weight [Actor model](http://ruby-concurrency.github.io/concurrent-ruby/Concurrent/Actor.html) implementation. 
* Thread-safe variables including
  [I-Structures](http://ruby-concurrency.github.io/concurrent-ruby/Concurrent/IVar.html),
  [M-Structures](http://ruby-concurrency.github.io/concurrent-ruby/Concurrent/MVar.html),
  [thread-local variables](http://ruby-concurrency.github.io/concurrent-ruby/Concurrent/ThreadLocalVar.html),
  and [software transactional memory](https://github.com/ruby-concurrency/concurrent-ruby/wiki/TVar-(STM))
* Thread synchronization classes and algorithms including
  [condition](http://ruby-concurrency.github.io/concurrent-ruby/Concurrent/Condition.html),
  [countdown latch](http://ruby-concurrency.github.io/concurrent-ruby/Concurrent/CountDownLatch.html),
  [dataflow](https://github.com/ruby-concurrency/concurrent-ruby/wiki/Dataflow), 
  [event](http://ruby-concurrency.github.io/concurrent-ruby/Concurrent/Event.html),
  [exchanger](http://ruby-concurrency.github.io/concurrent-ruby/Concurrent/Exchanger.html),
  and [timeout](http://ruby-concurrency.github.io/concurrent-ruby/Concurrent.html#timeout-class_method)
* Java-inspired [executors](https://github.com/ruby-concurrency/concurrent-ruby/wiki/Thread%20Pools) (thread pools and more)
* [And many more](http://ruby-concurrency.github.io/concurrent-ruby/index.html)...

### Semantic Versioning

This gem adheres to the rules of [semantic versioning](http://semver.org/).

### Supported Ruby versions

MRI 1.9.3, 2.0, 2.1, JRuby (1.9 mode), and Rubinius 2.x.
This library is pure Ruby and has no gem dependencies.
It should be fully compatible with any interpreter that is compliant with Ruby 1.9.3 or newer.

### Examples

Many more code examples can be found in the documentation for each class (linked above).

Future and ScheduledTask:

```ruby    
require 'concurrent'
require 'thread'   # for Queue
require 'open-uri' # for open(uri)

class Ticker
  def get_year_end_closing(symbol, year)
    uri = "http://ichart.finance.yahoo.com/table.csv?s=#{symbol}&a=11&b=01&c=#{year}&d=11&e=31&f=#{year}&g=m"
    data = open(uri) {|f| f.collect{|line| line.strip } }
    data[1].split(',')[4].to_f
  end
end

# Future
price = Concurrent::Future.execute{ Ticker.new.get_year_end_closing('TWTR', 2013) }
price.state #=> :pending
sleep(1)    # do other stuff
price.value #=> 63.65
price.state #=> :fulfilled

# ScheduledTask
task = Concurrent::ScheduledTask.execute(2){ Ticker.new.get_year_end_closing('INTC', 2013) }
task.state #=> :pending
sleep(3)   # do other stuff
task.value #=> 25.96
```

Actor:

```ruby
class Counter < Concurrent::Actor::Context
  # Include context of an actor which gives this class access to reference
  # and other information about the actor

  # use initialize as you wish
  def initialize(initial_value)
    @count = initial_value
  end

  # override on_message to define actor's behaviour
  def on_message(message)
    if Integer === message
      @count += message
    end
  end
end #

# Create new actor naming the instance 'first'.
# Return value is a reference to the actor, the actual actor is never returned.
counter = Counter.spawn(:first, 5)

# Tell a message and forget returning self.
counter.tell(1)
counter << 1
# (First counter now contains 7.)

# Send a messages asking for a result.
counter.ask(0).class
counter.ask(0).value
```

## Maintainers

* [Jerry D'Antonio](https://github.com/jdantonio)
* [Michele Della Torre](https://github.com/mighe)
* [Chris Seaton](https://github.com/chrisseaton)
* [Lucas Allan](https://github.com/lucasallan)
* [Petr Chalupa](https://github.com/pitr-ch)

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License and Copyright

*Concurrent Ruby* is free software released under the [MIT License](http://www.opensource.org/licenses/MIT).

The *Concurrent Ruby* [logo](https://github.com/ruby-concurrency/concurrent-ruby/wiki/Logo)
was designed by [David Jones](https://twitter.com/zombyboy).
It is Copyright &copy; 2014 [Jerry D'Antonio](https://twitter.com/jerrydantonio). All Rights Reserved.
