# Alias
# ---
#
alias k="kubectl"
alias h="helm"
alias tf="terraform"
alias a="ansible"
alias ap="ansible-playbook"
alias dt="datree"

# mac OS shortcuts
alias code="open -a 'Visual Studio Code'"

# ALIAS COMMANDS
if ! command -v exa &> /dev/null
then
  alias ls="exa --icons --group-directories-first"
  alias ll="exa --icons --group-directories-first -l"
fi

alias grep='grep --color'