# sh-semver
[![Build Status](https://travis-ci.org/jsokolowski/sh-semver.svg?branch=master)](https://travis-ci.org/jsokolowski/sh-semver)

The semantic versioner for Bourne Shell.

## Ranges

Every *version range* contains one or more *sets of comparators*. To satisfy *version range* version must satisfies all *comparators* from at least one set. Sets are separated with two vertical bars ``||``. Rules in each set are separated with whitespaces. Empty set are treated as wildcard comparator ``*``.

### Basic comparators
There are five basic comparators:

* Equal to ``=A.B.C`` (``=`` operator is optional, it may be provided but usually it isn't).
* Less than ``<A.B.C``
* Greater than ``>A.B.C``
* Less than or equal to ``<=A.B.C``
* Greater than or equal to ``>=A.B.C``

### Advanced comparators
##### Wildcard ``*`` ``*.*`` ``*.*.*``
##### Wildcard ranges ``A.*.*`` ``A.B.*``
##### Caret with ``^A.B.C`` ``^A.B`` ``^A``
##### Tilde ranges ``~A.B.C`` ``~A.B`` ``~A``
##### Hyphen ranges ``A.B.C - X.Y.Z``

### Prerelease versions
Prerelease versions can satisfy comparators set only when have the same minor major and patch numbers as at least one of comparators.