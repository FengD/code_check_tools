#!/bin/bash
RED='\033[0;31m'
CC_THRESHOLD=10
LEN_THRESHOLD=80
NB_PARAM_THRESHOLD=5
LANGUAGE=cpp
ERROR_THRESHOLD=10
MAX_CPU_NUM=$(nproc)
NB_THREAD=$[${MAX_CPU_NUM}-2]

exclude_files_pattern=()
CHECK_EXCLUDE=""
if [[ "$CODE_CHECK_EXCLUDE_LIST" != "" ]];then
    exclude_files_pattern=(${CODE_CHECK_EXCLUDE_LIST//,/ })
fi

EXCLUDE_FILES=""
for var in ${exclude_files_pattern[@]}
do
    path=$(find ${WORKSPACE} -name $var)
    for f in ${path[@]}
    do
        EXCLUDE_FILES="${EXCLUDE_FILES} -x *${f}*"
    done
done

TOOL_PATH=$(dirname "$(readlink -f "$0")")
LIZARD_CMD="python ${TOOL_PATH}/tools/lizard/lizard.py 
           -l${LANGUAGE} ${EXCLUDE_FILES} -a${NB_PARAM_THRESHOLD} 
           -L${LEN_THRESHOLD} -C${CC_THRESHOLD} -t${NB_THREAD} --csv -w"
TMP_FOLDER="/tmp/code_check/cpplizard"
RESULT_FILE_PATH="${TMP_FOLDER}/result.txt"
rm -rf $TMP_FOLDER
mkdir -p $TMP_FOLDER
# Single File Check
function check_dir() {
    d="$1"
    echo -e "CHECK FILE"
    ${LIZARD_CMD} "${d}"
}

if [[ $# -gt 0 ]]; then
    for d in "$@"; do
        echo "${d}"
        check_dir "${d}"
    done
    exit 0
fi

## All Module Check
set -ue

${LIZARD_CMD} ${WORKSPACE} > $RESULT_FILE_PATH
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
