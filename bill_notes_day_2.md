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