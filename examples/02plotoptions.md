
# Adding an options parameter

You can append a final parameter to the `Plot` command, a record
containing a set of options.  Here is an example of using that
options record to choose the visualization tool, title, and axis
labels.

```
Plot( [1..50], n -> Length( DivisorsInt( n ) ),
      rec(
          tool := "chartjs",
          title := "Number of divisors of some small integers",
          xaxis := "n",
          yaxis := "number of divisors of n"
      ) );
```

