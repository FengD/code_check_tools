#!/bin/bash

# param init
TOOL_PATH=$(dirname "$(readlink -f "$0")")
LINT_FILTER="-legal,-build/c++11,-runtime/references"
CHECK_EXCLUDE=""
if [[ "$CODE_CHECK_EXCLUDE_LIST" != "" ]];then
    array=(${CODE_CHECK_EXCLUDE_LIST//,/ })
    for var in ${array[@]}
    do
        path=$(find ${WORKSPACE} -name $var)
        CHECK_EXCLUDE=$CHECK_EXCLUDE" --exclude="$path
    done
fi

LINT_CMD="${TOOL_PATH}/tools/cpplint/cpplint_recursive.py --recursive 
          --linelength=100 --filter=${LINT_FILTER} ${CHECK_EXCLUDE} "

# check result file and folder init
TMP_FOLDER="/tmp/code_check/cpplint"
RESULT_FILE_PATH="${TMP_FOLDER}/result.txt"
rm -rf $TMP_FOLDER
mkdir -p $TMP_FOLDER

# 1. Single File Check
function check_dir() {
    if ! ${LINT_CMD} "$d"; then
        echo -e "LINT FAILED"
    else
        echo -e "LINT SUCCESS"
    fi
}

if [[ $# -gt 0 ]]; then
    for d in "$@"; do
        echo "${d}"
        check_dir "${d}"
    done
    exit 0
fi

#2. All Module Check
set -ue

${LINT_CMD} ${WORKSPACE} 2> $RESULT_FILE_PATH
ERRORS=`sed -n '$=' $RESULT_FILE_PATH`
ERRORS_NB=0
if [[ "$ERRORS" != "" ]];then
    cat $RESULT_FILE_PATH
    ERRORS_NB=$(bc <<< "${ERRORS}")
    echo "${ERRORS_NB} errors found!"
    echo "Details: ${RESULT_FILE_PATH}"
    exit 1
fi

exit 0