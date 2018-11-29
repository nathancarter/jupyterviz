
# Drawing a simple graph

Previous examples dealt with charting and plotting, but now we
transition into examples on graph drawing (with vertices and
edges).  Thus we begin using the `PlotGraph` function.

It can take a vertex set and relation, as shown below.

```
G := Group( (1,2,3), (1,2) );;
S := function ( H, G ) return IsSubgroup( G, H ); end;;
PlotGraph( AllSubgroups( G ), S );
```

As you can see below, this doesn't look as nice as we'd like, so
let's consider how to improve it in the next example.

