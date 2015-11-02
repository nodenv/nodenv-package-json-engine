# nodenv-package-json-engine

This is a plugin for [nodenv](https://github.com/OiNutter/nodenv)
that detects the node version based on the [engines](https://docs.npmjs.com/files/package.json#engines) field of the current tree's package.json.
before spawning Node processes.

It attempts to resolve complex [semver ranges](https://docs.npmjs.com/misc/semver#ranges) via the [semver.io](http://semver.io/) web service.  Simple versions, like "0.12.7", are resolved without a network request.

[![Travis](https://img.shields.io/travis/hurrymaplelad/nodenv-package-json-engine.svg?style=flat-square)](https://travis-ci.org/hurrymaplelad/nodenv-package-json-engine)

## Contributing

To run tests, install [bats](https://github.com/sstephenson/bats) and [nodenv](https://github.com/OiNutter/nodenv), then run `bats test`  in the base directory of this plugin

## Credits

Package.json inspection and Semver.io integration heavily inspired by nvmish[[1]](https://github.com/goodeggs/homebrew-delivery-eng/blob/master/nvmish.sh)[[2]](https://gist.github.com/assaf/ee377a186371e2e269a7).

Nodenv plugin hooks integration and tests heavily inspired by [rbenv-bundler-ruby-version](https://github.com/aripollak/rbenv-bundler-ruby-version).
