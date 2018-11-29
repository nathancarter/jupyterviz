
# Types of plots

The default plot type is "line", as you've been seeing in the
preceding examples.  You can also choose "bar", "column", "pie",
and others.  Let's use a pie chart to show the relative sizes of
the conjugacy classes in a group.

```
G := Group( (1,2,3,4,5,6,7), (1,2) );;
CCs := ConjugacyClasses( G );;
Plot(
    # for class labels, we'll use the first element in the class
    List( CCs, C -> PrintString( Set( C )[1] ) ),
    # for class sizes, we have to ask for the class as a set
    List( CCs, C -> Length( Set( C ) ) ),
    # ask for a pie chart with enough height to read the legend
    rec( type := "pie", height := 500 )
);
```

