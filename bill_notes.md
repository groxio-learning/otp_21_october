Notes for Bill Tihen

# Core Concepts

**D**o **F**un **T**hings with **B**ig **W**orkerbees

**Core**

* Data
* Functions
* Tests

**Other Stuff**

* Boundaries
* Lifecycles
* Workers

## Anonymous Functions using main Design Patter

* constructor
* reducers, ...
* converters

```
constructor = fn -> 42 end

reducer = fn acc, i -> acc + i end

# increment = fn acc, - -> acc + 1 end
# increment = fn acc -> acc + 1 end

converter = fn acc -> "#{acc}"  # convert integer to string

# works but only when commutative
Enum.reducer(1..3, constructor.(), )

# better always works with pipes
constructor.() |> reducer.(1) |> reducer.(1)
               |> reducer.(-1) |> converter.()

```

## Round 1: create new adder project & its core code

```
mix new adderall --sup   # lifecycle not supervisor
cd adderall

mkdir lib/adderall/core
touch lib/adderall/core/counter.ex  # core logic goes here

# core logic needs:
# * constructor (in complex logic a struct too)
# * reducers (logic)
# *
```

## Round 2: create the boundary (protect from uncertain inputs)

Boundary is guards and process machinery
* **guards** against invalid inputs (build into )
* **start** call constructor in core and **spawn run**
  `spawn(fn -> run(count) end)` -- starts run as a process with constructor
* **run** loop that ensures we are listening and doing actions
  `count |> listen() | run()`
* **listeners** (machinery)- elixir's messages reciever (with otp there are pre-defined message contracts)
  - _oneway_ (`cast`) -> action -- increment - in our case - oneway like postcast
  - _twoway_ (`call`) -> action(maybe) and return (sends back or somewhere) `send from, count` (`send` message) - like `phone call` (two way)


```
mkdir lib/adderall/boundary
touch lib/adderall/boundary/service.ex
```

```
iex -S mix

1> alias Adderall.Boundary.Service  # should autocomplete
2> h receive          # lots of info on receive
3> Service.start      # start service by calling our boundary start
4> pid = v 3          # gets a value in iex history
5> Process.alive? pid #
6> send pid, {:get, self} # send to new process pid has server info
7> flush      # gets info from mailbox (listens until mailbox is empty)
8> send pid, :increment
9> send pid, {:get, self}
9> send pid, :increment
9> send pid, {:get, self}
10> receive do message -> IO.puts message end  # our own flush method
```

## Round 3: abstracting send / flush
