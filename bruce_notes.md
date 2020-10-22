# Class Notes for Bruce Tate

Do fun things; with big loud workerbees
Data functions tests; (with) boundaries, lifecycles, workers

## Elixir structure for predictable composition

constructor.(...) |> reducer(...) |> reducer(...) |> transformer

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

## Enum functions in console 

### Random guess: no repeats

```iex
iex(3)> (1..8) |> Enum.shuffle                              
[4, 8, 2, 3, 5, 6, 1, 7]
iex(4)> (1..8) |> Enum.shuffle |> Enum.take(4)
[7, 8, 5, 3]
```

### random guess: allow repeats

```iex
iex(5)> random_number = fn -> :random.uniform(8) end
#Function<21.126501267/0 in :erl_eval.expr/5>
iex(6)> Stream.repeatedly(random_number)
#Function<53.35876588/2 in Stream.repeatedly/1>
iex(7)> Stream.repeatedly(random_number) |> Enum.take(4)
[4, 6, 8, 5]
iex(8)> Stream.repeatedly(random_number) |> Enum.take(4)
[3, 5, 8, 6]
iex(9)> Stream.repeatedly(random_number) |> Enum.take(4)
[4, 5, 2, 2]
iex(10)> Stream.repeatedly(random_number) |> Enum.take(4)
[6, 2, 5, 2]
iex(11)> Stream.repeatedly(random_number) |> Enum.take(4)
[4, 4, 1, 5]
iex(12)> Stream.repeatedly(random_number) |> Enum.take(4)
[4, 4, 3, 1]
iex(13)> Stream.repeatedly(random_number) |> Enum.take(4)
[5, 8, 3, 2]
iex(14)> Stream.repeatedly(random_number) |> Enum.take(4)
[2, 1, 8, 7]
iex(15)> Stream.
Reducers         chunk_by/2       chunk_every/2    chunk_every/3    
chunk_every/4    chunk_while/4    concat/1         concat/2         
cycle/1          dedup/1          dedup_by/2       drop/2           
drop_every/2     drop_while/2     each/2           filter/2         
flat_map/2       intersperse/2    interval/1       into/2           
into/3           iterate/2        map/2            map_every/3      
reject/2         repeatedly/1     resource/3       run/1            
scan/2           scan/3           take/2           take_every/2     
take_while/2     timer/1          transform/3      transform/4      
unfold/2         uniq/1           uniq_by/2        with_index/1     
with_index/2     zip/1            zip/2            
iex(15)> stream_1 = random_number
#Function<21.126501267/0 in :erl_eval.expr/5>
iex(16)> stream_1 = Stream.repeatedly(random_number)
#Function<53.35876588/2 in Stream.repeatedly/1>
iex(17)> stream_2 = Stream.repeatedly(random_number)
#Function<53.35876588/2 in Stream.repeatedly/1>
iex(18)> stream_3 = Stream.zip(stream_1, stream_2)
#Function<68.35876588/2 in Stream.zip/1>
iex(19)> stream_3 |> Enum.take(3)
[{7, 3}, {3, 7}, {1, 1}]
iex(20)> stream_3 |> Enum.take(3)
[{1, 1}, {8, 5}, {5, 4}]
iex(21)> stream_3 |> Enum.take(3)
[{6, 8}, {8, 7}, {5, 3}]
iex(22)> stream_3 = Stream.zip(stream_1, stream_2) |> Stream.chunk_every(3) |> Stream.take(2)
#Stream<[
  enum: #Stream<[
    enum: #Function<68.35876588/2 in Stream.zip/1>,
    funs: [#Function<4.35876588/1 in Stream.chunk_while/4>]
  ]>,
  funs: [#Function<58.35876588/1 in Stream.take_after_guards/2>]
]>
iex(23)> stream_3 = Stream.zip(stream_1, stream_2) |> Stream.chunk_every(3) |> Enum.take(2)  
[[{6, 4}, {7, 1}, {4, 5}], [{6, 6}, {1, 3}, {5, 1}]]
```

### calculations for score

