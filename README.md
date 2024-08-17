# ryzenadj-deb

Adjust power management settings for Ryzen APUs - debian packaging for Ubuntu PPA

The original upstream package is <https://github.com/FlyGoat/RyzenAdj>

My fork tracks upstream, and adds the debian packaging files: <https://github.com/queenkjuul/RyzenAdj>

This repo is basically just a workspace to house the generated debian source package and the scripts to upload files to the PPA

The `ryzenadj` package built using this repo is available from [`ppa:queenkjuul/ryzen-tools`](https://launchpad.net/~queenkjuul/+archive/ubuntu/ryzen-tools)

## Process

[planned] Order of operations:

_I would like to automate this via GitHub Actions, but might not ever get around to it. This explains how to build the package, though. Upstream development seems slow, so maybe there will not be another release anyway_

1. this repo runs a recurring action that checks for a new upstream RyzenAdj release
2. When a new RyzenAdj release is found, it:
   1. Checks out a new branch in this repo for the new release tag `vX.Y.Z`
   2. Checks out the `queenkjuul/RyzenAdj/upstream` branch in `ryzenadj-orig`
      1. pulls upstream changes
      2. checks out new release tag --> will my fork receive upstream tags? hope so
      3. commits new release tag to `upstream` branch
      4. pushes upstream changes
   3. Removes current `ryzenadj_X.Y.Z.orig.tar.xz`
   4. runs `dh_make --createorig ...` to make a new `ryzenadj_X.Y.Z.orig.tar.xz`
   5. Creates a new release branch from `queenkjuul/RyzenAdj/master` at `queenkjuul/RyzenAdj/vX.Y.Z`
   6. Merges `upstream` into the release branch `vX.Y.Z`, if there are merge conflicts, it opens a PR against `queenkjuul/RyzenAdj/master` and stops here (there should not be merge conflicts, we should only be adding new files)
      1. If merge succeeds, it adds debian changelog entry for new version and commits it to the release branch
      2. Checks out `upstream`
      3. Runs debian package build. If it fails, open a PR against `master` and stops here (time for manual intervention)
         1. if `ryzenadj-deb` builds successfully, it commits the build output, merges new release into `main`, and creates a new release tag to match upstream
         2. pull changes to `queenkjuul/RyzenAdj/master` in `ryzenadj-deb/ryzenadj-orig`
         3. checks out `upstream` branch
         4. checks out the new `master` release tag