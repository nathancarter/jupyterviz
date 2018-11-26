############################################################################
##
#A  plot-interface.tst      JupyterViz Package           Nathan Carter
##
gap> START_TEST("JupyterViz package: plot-interface.tst");

# For now, we just load the plot-work.g file that we're using for temporary
# development, but later when it's part of the package, we'll load that
# instead.
gap> Read( "plot-work.g" );

##
# MakePlotDataSeries is supposed to support several input formats:
##

# 1. Lists of x and y values
gap> MakePlotDataSeries( [1,2,3], [4,5,6] );
rec( options := rec(), x := [1,2,3], y := [4,5,6] )

# 2. List of x values and a function f
gap> MakePlotDataSeries( [1,2,3], x -> x^2 );
rec( options := rec(), x := [1,2,3], y := [1,4,9] )

# 3. List of (x,y) pairs
gap> MakePlotDataSeries( [[1,6],[2,0.5],[3,-1]] );
rec( options := rec(), x := [1,2,3], y := [6,0.5,-1] )

# 4. List of y values (with indices used as x values).
gap> MakePlotDataSeries( [4/5,-0.99,123.456] );
rec( options := rec(), x := [1..3], y := [4/5,-0.99,123.456] )

# 5. A function (with small integers filled in for xs).
gap> MakePlotDataSeries( NrSmallGroups );
rec( options := rec(), x := [1,2,3,4,5], y := [1,1,1,2,1] )

##
# Data series are supposed to be able to be converted into the formats
# required by several different visualization tools:
##

gap> tmp := MakePlotDataSeries( NrSmallGroups );;
gap> ConvertDataSeriesForTool.plotly( [ tmp ] );
rec(
  data :=
    [
      rec( type := "line", x := [ 1, 2, 3, 4, 5 ],
          y := [ 1, 1, 1, 2, 1 ] ) ], layout := rec( height := 400 )
 )

gap> ConvertDataSeriesForTool.chartjs( [ tmp ] );
rec(
  data := rec( datasets := [ rec( data := [ 1, 1, 1, 2, 1 ] ) ],
      labels := [ 1, 2, 3, 4, 5 ] ), options := rec(  ),
  type := "line" )

gap> ConvertDataSeriesForTool.canvasjs( [ tmp ] );
rec( animationEnabled := true,
  data :=
    [
      rec(
          dataPoints :=
            [ rec( x := 1, y := 1 ), rec( x := 2, y := 1 ),
              rec( x := 3, y := 1 ), rec( x := 4, y := 2 ),
              rec( x := 5, y := 1 ) ], type := "line" ) ],
  height := 400 )

gap> ConvertDataSeriesForTool.anychart( [ tmp ] );
rec(
  chart := rec( legend := rec( position := "top" ),
      series :=
        [
          rec(
              data :=
                [ rec( value := 1, x := 1 ),
                  rec( value := 1, x := 2 ),
                  rec( value := 1, x := 3 ),
                  rec( value := 2, x := 4 ),
                  rec( value := 1, x := 5 ) ], seriesType := "line"
             ) ], type := "line" ) )

## Each test file should finish with the call of STOP_TEST.
## The first argument of STOP_TEST should be the name of the test file.
## The second argument is redundant and is used for backwards compatibility.
gap> STOP_TEST( "plot-interface.tst", 10000 );

############################################################################
##
#E
