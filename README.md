# nodenv-package-json-engine

[![Latest GitHub Release](https://img.shields.io/github/v/release/nodenv/nodenv-package-json-engine?logo=github&sort=semver)](https://github.com/nodenv/nodenv-package-json-engine/releases/latest)
[![Latest npm Release](https://img.shields.io/npm/v/@nodenv/nodenv-package-json-engine)](https://www.npmjs.com/package/@nodenv/nodenv-package-json-engine/v/latest)
[![Test](https://img.shields.io/github/workflow/status/nodenv/nodenv-package-json-engine/Test?label=tests&logo=github)](https://github.com/nodenv/nodenv-package-json-engine/actions?query=workflow%3ATest)

This is a plugin for [nodenv](https://github.com/nodenv/nodenv) that detects
the Node.js version based on the
[`engines`](https://docs.npmjs.com/files/package.json#engines) field of the
current tree's `package.json` file. The `$NODENV_VERSION` environment variable
(set with `nodenv shell`) and `.node-version` files still take precedence.

When `engines` is configured with a range this plugin chooses the greatest
installed version matching the range, or exits with an error if none match.

<!-- toc -->

- [Installation](#installation)
  - [Installing with Git](#installing-with-git)
  - [Installing with Homebrew](#installing-with-homebrew)
- [Usage](#usage)
- [Contributing](#contributing)
- [Credits](#credits)

<!-- tocstop -->

## Installation

### Installing with Git

```console
git clone https://github.com/nodenv/nodenv-package-json-engine.git $(nodenv root)/plugins/nodenv-package-json-engine
```

### Installing with Homebrew

MacOS users can install [many nodenv
plugins](https://github.com/nodenv/homebrew-nodenv) with
[Homebrew](http://brew.sh).

_This is the recommended method of installation if you installed nodenv with
Homebrew._

```console
brew tap nodenv/nodenv
brew install nodenv-package-json-engine
```

## Usage

Once you've installed the plugin you can verify that it's working by `cd`ing
into a project that has a `package.json` file with `engines` and does not have
a `.node-version` file. From anywhere in the project's tree, run `nodenv which
node`.

## Contributing

`npm install` and `npm test` from within the project.

## Credits

`package.json` inspection and SemVer integration heavily inspired by nvmish
[[1]](https://github.com/goodeggs/homebrew-delivery-eng/blob/master/nvmish.sh)
[[2]](https://gist.github.com/assaf/ee377a186371e2e269a7) and
[rbenv-bundler-ruby-version](https://github.com/aripollak/rbenv-bundler-ruby-version).

Shell SemVer range support provided by [sh-semver](https://github.com/qzb/sh-semver).

`package.json` parsing provided by [JSON.sh](https://github.com/dominictarr/JSON.sh).
