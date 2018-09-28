#!/bin/bash

MINIFIER="uglifyjs"

# If we have the necessary command, proceed.
if command -v $MINIFIER; then

    # loop through all .js files in this folder
    for FILE in `ls *.js`
    do
        # If it's already a .min.js file, skip it.
        if [[ $FILE = *".min.js" ]]; then
            echo "Ignoring:  $FILE"
        # Otherwise, extract base & extension, then minify.
        else
            echo "Minifying: $FILE"
            EXT="${FILE##*.}"
            START="${FILE%.*}"
            $MINIFIER $FILE > $START.min.$EXT
        fi
    done

else
# We did not have the necessary command, so quit.

    echo "No $MINIFIER command in your path.  Cannot proceed."

fi

