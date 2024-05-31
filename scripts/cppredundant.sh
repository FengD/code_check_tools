#!/bin/bash
TOOL_PATH=$(dirname "$(readlink -f "$0")")
cd ${WORKSPACE}
# static folder
TMP_FOLDER="/tmp/code_check/redundant"
CPD_FILE="${TMP_FOLDER}/result.txt"
rm -rf $TMP_FOLDER
mkdir -p $TMP_FOLDER
# output folder
TOKENS=80

while [[ $# -gt 0 ]]; do
  case "$1" in
    -t)
      TOKENS=$2
      shift
      shift
      ;;
    -i|--ignore)
      ignore=$(find "${WORKSPACE}/${2}" -type f)
      ;;
    -r|--no-refline)
      refline=${find ${WORKSPACE}/reference_line_bd -type f}
      shift
      ;;
    esac
done

PMD_HOME="${TOOL_PATH}/tools/pmd-bin-6.36.0"

cd "${WORKSPACE}"
CMD="${PMD_HOME}/bin/run.sh cpd --ignore-literals --language cpp --minimum-tokens ${TOKENS} --files ${WORKSPACE} --format csv"
TOTAL_EXCLUDE=""
if [[ -n "$CODE_CHECK_EXCLUDE_LIST" ]]; then
  TOTAL_EXCLUDE=" --exclude-dir=${CODE_CHECK_EXCLUDE_LIST} "
fi

if [[ "$CODE_CHECK_EXCLUDE_LIST" != "" ]];then
    exclude_files_pattern=(${CODE_CHECK_EXCLUDE_LIST//,/ })
fi

EXCLUDE_FILES=""
for var in ${exclude_files_pattern[@]}
do
    path=$(find ${WORKSPACE} -name $var)
    for fp in ${path[@]}
    do
        fs=$(find $fp -type f -exec ls -l {} \; 2> /dev/null | sort -t' ' -k +6,6 -k +7,7 | awk '{print $NF}')
        EXCLUDE_FILES="${EXCLUDE_FILES} --exclude ${fs}"
    done
done
CMD="$CMD ${EXCLUDE_FILES}"

total=$(cloc ${TOTAL_EXCLUDE} ${WORKSPACE}| grep -e "C++  " -e "C  " -e "C/C++" | awk '{SUM+=$NF} END {print SUM}')
$CMD > ${CPD_FILE}
redundant=$(awk -F',' '{SUM+=($1*($3-1))} END {printf SUM}' "${CPD_FILE}")
redundant_percentage=$(bc <<< "scale=2; 100.0 * ${redundant} / ${total}")

echo "redundant, total, redundant_percentage"
echo "${redundant}, ${total}, ${redundant_percentage}"
cat ${CPD_FILE}
echo "Details: ${CPD_FILE}"
if [[ $(bc <<< "100.0 * ${redundant} / ${total}") -gt 15 ]]; then
  echo "redundant bigger than 15%"
  exit 1
fi

exit 0