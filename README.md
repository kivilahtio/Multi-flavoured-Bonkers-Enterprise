# Multi-flavoured-Bonkers-Enterprise

Bonkers to the max.

## Setting up developing environment

Bonkers uses Dist::Zilla for packaging.
(Or just install Perl deps manually, by skipping straight to the Usage-section)

```
cpanm Dist::Zilla
cpanm $(dzil authordeps)
cpanm $(dzil installdeps)
```

Dev your feature.

Then

```
dzil smoke
```

## Usage

```
perl -Ilib -I. bin/bonkers.pl
prove -Ilib -I. t
```

## Worklogs

See worklog.txt