```iex
iex(24)> answer = [1, 2, 3, 4]
[1, 2, 3, 4]
iex(25)> guess = [5, 7, 3, 2]
[5, 7, 3, 2]
iex(26)> answer |> Enum.zip(guess)
[{1, 5}, {2, 7}, {3, 3}, {4, 2}]
iex(27)> answer |> Enum.zip(guess) |> Enum.
EmptyError           OutOfBoundsError     all?/1               
all?/2               any?/1               any?/2               
at/2                 at/3                 chunk_by/2           
chunk_every/2        chunk_every/3        chunk_every/4        
chunk_while/4        concat/1             concat/2             
count/1              count/2              dedup/1              
dedup_by/2           drop/2               drop_every/2         
drop_while/2         each/2               empty?/1             
fetch!/2             fetch/2              filter/2             
find/2               find/3               find_index/2         
find_value/2         find_value/3         flat_map/2           
flat_map_reduce/3    frequencies/1        frequencies_by/2     
group_by/2           group_by/3           intersperse/2        
into/2               into/3               join/1               
join/2               map/2                map_every/3          
map_intersperse/3    map_join/2           map_join/3           
map_reduce/3         max/1                max/3                
max_by/2             max_by/4             member?/2            
min/1                min/3                min_by/2             
min_by/4             min_max/1            min_max/2            
min_max_by/2         min_max_by/3         random/1             
reduce/2             reduce/3             reduce_while/3       
reject/2             reverse/1            reverse/2            
reverse_slice/3      scan/2               scan/3               
shuffle/1            slice/2              slice/3              
sort/1               sort/2               sort_by/2            
sort_by/3            split/2              split_while/2        
split_with/2         sum/1                take/2               
take_every/2         take_random/2        take_while/2         
to_list/1            uniq/1               uniq_by/2            
unzip/1              with_index/1         with_index/2         
zip/1                zip/2                
iex(27)> answer |> Enum.zip(guess) |> Enum.filter(fn {x, y} -> x == y end)
[{3, 3}]
iex(28)> answer |> Enum.zip(guess) |> Enum.filter(fn {x, y} -> x == y end) |> Enum.co  
concat/1    concat/2    count/1     count/2     
iex(28)> answer |> Enum.zip(guess) |> Enum.filter(fn {x, y} -> x == y end) |> Enum.count
1
iex(29)> answer |> Enum.zip(guess) |> Enum.count(fn {x, y} -> x == y end)               
1
iex(30)> correct = answer |> Enum.zip(guess) |> Enum.count(fn {x, y} -> x == y end)    
1
iex(31)> size = Enum.count(answer)
4
iex(32)> misses = (guess -- answer)
[5, 7]
iex(33)> misses = (guess -- answer) |> Enum.size
** (UndefinedFunctionError) function Enum.size/1 is undefined or private. Did you mean one of:

      * slice/2
      * slice/3

    (elixir 1.10.3) Enum.size([5, 7])
iex(33)> misses = (guess -- answer) |> Enum.count
2
iex(34)> answer
[1, 2, 3, 4]
iex(35)> guess
[5, 7, 3, 2]
iex(36)> misses = (guess -- answer) |> Enum.count
2
iex(37)> size - reds - misses
** (CompileError) iex:37: undefined function reds/0
    (stdlib 3.12) lists.erl:1354: :lists.mapfoldl/3
    (stdlib 3.12) lists.erl:1355: :lists.mapfoldl/3
    (stdlib 3.12) lists.erl:1354: :lists.mapfoldl/3
iex(37)> right_color_wrong_slot = size - correct - misses
1
iex(38)> size
4
iex(39)> answer 
[1, 2, 3, 4]
iex(40)> guess 
[5, 7, 3, 2]
iex(41)> size  
4
iex(42)> misses
2
```


## property based test idea

