class Counter < Concurrent::Actor::Context
  # Include context of an actor which gives this class access to reference and other information
  # about the actor, see PublicDelegations.

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
end 

# Create new actor naming the instance 'first'.
# Return value is a reference to the actor, the actual actor is never returned.
counter = Counter.spawn(:first, 5)                 # => #<Concurrent::Actor::Reference /first (Counter)>

# Tell a message and forget returning self.
counter.tell(1)                                    # => #<Concurrent::Actor::Reference /first (Counter)>
counter << 1                                       # => #<Concurrent::Actor::Reference /first (Counter)>
# (First counter now contains 7.)

# Send a messages asking for a result.
counter.ask(0).class                               # => Concurrent::IVar
counter.ask(0).value                               # => 7

# Terminate the actor.
counter.tell(:terminate!)                          # => #<Concurrent::Actor::Reference /first (Counter)>
# Not terminated yet, it takes a while until the message is processed.
counter.terminated?                                # => false
# Waiting for the termination.
counter.terminated.class                           # => Concurrent::Event
counter.terminated.wait                            # => true
counter.terminated?                                # => true
# Any subsequent messages are rejected.
counter.ask(5).wait.rejected?                      # => true

# Failure on message processing terminates the actor.
counter = Counter.spawn(:first, 0)                 # => #<Concurrent::Actor::Reference /first (Counter)>
counter.ask('boom').wait.rejected?                 # => false
counter.terminated?                                # => false


# Lets define an actor creating children actors.
class Node < Concurrent::Actor::Context
  def on_message(message)
    case message
    when :new_child
      Node.spawn :child
    when :how_many_children
      children.size
    else
      raise 'unknown'
    end
  end
end 

# Actors are tracking parent-child relationships
parent = Node.spawn :parent                        # => #<Concurrent::Actor::Reference /parent (Node)>
child  = parent.tell(:new_child).ask!(:new_child)
    # => #<Concurrent::Actor::Reference /parent/child (Node)>
child.parent                                       # => #<Concurrent::Actor::Reference /parent (Node)>
parent.ask!(:how_many_children)                    # => 2

# There is a special root actor which is used for all actors spawned outside any actor.
parent.parent
    # => #<Concurrent::Actor::Reference / (Concurrent::Actor::Root)>

# Termination of an parent will also terminate all children.
parent.ask('boom').wait 
parent.terminated?                                 # => true
child.terminated?                                  # => true
