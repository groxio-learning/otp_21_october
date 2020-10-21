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


## Round 4: using GenServer

```
touch lib/boundary/server.ex

iex -S mix

h GenServer  # put modified code into server.ex

# see code example at the top:

# USAGE

1> {:ok, pid} = GenServer.start_link(Adderall.Boundary.Server, 42)

2> GenServer.cast(pid, :inc)  # send our increment to the GenServer API

3> :sys.get_state pid  # debugging way to peek on GenServer processes

4> GenServer.call(pid, :get)  # standard way to access GenServer state
```

`use GenServer` calls the code (macro dump) https://github.com/elixir-lang/elixir/blob/master/lib/elixir/lib/gen_server.ex all this is based on the code concepts from this morning.

**Init** method allows 3 things:
1) check all is ok (or fail)
2) do a lookup or transform to get started
3) if 1 (bad data) and or 2 (lookup times out) then explain fail


## Round 5 - adding an API in the server

update: `vim lib/boundary/server.ex` with API to call handlers

usage:

```
{:ok, counter} = Server.start_link(42)

:sys.get_state counter

Server.increment(counter)

Server.get(counter)
```


## Round 6: Master mind logic / design

Practice game at: https://www.webgamesonline.com/mastermind/

**Design** - to clarify

* will have guess module
* will have board module

```
# for testing use a defined answer
answer = [1, 2, 3, 4]

# get 4 random colors no repeats allowed
(1..8) |> Enum.shuffle |> Enum.take(4)

# get a single random number (between 1 & 8)
:rand.uniform(8)

# get random numbers on demand (as an Anonymous function)
random_number = fn -> :rand.uniform(8) end

# use a stream to get random numbers on demand (allowing repeats)
stream_1 = Stream.repeatedly(random_number)

# grab just four as our guess
guess = stream_1 |> Enum.take(4)

guess  = [5, 7, 2, 4]

# find the correct colors in the correct spot
correct = answer |> Enum.zip(guess) |> Enum.filter(fn {x, y} -> x == y end) | Enum.count

# or better yet
red = answer |> Enum.zip(guess) |> Enum.count(fn {x, y} -> x == y end)

# completely wrong (take away all the correct answers from the guesses - leaves only wrong stuff)
misses = (guess -- answer) |> Enum.count

# count all spots
size = Enum.size(answer)

# now we can find the correct color wrong spot  score
white = size - correct - misses
```

Study the `with` command:

* https://joyofelixir.com/12-conditional-code
* https://openmymind.net/Elixirs-With-Statement/
* https://til.hashrocket.com/posts/ipq42kdcx8-with-statement-has-an-else-clause
* https://blog.sundaycoding.com/blog/2017/12/27/elixir-with-syntax-and-guard-clauses/


## Experiment Day-1: accounts that can transfer between processes

**GenServer - with as a boundary layer to accounts (core)**

```
> alias Banking.Service

> {:ok, savings} = Service.start_link(1000)
{:ok, #PID<0.233.0>}

> Service.balance(savings)
1000

Service.deposit(savings, 500)
:ok

> Service.balance(savings)     
1500


> {:ok, checking} = Service.start_link(250)
{:ok, #PID<0.235.0>}

> Service.balance(checking)
250

> Service.withdrawl(checking,50)
:ok

> Service.balance(checking)     
200

Service.transfer(savings, checking, 100)
:ok

> Service.balance(checking)
300

> Service.balance(savings)
1400
```

**With a context layer:**

lib/banking.ex

USAGE:

```
iex -S mix

{:ok, checking} =  Banking.open_account(250)
{:ok, savings}  =  Banking.open_account(2500)

Banking.balance(savings)
Banking.balance(checking)

Banking.deposit(savings, 500)
Banking.withdrawl(checking, 50)

Banking.transfer(savings, checking, 150)

Banking.balance(savings)
Banking.balance(checking)

```
