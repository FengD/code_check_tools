BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[32m'
WHITE='\033[34m'
YELLOW='\033[33m'
NO_COLOR='\033[0m'
BLUE='\033[0;34m'
TOOL_PATH=$(dirname "$(readlink -f "$0")")
VERSION="1.5.0"

function info() {
    (>&2 echo -e "[${WHITE}${BOLD} INFO ${NO_COLOR}] $*")
}

function error() {
    (>&2 echo -e "[${RED} ERROR ${NO_COLOR}] $*")
}

function warning() {
    (>&2 echo -e "[${YELLOW} WARNING ${NO_COLOR}] $*")
}

function ok() {
    (>&2 echo -e "[${GREEN}${BOLD} OK ${NO_COLOR}] $*")
}

function print_delim() {
    echo '=================================================='
}

function get_now() {
    echo $(date +%s)
}

function print_time() {
    END_TIME=$(get_now)
    ELAPSED_TIME=$(echo "$END_TIME - $START_TIME" | bc -l)
    MESSAGE="Took ${ELAPSED_TIME} seconds"
    info "${MESSAGE}"
}

function success() {
    print_delim
    ok "$1"
    print_time
    print_delim
}

function fail() {
    print_delim
    error "$1"
    print_time
    print_delim
}

function version() {
    echo -e "${YELLOW}version: ${VERSION}${NO_COLOR}"
}

function run_lint() {
    ${TOOL_PATH}/cpplint.sh
    if [ $? -eq 0 ]; then
        success 'Lint passed!'
    else
        fail 'Lint failes!'
        exit 1
    fi
}

function run_pylint() {
    ${TOOL_PATH}/pylint.sh
    if [ $? -eq 0 ]; then
        success 'Pylint passed!'
    else
        fail  "Lint failes!"
        exit 1
    fi
}

function run_check() {
    ${TOOL_PATH}/cppcheck.sh
    if [ $? -eq 0 ]; then
        success 'Check passed!'
    else
        fail 'Check failes!'
        exit 1
    fi
}

function run_lizard() {
    ${TOOL_PATH}/cpplizard.sh
    if [ $? -eq 0 ]; then
        success 'Lizard passed!'
    else
        fail 'Lizard failes!'
        exit 1
    fi
}

function run_fileline() {
    ${TOOL_PATH}/cppfileline.sh
    if [ $? -eq 0 ]; then
        success 'Fl passed!'
    else
        fail 'Fl failes!'
        exit 1
    fi
}

function run_redundant() {
    ${TOOL_PATH}/cppredundant.sh
    if [ $? -eq 0 ]; then
        success 'Redundant passed!'
    else
        fail 'Redundant failes!'
        exit 1
    fi
}

function print_usage() {
    version
    echo -e "\n${RED}Usage${NO_COLOR}:
    .${BOLD}/code_check.sh${NO_COLOR} [OPTION]"

    echo -e "\n${RED}Options${NO_COLOR}:
    ${BLUE}lint${NO_COLOR}: run the code style check
    ${BLUE}pylint${NO_COLOR}: run the code style check for python
    ${BLUE}check${NO_COLOR}: run the code static check
    ${BLUE}lizard${NO_COLOR}: run the code cyclomatic complexity check
    ${BLUE}redundant${NO_COLOR}: run the code redundant check
    ${BLUE}verison${NO_COLOR}: show the version of the scripts
    ${BLUE}fl${NO_COLOR}: run the code file lines check
    ${BLUE}run${NO_COLOR}: run all the code check
    ${BLUE}exclude${NO_COLOR}: show the exclude file list
    "
}

function run() {
    run_lint
    run_check
    run_lizard
    run_fileline
    run_redundant
}

function check_workspace() {
    if [ -z $WORKSPACE ];then
        echo -e "${RED}WORKSPACE not defined. 
                 ${NO_COLOR}Use export WORKSPACE=[Your workspace path]."
        exit 1
    fi
}

function check_exclude() {
    if [ -z $CODE_CHECK_EXCLUDE_LIST ];then
        echo -e "${YELLOW}CODE_CHECK_EXCLUDE_LIST not defined. All the code will be checked! ${NO_COLOR}Use export CODE_CHECK_EXCLUDE_LIST=[pattern1],[pattern2],..."
    fi
}

function main() {
    local cmd=$1
    START_TIME=$(get_now)
    case $cmd in
        run)
            check_workspace
            check_exclude
            run
            ;;
        lint)
            check_workspace
            check_exclude
            run_lint
            ;;
        pylint)
            check_workspace
            check_exclude
            run_pylint
            ;;
        check)
            check_workspace
            check_exclude
            run_check
            ;;
        lizard)
            check_workspace
            check_exclude
            run_lizard
            ;;
        redundant)
            check_workspace
            check_exclude
            run_redundant
            ;;
        fl)
            check_workspace
            check_exclude
            run_fileline
            ;;
        exclude)
            echo -e "${BLUE}${CODE_CHECK_EXCLUDE_LIST}"
            ;;
        version)
            version
            ;;
        *)
            print_usage
            ;;
    esac
}

main $@