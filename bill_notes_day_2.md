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

mkdir 

## Round 3: 

Original Code (score)

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

**PROPERTY BASED TESTING**

