
# Greater plot control with the low-level API

Let's say you have a plot that you're creating with the high-level
API, like the following one.

```
Plot( x -> x^0.5, rec( tool := "canvasjs" ) );
```

You can find out what kind of data is being passed, under the
hood, to the `CreateVisualization` function by running the
following code.

```
dataSeries := JUPVIZMakePlotDataSeries( x -> x^0.5 );;
big := ConvertDataSeriesForTool.canvasjs( [ dataSeries ] );
# yields:
# rec(
#     animationEnabled := true,
#     data := [
#         rec(
#             dataPoints := [
#                 rec( x := 1, y := 1 ),
#                 rec( x := 2, y := 1.4142135623730951 ),
#                 rec( x := 3, y := 1.7320508075688772 ),
#                 rec( x := 4, y := 2. ),
#                 rec( x := 5, y := 2.2360679774997898 )
#             ],
#             type := "line"
#         )
#     ],
#     height := 400
# )
```

That record is passed to `CreateVisualization` as follows.

```
CreateVisualization( rec( tool := "canvasjs", data := big ) );
```

If you wanted to change any of the internal options, such as the
default `animationEnabled := true` or the default `height := 400`,
you could alter the record yourself before passing it on to
`CreateVisualization`.

Such options may be specific to the tool you've chosen, and are
not guaranteed to work with other tools.  For example, you can't
change `"canvasjs"` to `"anychart"` and expect all the
`animationEnabled` setting to work.

If you had researched other options about CanvasJS and wanted to
include those, you could do so as well, as shown below.

```
big.animationEnabled := false;;     # changing an option
big.height := 500;;                 # changing an option
big.backgroundColor := "#F5DEB3";;  # adding an option
CreateVisualization( rec( tool := "canvasjs", data := big ) );
```

