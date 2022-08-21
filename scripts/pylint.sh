#!/bin/bash

# param init
TOOL_PATH=$(dirname "$(readlink -f "$0")")

CHECK_INCLUDE=""
for file in `ls $WORKSPACE`
do
    # only folder is ok
    if [ -d ${WORKSPACE}/$file ]; then
        CHECK_INCLUDE=$CHECK_INCLUDE${WORKSPACE}/$file","
    fi
done

LINT_CMD="pylint --rcfile=${TOOL_PATH}/tools/pylint/pylint.conf --reports=yes --ignore=${CODE_CHECK_EXCLUDE_LIST}"

set -ue

CHECK_PACKAGE=(${CHECK_INCLUDE//,/ })
for pkg in ${CHECK_PACKAGE[@]}
do
    ${LINT_CMD} $pkg
    if [ $? -ne 0 ]; then
        exit $?
    fi
done