
# Drawing a better graph

We can improve the previous example by removing the edges from
each subgroup to itself.  We do so by redefining our edge relation
to exclude nonproper inclusions.

We can improve it further by making the edges directed and the
layout try to respect the graph's structure.  We do so by passing
a third argument to `PlotGraph`, a record of options.

```
G := Group( (1,2,3), (1,2) );
S := function ( H, G )
    return IsSubgroup( G, H ) and H <> G;
end;
PlotGraph(
    AllSubgroups( G ), S,
    rec( directed := true, layout := "grid" )
);
```