```
iex(1)> reds = 3
3
iex(2)> Stream.repeatedly(fn -> 'R' end) |> Enum.take(reds)
['R', 'R', 'R']
iex(3)> Stream.repeatedly(fn -> ?R end) |> Enum.take(reds) 
'RRR'
iex(4)> Stream.repeatedly(fn -> ?R end) |> Enum.take(reds) |> to_string 
"RRR"
iex(5)> "RRR" == 'RRR'
false
iex(6)> is_list 'RRR'
true
iex(7)> is_list "RRR"
false
iex(8)> "RRR"
"RRR"
iex(9)> i
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
iex(10)> [?c]
'c'
iex(11)> [?b|[?c]]
'bc'
iex(12)> [?a|[?b|[?c]]]
'abc'
iex(13)> <<1, 2, 3>>
<<1, 2, 3>>
iex(14)> <<?d, ?o, ?g>>
"dog"
iex(15)> is_binary "dog"
true
iex(16)> is_binary 'dog'
false
iex(17)> make_score = fn -> 1..8 |> Enum.shuffle |> Enum.take(4) end
#Function<21.126501267/0 in :erl_eval.expr/5>
iex(18)> make_score.()
[5, 2, 8, 4]
iex(19)> make_score.()
[1, 6, 5, 3]
iex(20)> scores = Stream.repeatedly(make_score) |> Enum.take(5)
[[1, 6, 3, 2], [3, 7, 4, 6], [6, 5, 2, 4], [6, 5, 7, 8], [8, 5, 7, 3]]
iex(21)> make_answer = fn -> 1..8 |> Enum.shuffle |> Enum.take(4) end
#Function<21.126501267/0 in :erl_eval.expr/5>
iex(22)> answers = Stream.repeatedly(make_answer) |> Enum.take(5)    
[[5, 6, 1, 8], [3, 4, 1, 6], [5, 3, 4, 6], [6, 3, 5, 2], [3, 8, 4, 5]]
iex(23)> valid_answer = fn answer -> length(answer) == length(uniq(answer)) end
** (CompileError) iex:23: undefined function uniq/1
    (stdlib 3.12) lists.erl:1354: :lists.mapfoldl/3
    (stdlib 3.12) lists.erl:1354: :lists.mapfoldl/3
    (stdlib 3.12) lists.erl:1355: :lists.mapfoldl/3
iex(23)> valid_answer = fn answer -> length(answer) == length(Enum.uniq(answer)) end
#Function<7.126501267/1 in :erl_eval.expr/5>
iex(24)> Enum.all?(answers, valid_answer)
true
iex(25)> answers = Stream.repeatedly(make_answer) |> Enum.take(1000)                
[
  [8, 4, 7, 1],
  [5, 2, 8, 4],
  [8, 4, 6, 3],
  [7, 3, 2, 1],
  [6, 2, 3, 7],
  [4, 1, 5, 6],
  [1, 6, 5, 2],
  [6, 7, 4, 3],
  [5, 7, 6, 2],
  [6, 7, 8, 4],
  [4, 2, 1, 5],
  [7, 8, 1, 4],
  [6, 3, 8, 1],
  [1, 4, 8, 7],
  [2, 7, 3, 4],
  [6, 2, 8, 1],
  [2, 4, 8, 5],
  [3, 5, 6, 8],
  [6, 8, 1, 7],
  [3, 5, 1, 6],
  [7, 4, 1, 8],
  [5, 8, 2, 3],
  [8, 5, 3, 6],
  [1, 3, 4, 6],
  [6, 8, 5, 2],
  [2, 3, 1, 5],
  [5, 1, 2, 7],
  [8, 5, 4, 3],
  [4, 3, 6, 8],
  [8, 3, 7, 6],
  [1, 6, 5, 2],
  [2, 5, 3, 8],
  [3, 4, 1, 5],
  [3, 2, 5, 6],
  [8, 3, 1, 7],
  [2, 5, 4, 7],
  [2, 8, 7, 3],
  [1, 3, 6, 2],
  [1, 3, 4, 5],
  [4, 8, 7, 5],
  [8, 3, 5, 6],
  [4, 5, 1, 2],
  [5, 1, 6, 8],
  [8, 4, 2, 5],
  [7, 2, 6, 8],
  [1, 2, 5, 7],
  [5, 1, 3, ...],
  [8, 3, ...],
  [6, ...],
  [...],
  ...
]
iex(26)> Enum.all?(answers, valid_answer)                           
true
```