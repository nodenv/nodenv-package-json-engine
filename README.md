sh-semver
=========

[![Build Status](https://travis-ci.org/jsokolowski/sh-semver.svg?branch=master)](https://travis-ci.org/jsokolowski/sh-semver)

Pure sh implementation of semantic versioning

Range matching
--------------

Every range contains one or more sets of rules. To satisfy range version must satisfies all rules from at least one set. Sets are separated with two vertical bars (__||__). Rules in each set are separated with whitespaces. Empty set are treated as wildcard rule (__\*__);

### Basic rules

There is four basic rules: __>__, __<=__, __<__, __>=__. All other rules are translated to groups of these ones.

First two (__>__ and __<=__) are rather simple. For example _>1.2.3_ is satisfied by _1.2.4_ version but not by _1.2.3_ and _<=1.2.3_ is satisfied by _1.2.3-beta_ but not by _1.2.4_. Second two (__<__ and __>=__) are little bit trickier. Literally version _2.0.0-beta_ should match to rule _<2.0.0_ but it is something you probably don't want to, so rule _<2.0.0_ is converted to _<2.0.0-0_. In case of rule __>=__ the oposite is true, version _2.0.0-beta_ should satisfy rule _>=2.0.0_ so this rule is converted to _>=2.0.0-0_. This behavior can be changed by specifying a prerelase. For example rule _<2.0.0-beta_ will be not satisfied by _2.0.0-alpha_.

You doesn't have to specify full version number in rule, altough rules like _>1.2.0_ and _>1.2_ are not the same. For example the lowest version witch satisfies rule _>1.2_ is not a _1.2.1-0_ but _1.3.0-0_. So length of version number in rule affects precision of comparison.


