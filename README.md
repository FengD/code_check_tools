# Description

If you want to have good product quality or code quality upon project or product delivery, it is very necessary to use multiple inspection tools to monitor the code in each submission.
For example, [cppcheck](http://cppcheck.net/) (for the C++ code static check), [cpplint]() (for the C++ code style check ), [lizard](https://github.com/terryyin/lizard) (for the code circle complexity check), redundant, etc.

This project gives a good practice about how to use these kind of tools to supervise your project. 
Ii will gives your some comments at certain part of the script.

And how to put it in your CI/CD pipeline.

# Tools include

* cppcheck - static check
* cpplint - code style check
* pylint - python code style check
* cpplizard - circle complexity check
* redundant - code redundant check
* fl - code file lines too large check

# How to use
1. `Mandatory ` Define the `WORKSPACE` by environment variable, for example `export WORKSPACE=<path>`.
2. `Optional` Define the `CODE_CHECK_EXCLUDE_LIST` exclude folder list if need, for excample `export CODE_CHECK_EXCLUDE_LIST=<folder1>,<folder2>,...`.
3. `code_check.sh help` will print the help list and gives you some guidance.

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

# Some practice

# Annexe

