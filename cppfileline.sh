#!/bin/bash

# param init
CHECK_EXCLUDE=""
if [[ "$CODE_CHECK_EXCLUDE_LIST" != "" ]];then
    array=(${CODE_CHECK_EXCLUDE_LIST//,/ })
    for var in ${array[@]}
    do
        file=$(find ${WORKSPACE} | grep $var | tr "\n" ",")
        if [[ -n $file ]]; then
            CHECK_EXCLUDE="${CHECK_EXCLUDE}${file}"
        fi
    done
fi

EXTENS=(".h" ".hpp" ".c" ".cc" ".cpp" ".cu")

CHECK_EXCLUDE_ARRAY=(`echo $CHECK_EXCLUDE | tr ',' ' '`)

# check result file and folder init
TMP_FOLDER="/tmp/code_check/fl"
RESULT_FILE_PATH="${TMP_FOLDER}/result.txt"
rm -rf $TMP_FOLDER
mkdir -p $TMP_FOLDER

invalude_counter=0
function check_dir() {
    files_count=0
    lines_count=0
    max_line=0
    lines_bigger_than500=0
    d="$1"
    execute_static $d
    if [[ $lines_bigger_than500 -gt 0 ]];then
        echo "current_folder: $1 CHECK FAILED! $lines_bigger_than500 files invalid!"
        let invalide_counter=$invalide_counter+1
    else
        echo "current_folder: $1 CHECK PASS!"
    fi
}

function execute_static() {
    for file in ` ls $1 `
    do
        if [[ ! " ${CHECK_EXCLUDE_ARRAY[@]} " =~ " $1/$file " ]];then
            if [ -d $1"/"$file ];then
                execute_static $1"/"$file
            else
                file_name=$1"/"$file
                EXTENSION="."${file_name##*.}
                if [[ "${EXTENS[@]/$EXTENSION/}" != "${EXTENS[@]}" ]];then
                    declare -i file_lines
                    file_lines=`sed -n '$=' $file_name`
                    if [[ $file_lines -gt $max_line ]];then
                        max_line=$file_lines
                    fi
                    if [[ $file_lines -gt 500 ]];then
                        let lines_bigger_than500=$lines_bigger_than500+1
                        echo "$file_lines,$file_name" >> $RESULT_FILE_PATH
                    fi
                fi
            fi
        fi
    done
}

# 1. Single File Check
if [[ $# -gt 0 ]]; then
    for d in "$@"; do
        echo "${d}"
        check_dir "${d}"
    done
    exit 0
fi

echo "count_lines_bigger_than500,details" >> $RESULT_FILE_PATH
# 2. All Module Check
check_dir "${WORKSPACE}"
if [[ $invalide_counter -gt 0 ]];then
    cat $RESULT_FILE_PATH
fi
exit $invalide_counter