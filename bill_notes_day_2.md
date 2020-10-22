# Day 2: Notes by Bill Tihen

## Round 1: Supervisor and Children

Supervisor.start_link - start with a name in registry (so we don't need the pid)
update start_link with the name of the module in: adderall/lib/adderall/boundary/server.ex:27
```
def start_link(count), do: GenServer.start_link(__MODULE, count, name: __MODULE__)
def increment(counter \\ __MODULE__), do: GenServer.cast(counter, :inc)
```

```
iex -S mix
alias Adderall.Boundary.Server

Server.start_link(42)
Server.increment(Server)
Server.get(Server)

# this def increment(counter \\ __MODULE__), do: GenServer.cast(counter, :inc)
# allows the server name to be known

Server.start_link(42)
Server.increment
Server.get
```

This is just limited to ONE prcess since all are named after the server


## Round 2: Start coding mindmaster - the game

```
mkdir -p lib/mindex/core
touch lib/mindex/core/board.ex
touch lib/mindex/core/score.ex
```

create structs, constructors, and converters (outputs) - make the API (to code together)


## Round 3: Create a first round of code

**Original Code (score)**

```
defmodule Mindex.Core.Score do
  defstruct red: 0, white: 0, guess: [], answer: []

  def new(guess \\ [1, 3, 5, 8], answer \\ [1, 2, 3, 4]) do  # add guard to ensure guess and answer have 4 integers each (in the range of 1..8)
    %__MODULE__{guess: guess, answer: answer}
  end

  def render_string(score) do
    score
      |> update_red_score()
      |> update_white_score()
  end

  def update_red_score(score) do
    red_count = count_red(score)
    %{ score | red: red_count }
  end

  def update_white_score(score) do
    white_count = count_white(score)
    %{ score | white: white_count }
  end

  def count_red(score) do
    score.guess
      |> Enum.zip(score.answer)   # [{1, 1}, {3, 2}, {5, 3}, {8, 4}]
      |> Enum.count(fn {x, y} -> x == y end)
  end

  def count_white(score) do
    size_count = Enum.count(score.answer)      # 5 & 8 are not in the aswer (1 is correct & 3 wrong place)
    miss_count = (score.guess -- score.answer) # [5, 8] = [1, 3, 5, 8] -- [1, 2, 3, 4]
                |> Enum.count
    red_count  = count_red(score)              # if we use count_red then order is unimportant

    size_count - red_count - miss_count
  end
end
```

**Refactoring Ideas**

* Do not use structs in the Boundary layer - otherwise, every change - creates a lot of other changes in client and server
* Don't have more than absolutely needed in the core struct, if it won't change do calculations in the constructor!

Stream usage to create output
```
> Stream.repeatedly(fn -> 'R' end) |> Enum.take(3)
['R', 'R', 'R']

> Stream.repeatedly(fn -> ?R end) |> Enum.take(3)
'RRR'

> Stream.repeatedly(fn -> ?R end) |> Enum.take(3) |> to_string
"RRR"
```

**Refactored Code**
```
defmodule Mindex.Core.Score do
  defstruct red: 0, white: 0

  def new(guess, answer) do
    input = %{guess: guess, answer: answer}

    %__MODULE__{red: count_red(input), white: count_white(input)}
  end

  def render_string(score) do
    reds   = Stream.repeatedly(fn -> ?R end) |> Enum.take(score.red)   |> to_string()
    whites = Stream.repeatedly(fn -> ?W end) |> Enum.take(score.white) |> to_string()

    "#{reds}#{whites}"
  end

  defp count_red(input) do
    input.guess
      |> Enum.zip(input.answer)               # [{1, 1}, {3, 2}, {5, 3}, {8, 4}]
      |> Enum.count(fn {x, y} -> x == y end)
  end

  defp count_white(input) do
    size_count = Enum.count(input.answer)      # 5 & 8 are not in the aswer (1 is correct & 3 wrong place)
    miss_count = (input.guess -- input.answer) # [5, 8] = [1, 3, 5, 8] -- [1, 2, 3, 4]
                |> Enum.count
    red_count  = count_red(input)              # if we use count_red then order is unimportant

    size_count - red_count - miss_count
  end
end
```

**USAGE**
```
> alias Mindex.Core.Score

> score = Score.new([1,2,3,4], [1,3,4,7])
%Mindex.Core.Score{red: 1, white: 2}

> Score.render_string(score)
"RWW"
```

**Streams - Lists - Propertly Based Testing**

_Lists & Characters_
```
> is_list 'RRR'
true

> is_list "RRR"
false

> "RRR"
"RRR"

# get the info about the last value
> i
Term
  "RRR"
Data type
  BitString
Byte size
  3
Description
  This is a string: a UTF-8 encoded binary. It's printed surrounded by
  "double quotes" because all UTF-8 encoded code points in it are printable.
Raw representation
  <<82, 82, 82>>
Reference modules
  String, :binary
Implemented protocols
  Collectable, IEx.Info, Inspect, List.Chars, String.Chars
```

_How lists works_

* The | in the context of the list is a link to the stuff behind - normal output is just a pretty output
* Adding to the front of a list is MUCH faster than adding to the end (just one link to build)
```
> [?c]
'c'

> [?b|[?c]]
'bc'

> [?a|[?b|[?c]]]
'abc'

> <<1, 2, 3>>
<<1, 2, 3>>

> <<?d, ?o, ?g>>
"dog"

> is_binary "dog"
true

> is_binary 'dog'
false
```

_Building property generators_
```
> make_score = fn -> 1..8 |> Enum.shuffle |> Enum.take(4) end
#Function<21.126501267/0 in :erl_eval.expr/5>

> make_score.()
[5, 2, 8, 4]

> make_score.()
[1, 6, 5, 3]

> scores = Stream.repeatedly(make_score) |> Enum.take(5)
[[1, 6, 3, 2], [3, 7, 4, 6], [6, 5, 2, 4], [6, 5, 7, 8], [8, 5, 7, 3]]

> make_answer = fn -> 1..8 |> Enum.shuffle |> Enum.take(4) end
#Function<21.126501267/0 in :erl_eval.expr/5>

> answers = Stream.repeatedly(make_answer) |> Enum.take(5)
[[5, 6, 1, 8], [3, 4, 1, 6], [5, 3, 4, 6], [6, 3, 5, 2], [3, 8, 4, 5]]

> valid_answer = fn answer -> length(answer) == length(Enum.uniq(answer)) end
#Function<7.126501267/1 in :erl_eval.expr/5>

> Enum.all?(answers, valid_answer)
true

> answers = Stream.repeatedly(make_answer) |> Enum.take(1000)
[
  [8, 4, 7, 1],
  ...
  [1, 2, 5, 7],
  [5, 1, 3, ...],
  [8, 3, ...],
  [6, ...],
  [...],
  ...
]
iex(26)> Enum.all?(answers, valid_answer)
```

## Round 4: 

**PROPERTY BASED TESTING**
