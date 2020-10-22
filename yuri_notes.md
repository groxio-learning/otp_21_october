# Class Notes for Yuri Oliveira

Book: [Designing Elixir Systems with OTP](https://pragprog.com/titles/jgotp/designing-elixir-systems-with-otp/)

```
Do      -> Data       \
Fun     -> Functions   -> Core is a place for certainty
Things  -> Tests      /
With
Big     -> Boundaries             \
Loud    -> Lifecycles              -> Encapsulates uncertainty, protects the Core
Worker  -> Workers / Dependencies /
Bees
```

## On Data and Functions

* Constructors            -> initiate state (?)
* Reducers                -> takes an accumulator and returns the transformed accumulator (of the same type)
* Converters/Transformers

## On API

* Backpressure: slowing down the client requests to avoid overwhelming the server due to how fast it is to pass messages around

---

# Notes from OTP Module

## Tasks and Agents

* Agents tracks running state (GenServer)

```elixir
> {:ok, agent} = Agent.start_link(fn -> 0 end)
{:ok, #PID<0.128.0>}
iex(11)> Agent.get(agent, fn x -> x end)
0
iex(12)> Agent.get(agent, fn x -> x+1 end)
1
iex(14)> Agent.get(agent, & &1)
0
iex(15)> Agent.get(agent, & &1+1)
1
iex(18)> Agent.update(agent, &(&1+1))
:ok
```

### Tasks

* Are "run and forget", but can `await`
* You loose control
* Task.await/2 has a default timeout of 5000

```elixir
> long_work = fn -> Process.sleep(4000); 42 end

> task = Task.async(long_work)

> 1+ Task.await(task)

> Process.alive? task.pid
```


Do not use structs around the params and the boundary, don't expose internal data