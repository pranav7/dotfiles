#!/bin/false

setopt prompt_subst

export PS1='$(fancy_dir) $(git_branch) $(git_dot)$(chevrons) '
# export RPROMPT='$(git_branch)'
export RPROMPT=''