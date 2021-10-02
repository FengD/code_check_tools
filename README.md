# Description
The scripts which are used to check the quality of the code.

## cppcheck
static check

## cpplint
code style check

## cpplizard
circle complexity check

## redundant
code redundant check

## fl
code file lines too large check

# How to use
1. Define the `WORKSPACE` by environment variable, for example `export WORKSPACE=<path>`.
2. Define the `CODE_CHECK_EXCLUDE_LIST` exclude folder list if need, for excample `export CODE_CHECK_EXCLUDE_LIST=<folder1>,<folder2>,...`.
3. `code_check.sh help` print the help list.

``` shell
Usage:
    ./code_check.sh [OPTION]

Options:
    lint: run the code style check
    check: run the code static check
    lizard: run the code cyclomatic complexity check
    redundant: run the code redundant check
    verison: show the version of the scripts
    fl: run the code file lines check
    run: run all the code check
    exclude: show the exclude file list

```