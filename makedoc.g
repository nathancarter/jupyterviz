
# Documentation build script using AutoDoc

LoadPackage( "AutoDoc" );
AutoDoc(
    rec(
        scaffold := rec(
            gapdoc_latex_options := rec(
                EarlyExtraPreamble := "\\usepackage[pdftex]{graphicx}"
            )
        ),
        autodoc := true
    )
);
QUIT;
