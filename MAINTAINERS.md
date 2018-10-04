
# How to maintain this package

## Doing a release

 1. Update the version number in `PackageInfo.g`.
 2. Do the three things below
    (which it's also OK to do individually).

## Creating a release

```sh
cd releases
./create-release.sh
cd ..
```

Optionally, commit and push changes.

## Rebuilding the documentation

```sh
gap makedoc.g
```

Optionally, commit and push changes.

## Updating the website

(Usually you update the documentation, then do this.)

```sh
cd gh-pages
cp -f ../PackageInfo.g ../README* .
cp -f ../doc/*.{css,js,html,txt,png} doc/
gap update.g
git add PackageInfo.g README* doc/ _data/package.yml
```

Typically commit and push so you see changes online.
If you do so, do it **in the `gh-pages` folder**, which pushes
to a `gh-pages` branch on GitHub, where the website is stored.

```sh
cd ..
```

