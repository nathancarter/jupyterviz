
# Documentation build script using AutoDoc

if fail = LoadPackage("AutoDoc", ">= 2019.05.20") then
    Error("AutoDoc 2019.05.20 or newer is required");
fi;

AutoDoc(
    rec(
        scaffold := true,
        gapdoc := rec(
            LaTeXOptions := rec(
                EarlyExtraPreamble := "\\usepackage[pdftex]{graphicx}"
            )
        ),
        autodoc := true
    )
);
QUIT;
