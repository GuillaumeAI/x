###-begin-gia-ast2-completions-###
#
# yargs command completion script
#
# Installation: gia-ast2 completion >> ~/.bashrc
#    or gia-ast2 completion >> ~/.bash_profile on OSX.
#
alias gia-watch-add="/mnt/c/Users/jeang/Dropbox/lib/drop/tool_add_watch.sh "

_tool_add_watch_completions()
{
    local cur_word args type_list

    cur_word="${COMP_WORDS[COMP_CWORD]}"
    args=("${COMP_WORDS[@]}")

    # ask yargs to generate completions.
    type_list=$(cd /mnt/c/Users/jeang/Dropbox/lib/drop &&./_makeautocomplete.sh)

    COMPREPLY=( $(compgen -W "${type_list}" -- ${cur_word}) )

    # if no match was found, fall back to filename completion
    if [ ${#COMPREPLY[@]} -eq 0 ]; then
      COMPREPLY=()
    fi

    return 0
}
complete -o default -F _tool_add_watch_completions gia-watch-add

###-end-gia-ast2-completions-###

