# mutation_coverage
environment for assessment of test completeness

```
cd hello-world
clang-12 -fexperimental-new-pass-manager -fpass-plugin=/usr/lib/mull-ir-frontend-12 -g -grecord-command-line main.c -o hello-world
mull-runner-12 -ide-reporter-show-killed hello-world
```