#!/usr/bin/env bash

# macro.sh
# Copyright (C) 2015 D630, GNU GPLv3
# <https://github.com/D630/macro.sh>

# -- DEBUGGING.

#printf '%s (%s)\n' "$BASH_VERSION" "${BASH_VERSINFO[5]}" && exit 0
#set -o xtrace
#exec 2>> ~/macro.sh.log
#set -o verbose
#set -o noexec
#set -o errexit
#set -o nounset
#set -o pipefail
#trap '(read -p "[$BASH_SOURCE:$LINENO] $BASH_COMMAND?")' DEBUG

#declare vars_base=$(set -o posix ; set)
#fgrep -v -e "$vars_base" < <(set -o posix ; set) | \
#egrep -v -e "^BASH_REMATCH=" \
#         -e "^OPTIND=" \
#         -e "^REPLY=" \
#         -e "^BASH_LINENO=" \
#         -e "^BASH_SOURCE=" \
#         -e "^FUNCNAME=" | \
#less

# -- FUNCTIONS.

Macro::Create ()
{
        (( $# )) || builtin return 1

        builtin typeset \
                macro_a \
                macro_pattern="${MACRO_PATTERN:-//}" \
                macro_b="${2:+/${2}}" \
                macro_char \
                macro_tmp="$1";

        if
                [[ $macro_pattern == *[%\#] ]]
        then
                macro_a=/${macro_tmp}
                builtin unset -v macro_b
        else
                if
                        [[ $macro_tmp == *[%\#]* ]]
                then
                        while
                                [[ -n $macro_tmp ]]
                        do
                                builtin read -r -n 1 macro_char <<< "$macro_tmp"
                                macro_a=${macro_a}[${macro_char}]
                                macro_tmp=${macro_tmp#?}
                        done
                else
                        macro_a=$macro_tmp
                fi
        fi

        builtin printf '%s\n' "${macro_pattern}${macro_a}${macro_b}"
}

Macro::Do ()
{
        builtin typeset \
                macro_file="$MACRO_FILE" \
                macro_string="$2";

        if
                [[ -f /dev/stdin || -p /dev/stdin ]]
        then
                macro_file=/dev/fd/0
        else
                [[ -f ${macro_file:-|} || -p ${macro_file:-|} ]] || builtin return 1
        fi

        while
                builtin read -r
        do
                builtin eval macro_string="\${macro_string${REPLY}}"
        done < "$macro_file"

        macro_string="'${macro_string}'"

        if
                [[ $1 == \: ]]
        then
                builtin printf '%s\n' "$macro_string"
        else
                builtin typeset -n macro_ref="$1"
                macro_ref=$macro_string
                builtin unset -n macro_ref
        fi
}

# vim: set ts=8 sw=8 tw=0 et :
