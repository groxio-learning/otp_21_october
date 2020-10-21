
# Class Notes for Giorgio Torres


```bash
Erlang/OTP 22 [erts-10.6] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe]

Compiling 4 files (.ex)
Generated adderall app
Interactive Elixir (1.10.3) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> alias Adderall.                
Application    Boundary       Core           MixProject     hello/0        

iex(1)> alias Adderall.Boundary.Service
Adderall.Boundary.Service
iex(2)> h receive
=> # receive's help

iex(3)> Service.     
listen/1    run/1       start/0     start/1     
iex(3)> Service.start
#PID<0.185.0>
iex(4)> pid = v 3    # gets the value of iex's 3rd line
#PID<0.185.0>
iex(5)> Process.alive? pid
true
iex(6)> send pid, {:get, self}
{:get, #PID<0.181.0>}
iex(7)> flush # gets all messages of the mailbox
0
:ok
iex(8)> send pid, {:get, self}
{:get, #PID<0.181.0>}
iex(9)> receive do m -> IO.puts m end
0
:ok
iex(10)> send pid, {:get, self}       
{:get, #PID<0.181.0>}
iex(11)> send pid, {:get, self}
{:get, #PID<0.181.0>}
iex(12)> send pid, {:get, self}
{:get, #PID<0.181.0>}
iex(13)> flush
0
0
0
:ok
iex(14)> flush                 
:ok
iex(15)> send pid, :increment
:increment
iex(16)> send pid, {:get, self}
{:get, #PID<0.181.0>}
iex(17)> flush                 
1
:ok
iex(18)> send pid, :increment
:increment
iex(19)> flush
:ok
iex(20)>
```