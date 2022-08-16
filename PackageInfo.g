#############################################################################
##
##  PackageInfo.g for the package `JupyterViz'               Nathan Carter
##  (copied and edited from the Example package)
##
##  This file contains meta-information on the package. It is used by
##  the package loading mechanism and the upgrade mechanism for the
##  redistribution of the package via the GAP website.
##
##  For the LoadPackage mechanism in GAP >= 4.5 the minimal set of needed
##  entries is .PackageName, .Version, and .AvailabilityTest, and an error
##  will occur if any of them is missing. Other important entries are
##  .PackageDoc and .Dependencies. The other entries are relevant if the
##  package will be distributed for other GAP users, in particular if it
##  will be redistributed via the GAP Website.
##
##  With a new release of the package at least the entries .Version, .Date
##  and .ArchiveURL must be updated.

SetPackageInfo( rec(


#########
#
#  Name and version
#
#########

PackageName := "JupyterViz",
Subtitle    := "Visualization Tools for Jupyter and the GAP REPL",
Version     := "1.5.6",
Date        := "16/08/2022", # Release date of current version, dd/mm/yyyy
License     := "GPL-2.0-or-later",


#########
#
#  Topic and dependencies
#
#########

##  Status information. Currently the following cases are recognized:
##    "accepted"      for successfully refereed packages
##    "submitted"     for packages submitted for the refereeing
##    "deposited"     for packages for which the GAP developers agreed
##                    to distribute them with the core GAP system
##    "dev"           for development versions of packages
##    "other"         for all other packages
Status := "deposited",
##  If this package is refereed and accepted, you must provide:
# CommunicatedBy := "Person Name (Place Name)",
# AcceptDate := "mm/yyyy",

Keywords := [
  "Jupyter Notebook", "visualization", "graph", "plot", "chart", "HTML", "JavaScript"
],

Dependencies := rec(
  GAP := ">= 4.9",
  NeededOtherPackages := [
    [ "json",          "2.0.0"   ],
    [ "GAPDoc",        "1.3"     ]
  ],
  SuggestedOtherPackages := [ ]
),


#########
#
#  URLs
#
#########

PackageWWWHome   := Concatenation( "https://nathancarter.github.io/",
                                   LowercaseString( ~.PackageName ) ),
##  Later, if this becomes part of GAP, use:
##  Concatenation( "https://gap-packages.github.io/", LowercaseString( ~.PackageName ) ),
SourceRepository := rec( Type := "git",
                         URL  := Concatenation( "https://github.com/nathancarter/",
                                                LowercaseString( ~.PackageName ) ) ),
IssueTrackerURL  := Concatenation( ~.SourceRepository.URL, "/issues" ),
SupportEmail     := "ncarter@bentley.edu",
README_URL       := Concatenation( ~.PackageWWWHome, "/README.md" ),
PackageInfoURL   := Concatenation( ~.PackageWWWHome, "/PackageInfo.g" ),

##  URL of the archive(s) of the current package release, but *without*
##  the format extension(s), like '.tar.gz' or '-win.zip', which are given next.
##  The archive file name *must be changed* with each version of the archive
##  (and probably somehow contain the package name and version).
##  The paths of the files in the archive must begin with the name of the
##  directory containing the package (in our "example" probably:
##  example/init.g, ...    or example-3.3/init.g, ...  )
ArchiveURL := Concatenation( ~.SourceRepository.URL,
                             "/releases/download/v", ~.Version, "/",
                             LowercaseString( ~.PackageName ), "-", ~.Version ),
ArchiveFormats := ".tar.gz",


#########
#
#  Contact info
#
#########

Persons := [
  rec(
    FirstNames    := "Nathan",
    LastName      := "Carter",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "ncarter@bentley.edu",
    WWWHome       := "http://nathancarter.github.io",
    PostalAddress := Concatenation( [
                       "175 Forest St.\n",
                       "Waltham, MA  02452\n",
                       "USA" ] ),
    Place         := "Waltham",
    Institution   := "Bentley University"
  )
],


#########
#
#  Documentation
#
#########

##  Provide a short (up to a few lines) abstract in HTML format, explaining
##  the package content. This text will be displayed on the package overview
##  Web page. Please use '<span class="pkgname">GAP</span>' for GAP and
##  '<span class="pkgname">MyPKG</span>' for specifing package names.
##
# AbstractHTML := "This package provides  a collection of functions for \
# computing the Smith normal form of integer matrices and some related \
# utilities.",
AbstractHTML :=
  "The <span class=\"pkgname\">JupyterViz</span> package \
   adds visualization tools for use in Jupyter Notebooks \
   or from the GAP REPL.  Those tools can be used to make \
   charts, graphs, and arbitrary other visualizations.",

PackageDoc := rec(
  BookName  := "JupyterViz",
  ArchiveURLSubset := [ "doc" ],
  HTMLStart := "doc/chap0_mj.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Visualization Tools for Jupyter and the GAP REPL",
),


#########
#
#  Tests
#
#########

##  Provide a test function for the availability of this package.
##  For packages containing nothing but GAP code, just say 'ReturnTrue' here.
##  With the package loading mechanism of GAP >=4.4, the availability
##  tests of other packages, as given under .Dependencies above, will be
##  done automatically and need not be included in this function.
##
AvailabilityTest := ReturnTrue,
TestFile := "tst/testall.g"

) );
