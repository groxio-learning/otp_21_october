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

Since elixir doesn't allow mutation we use iteration instead
```
def run(count_value) do
  count_value
  |> listen()  # waits for a transform instruction and send on to run
  |> run()     # this sends back the value from listen back to itself
end
```

* the important thing is that the run is loop that receives its state and waits and listens for the next message

**USING the Boundary Layer**

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
10> receive do message -> IO.puts message end    # our own flush method

11> fetch_mail = fn -> receive do m -> m end end # create own way to get mail as Anonymous function

12> send self, "all good"  # send myself a text message
13> fetch_mail.()
"all good"
```

## Round 3: abstracting send / flush (API layer)

modify the main code to interact with the boundary (create the API layer)

```
vim lib/adderall.ex
```

* from iex we needed to **start** the process (with an option to initalize a value)
* from iex we needed to **increment** (which knows the process_pid - which knows its state)
* from iex we needed to **get** the value (we send it a message and wait for the response - with the `receive`)


**USAGE after building API**
```
iex -S mix

> minion1 = Adderall.start()
> minion2 = Adderall.start(42)

> Adderall.increment(minion1)
> Adderall.get(minion1)
1

> Adderall.increment(minion2)
> Adderall.increment(minion2)
> Adderall.get(minion2)
43

> Adderall.get(minion1)
1
```
