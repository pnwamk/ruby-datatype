# ruby-datatype
An experiment in playing with "ADTs" in Ruby

Since even ruby's metaprogramming tools are entirely dynamic, what you can do is define a set of procedures such that when given something like this:

```ruby
define_adt("Expr",
          [["Var", [:id]],
           ["Lambda", [:id, :body]]
           ["App", [:rator, :rand]]])
```           
           
You generate a parent class (Expr) and three classes that inherit
from it (Var, Lambda, App) with the specified fields. You can use
all of the various Ruby runtime/class hooks to make those classes
"final" more or less. This sort of gives you an ADT like structure.

Unfortunately (as far as I have been able to find), it's not really reasonable/idiomatic
in Ruby to design a match/case-like statement that *statically requires* a case for each
variant. So, your left to a more traditional dynamic destructuring. Luckily, there are some
cool metaprogramming extensions that have been done out there (thanks @chriswailes) so you
can still get a nice match + destructuring (in fact this experiment depends on @chriswailes
match -- the created classes extend and implement a 'destructurable' method that allows
them to be beautifully destructured within the match statements his library provides).

Here is an example using the previously discussed match:

```ruby
def get_id(expr)
  match expr dp
    with(Var.(x) {x}
    with(Lambda.(x, body) {x}
    with(App.(rator, rand) {get_id(rator) || get_id(rand)}
    with(_){false}
  end
end
```
