# Class Notes for Bruce Tate

## Console work

```iex
iex(1)> constructor = fn -> 42 end
#Function<21.126501267/0 in :erl_eval.expr/5>
iex(2)> reducer = fn acc, i -> acc + i end
#Function<13.126501267/2 in :erl_eval.expr/5>
iex(3)> converter = fn acc -> "#{acc}" end     
#Function<7.126501267/1 in :erl_eval.expr/5>
iex(4)> Enum.reduce(1..3, constructor.(), reducer)
48
iex(5)> constructor.() |> reducer.(1) |> reducer.(1) |> reducer.(-1) |> converter.()
"43"
iex(6)> inc = fn acc -> acc + 1 end
#Function<7.126501267/1 in :erl_eval.expr/5>
iex(7)> inc = fn acc, _ -> acc + 1 end
#Function<13.126501267/2 in :erl_eval.expr/5>
iex(8)> listener = fn -> receive do m -> m end end
#Function<21.126501267/0 in :erl_eval.expr/5>
iex(9)> send self, :ola
:ola
iex(10)> listener.()
:ola
iex(11)>
```


## Notes about back pressure

