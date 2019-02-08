############################################################################
##
#A  high-level-api.tst      JupyterViz Package           Nathan Carter
##
gap> START_TEST("JupyterViz package: high-level-api.tst");

##
# JUPVIZMakePlotDataSeries is supposed to support several input formats:
##

# 1. Lists of x and y values
gap> JUPVIZMakePlotDataSeries( [1,2,3], [4,5,6] );
rec( options := rec(), x := [1,2,3], y := [4,5,6] )

# 2. List of x values and a function f
gap> JUPVIZMakePlotDataSeries( [1,2,3], x -> x^2 );
rec( options := rec(), x := [1,2,3], y := [1,4,9] )

# 3. List of (x,y) pairs
gap> JUPVIZMakePlotDataSeries( [[1,6],[2,0.5],[3,-1]] );
rec( options := rec(), x := [1,2,3], y := [6,0.5,-1] )

# 4. List of y values (with indices used as x values).
gap> JUPVIZMakePlotDataSeries( [4/5,-0.99,123.456] );
rec( options := rec(), x := [1..3], y := [4/5,-0.99,123.456] )

# 5. A function (with small integers filled in for xs).
gap> JUPVIZMakePlotDataSeries( NrSmallGroups );
rec( options := rec(), x := [1,2,3,4,5], y := [1,1,1,2,1] )

##
# Data series are supposed to be able to be converted into the formats
# required by different visualization tools:
##

gap> tmp := JUPVIZMakePlotDataSeries( NrSmallGroups );;
gap> ConvertDataSeriesForTool.plotly( [ tmp ] );
rec(
  data := [
    rec(
      type := "line",
      x := [ 1, 2, 3, 4, 5 ],
      y := [ 1, 1, 1, 2, 1 ]
    )
  ],
  layout := rec( height := 400 )
)

gap> ConvertDataSeriesForTool.chartjs( [ tmp ] );
rec(
  data := rec(
    datasets := [ rec( data := [ 1, 1, 1, 2, 1 ] ) ],
    labels := [ 1, 2, 3, 4, 5 ]
  ),
  options := rec(  ),
  type := "line"
)

gap> ConvertDataSeriesForTool.canvasjs( [ tmp ] );
rec(
  animationEnabled := true,
  data := [
    rec(
      dataPoints := [
        rec( x := 1, y := 1 ),
        rec( x := 2, y := 1 ),
        rec( x := 3, y := 1 ),
        rec( x := 4, y := 2 ),
        rec( x := 5, y := 1 )
      ],
      type := "line"
    )
  ],
  height := 400
)

gap> ConvertDataSeriesForTool.anychart( [ tmp ] );
rec(
  chart := rec(
    legend := rec( position := "top" ),
    series := [
      rec(
        data := [
          rec( value := 1, x := 1 ),
          rec( value := 1, x := 2 ),
          rec( value := 1, x := 3 ),
          rec( value := 2, x := 4 ),
          rec( value := 1, x := 5 )
        ],
        seriesType := "line"
      )
    ],
    type := "line"
  )
)

gap> tmp.options := rec( type := "bar" );;
gap> ConvertDataSeriesForTool.plotly( [ tmp ] );
rec(
  data := [
    rec(
      type := "bar",
      x := [ 1, 2, 3, 4, 5 ],
      y := [ 1, 1, 1, 2, 1 ]
    )
  ],
  layout := rec( height := 400 )
)

gap> tmp.options := rec( title := "Hello" );;
gap> ConvertDataSeriesForTool.chartjs( [ tmp ] );
rec(
  data := rec(
    datasets := [ rec( data := [ 1, 1, 1, 2, 1 ] ) ],
    labels := [ 1, 2, 3, 4, 5 ]
  ),
  options := rec( title := rec( display := true, text := "Hello" ) ),
  type := "line"
)

gap> tmp.options := rec( xaxis := "numbers", yaxis := "more nums" );;
gap> ConvertDataSeriesForTool.canvasjs( [ tmp ] );
rec(
  animationEnabled := true,
  axisX := rec( title := "numbers" ),
  axisY := rec( title := "more nums" ),
  data := [
    rec(
      dataPoints := [
        rec( x := 1, y := 1 ),
        rec( x := 2, y := 1 ),
        rec( x := 3, y := 1 ),
        rec( x := 4, y := 2 ),
        rec( x := 5, y := 1 )
      ],
      type := "line"
    )
  ],
  height := 400
)

