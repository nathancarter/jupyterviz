
# Two data series on the same plot

Let's combine the previous two examples (regardless of whether
that's mathematically useful).  Let's pretend you wanted to
compare the number of divisors of $n$ with the number of groups of
order $n$ for the first 50 positive integers $n$.

To do so, take each call you would make to `Plot` to make the
separate plots, and place those arguments in a list.  Pass both
lists to `Plot` to combine the plots, as shown below.  You can put
the options record in either list.  Options specified earlier take
precedence if there's a conflict.

```
# We're combining Plot( [1..50], NrSmallGroups );
# with Plot( [1..50], n -> Length( DivisorsInt( n ) ) );
Plot( [ [1..50], NrSmallGroups,
        rec( title := "Comparison", tool := "anychart" ) ],
      [ [1..50], n -> Length( DivisorsInt( n ) ) ] );
```

