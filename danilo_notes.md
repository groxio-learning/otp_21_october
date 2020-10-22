## Notes for Danilo Lima

Build our own OTP Server

- Counter
- Add process machinery for OTP

Understand how OTP works

What to expect:

- three passes through OTP
- lot of breaks
- it's collaborative

## Supervisor

- Think of a life cycle
- It manages the life cycle of things, it knows how to stop, start, restart things etc

Do fun things with big loud worker bees

```elixir
constructor = fn -> 42 end
reducer = fn acc, i -> acc + i end
converter = fn acc -> "#{acc}" end
Enum.reduce(1..3, constructor.(), reducer)
constructor.() |> reducer.(1) |> reducer.(1) |> reducer.(-1) |> converter.()
```

### Boundaries

```elixir
listener = fn -> receive do m -> m end end
```

iex>

`h receive`

```
iex(3)> Service.start
#PID<0.185.0>
iex(4)> pid = v(3)
```

two dimensions to change values in memory

- execution time
- receive and send (cheat)

- recursion and function calling

# Supervisor

> "have you tried turning it off and on again?"

Supervisor must restart the processes with a known working state

Bruce talk about back pressure

[Railway programming reference](https://medium.com/elixirlabs/railway-oriented-programming-in-elixir-with-pattern-matching-on-function-level-and-pipelining-e53972cede98)

## Generating random numbers

### Unique numbers

```elixir
1..8 |> Enum.shuffle |> Enum.take(4)
```

### Repeated numbers

```elixir
random_number = fn -> :random.uniform(8) end
Stream.repeatedly(random_number)
Stream.repeatedly(random_number) |> Enum.take(4)
```

misses = (guess -- answer)

Core
Boundary
Client

No queries on the core, because that fails and it's not pipeable

# Day 2

Supervisor works as a registry.
It knows how to start and stop things, and their names.

How to decide the first function argument for piping?
Take a look at the main type of the core.