gap> tmp.options := rec( height := 234, width := 345 );;
gap> ConvertDataSeriesForTool.anychart( [ tmp ] );
rec(
  chart := rec(
    legend := rec( position := "top" ),
    series := [
      rec(
        data := [
          rec( value := 1, x := 1 ),
          rec( value := 1, x := 2 ),
          rec( value := 1, x := 3 ),
          rec( value := 2, x := 4 ),
          rec( value := 1, x := 5 )
        ],
        seriesType := "line"
      )
    ],
    type := "line"
  ),
  height := 234,
  width := 345
)

##
# JUPVIZMakePlotGraphRecord is supposed to support several input formats:
##

gap> JUPVIZMakePlotGraphRecord( [ [ 1, 2 ], [ 2, 3 ], [ 3, 4 ] ] );
rec(
  edges := [ [ 1, 2 ], [ 2, 3 ], [ 3, 4 ] ],
  options := rec( ),
  vertices := [ 1, 2, 3, 4 ]
)

gap> JUPVIZMakePlotGraphRecord( [ "a", "b", "c"], [ [ "a", "b" ] ] );
rec(
  edges := [ [ "a", "b" ] ],
  options := rec(),
  vertices := ["a","b","c"]
)

gap> JUPVIZMakePlotGraphRecord( [ [1,1,1],[1,0,0],[0,1,0] ] );
rec(
  edges := [[1,1],[1,2],[1,3],[2,1],[3,2]],
  options := rec(),
  vertices := [1..3]
)

gap> JUPVIZMakePlotGraphRecord( [1..4], function (x,y) return x<y; end, rec(tool := "example") );
rec(
  edges := [[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]],
  options := rec( tool := "example" ),
  vertices := [1..4]
)

gap> tmp := JUPVIZMakePlotGraphRecord( [ [ 1, 2 ], [ 2, 3 ], [ 3, 4 ] ] );;
gap> ConvertGraphForTool.cytoscape( tmp );
rec(
  elements := [
    rec( data := rec( id := "1" ) ),
    rec( data := rec( id := "2" ) ),
    rec( data := rec( id := "3" ) ),
    rec( data := rec( id := "4" ) ),
    rec( data := rec( source := "1", target := "2" ) ),
    rec( data := rec( source := "2", target := "3" ) ),
    rec( data := rec( source := "3", target := "4" ) )
  ],
  layout := rec( name := "cose" ),
  style := [
    rec( selector := "node", style := rec( content := "data(id)" ) )
  ]
)

##
# Graphs are supposed to be able to be converted into the formats
# required by different visualization tools:
##

gap> tmp := JUPVIZMakePlotGraphRecord( [[1,0,1],[0,1,1],[1,0,0]] );;
gap> tmp.options := rec( layout := "circular", directed := true, arrowscale := 10 );;
gap> ConvertGraphForTool.cytoscape( tmp );
rec(
  elements := [
    rec( data := rec( id := "1" ) ),
    rec( data := rec( id := "2" ) ),
    rec( data := rec( id := "3" ) ),
    rec( data := rec( source := "1", target := "1" ) ),
    rec( data := rec( source := "1", target := "3" ) ),
    rec( data := rec( source := "2", target := "2" ) ),
    rec( data := rec( source := "2", target := "3" ) ),
    rec( data := rec( source := "3", target := "1" ) )
  ],
  layout := rec( name := "circular" ),
  style := [
    rec( selector := "node", style := rec( content := "data(id)" ) ),
    rec( selector := "edge", style := rec(
      ("arrow-scale") := 10,
      ("mid-target-arrow-shape") := "vee"
    ) )
  ]
)

## Each test file should finish with the call of STOP_TEST.
## The first argument of STOP_TEST should be the name of the test file.
## The second argument is redundant and is used for backwards compatibility.
gap> STOP_TEST( "high-level-api.tst", 10000 );

############################################################################
##
#E
