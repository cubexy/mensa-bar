# Adding new releases

## Creating the release

> Release and tag names follow Semantic Versioning guidelines: [click](https://semver.org/)

To add a new release, open the project folder inside a terminal and add a new Git tag:

`git tag -a "1.2.3" -m "1.2.3"`

After adding the tag, push the relevant code from the selected branch (example code is for main) to it:

`git push origin 1.2.3`

Now go to the Git releases page and create a release from the tag.

## Adding the relevant binaries

The last step is adding the built `.app` file to the release. (_Note that this step is written specifically for Xcode - if you use any other tools to develop, you may need to do this differently._)

1. Go into the "Products" folder and delete the currently saved binary.
2. Re-start a build process. The binary will be recreated.
3. Upload the binary to the release.
