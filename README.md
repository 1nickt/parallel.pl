## Parallel Perl Dancer2 app

Website dedicated to sharing information about parallel-process computing with Perl.

### To use:

`git clone` this repo and `cd` into the root directory.

Then run:

```
    cpanm --installdeps .
    prove -lr t
    plackup bin/app.psgi
```

Then point your browser at `http://localhost:5000`
