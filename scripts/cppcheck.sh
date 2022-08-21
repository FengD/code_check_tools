#!/bin/bash

# param init
MAX_CPU_NUM=$(nproc)
CHECK_FILTER="--enable=warning,performance"
CHECK_EXCLUDE=""
if [[ "$CODE_CHECK_EXCLUDE_LIST" != "" ]];then
    array=(${CODE_CHECK_EXCLUDE_LIST//,/ })
    for var in ${array[@]}
    do
        CHECK_EXCLUDE=$CHECK_EXCLUDE" --suppress=*:*"$var"*"
    done
fi
CHECK="cppcheck -j$[${MAX_CPU_NUM}-1]"
CHECK_CMD="${CHECK} ${CHECK_FILTER} ${CHECK_EXCLUDE}"

# check result file and folder init
TMP_FOLDER="/tmp/code_check/cppcheck"
RESULT_FILE_PATH="${TMP_FOLDER}/result.txt"
rm -rf $TMP_FOLDER
mkdir -p $TMP_FOLDER

# 1. Single File Check
function check_dir() {
    if ! ${CHECK_CMD} "$d"; then
        echo -e "CHECK FAILED"
    else
        echo -e "CHECK SUCCESS"
    fi
}

if [[ $# -gt 0 ]]; then
    for d in "$@"; do
        echo "${d}"
        check_dir "${d}"
    done
    exit 0
fi

# 2. All Module Check
set -ue
FILE_LIST=`find ${WORKSPACE} -regex '.*\.c\|.*\.cpp\|.*\.cc\|.*\.tpp\|.*\.txx\|.*\.c++\|.*\.cxx|.*\.hpp'`
echo ${CHECK_CMD}
${CHECK_CMD} ${FILE_LIST} 2> $RESULT_FILE_PATH
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
