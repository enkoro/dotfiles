# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files sourced from it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Move prompt to the bottom when zsh starts and on Ctrl+L.
zstyle ':z4h:' prompt-at-bottom 'yes'

zstyle ':z4h:' propagate-cwd yes

zstyle ':z4h:term-title:ssh'   preexec '%n@%m: ${1//\%/%%}'
zstyle ':z4h:term-title:ssh'   precmd  '%n@%m: %~'
zstyle ':z4h:term-title:local' preexec '${1//\%/%%}'
zstyle ':z4h:term-title:local' precmd  '%~'

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update      'no'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '28'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard  'mac'

# Mark up shell's output with semantic information.
zstyle ':z4h:' term-shell-integration 'yes'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Recursively traverse directories when TAB-completing files.
#zstyle ':z4h:fzf-complete' recurse-dirs 'yes'
#zstyle ':z4h:fzf-complete' fzf-bindings tab:repeat

# Enable direnv to automatically source .envrc files.
zstyle ':z4h:direnv'         enable 'no'
# Show "loading" and "unloading" notifications from direnv.
zstyle ':z4h:direnv:success' notify 'yes'

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# SSH when connecting to these hosts.
zstyle ':z4h:ssh:example-hostname1'   enable 'yes'
zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*'                   enable 'no'

# Send these files over to the remote host when connecting over SSH to the
# enabled hosts.
zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh'

# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
z4h install ohmyzsh/ohmyzsh || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Extend PATH.
path=(~/bin $path)
path=("/Applications/WezTerm.app/Contents/MacOS" $path)
# Export environment variables.
export GPG_TTY=$TTY

# Source additional local files if they exist.
z4h source ~/.env.zsh

# Use additional Git repositories pulled in with `z4h install`.
#
# This is just an example that you should delete. It does nothing useful.
# z4h source ohmyzsh/ohmyzsh/lib/diagnostics.zsh  # source an individual file
# z4h load   ohmyzsh/ohmyzsh/plugins/emoji-clock  # load a plugin

# Define key bindings.
z4h bindkey undo Ctrl+/   Shift+Tab  # undo the last command line change
z4h bindkey redo Option+/            # redo the last undone command line change

z4h bindkey z4h-cd-back    Shift+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Shift+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Shift+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Shift+Down   # cd into a child directory

# Autoload functions.
autoload -Uz zmv

# Define functions and completions.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Define aliases.
alias tree='tree -a -I .git'
alias clear=z4h-clear-screen-soft-bottom
alias ls='eza'
alias vim='nvim'
alias vi='nvim'

# Add flags to existing aliases.
alias ls="${aliases[ls]:-ls} -Ahl"

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu

##### a.shibalov #####

# mcc
complete -C ~/bin/mcc mcc
if [ ! -f ~/.mccloud/n.cur ]; then
    echo odkl > ~/.mccloud/n.cur
fi
if [ ! -f ~/.mccloud/c.cur ]; then
    echo kc > ~/.mccloud/c.cur
fi
export MCC_CLOUD=$(cat ~/.mccloud/c.cur)
export MCC_NS=$(cat ~/.mccloud/n.cur)
alias m='mcc -c "$MCC_CLOUD" -n "$MCC_NS"'
alias csw='f() { echo $1 > ~/.mccloud/c.cur; export MCC_CLOUD=$1 };f'
alias nsw='f() { echo $1 > ~/.mccloud/n.cur; export MCC_NS=$1 };f'
alias ms='f() { dc=${${1#*.*.*.}%%.*}; ns=${${1#*.*.*.*.}%%.*}; mcc ssh -c $dc -n $ns $1 };f'
alias mls='f() { dc=${${1#*.*.*.}%%.*}; ns=${${1#*.*.*.*.}%%.*}; mcc log-streams -c $dc -n $ns $1 };f'
alias ml='f() { dc=${${1#*.*.*.}%%.*}; ns=${${1#*.*.*.*.}%%.*}; if [ -z $2 ]; then mcc log-streams -c $dc -n $ns $1; else mcc logs -c $dc -n $ns $1 $2; fi };f'
alias tt='f() { dc=${${1#*.*.*.}%%.*}; ns=${${1#*.*.*.*.}%%.*}; echo $dc; echo $ns };f'

# aliases
#alias ls="ls -lah"

# eval
eval "$(zoxide init --cmd cd zsh)"

# completions
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit
fi

#pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

#bindkey -v

# Onecloud
export OC_CA_PATH="/Users/a.shibalov/dev/go-one-cloud-manual/ca.crt"
export OC_CERT_PATH="/Users/a.shibalov/dev/go-one-cloud-manual/as.crt.pem"
export OC_KEY_PATH="/Users/a.shibalov/dev/go-one-cloud-manual/as.key.pem"

# Config
export XDG_CONFIG_HOME="$HOME/.config"

# GPG
export GPG_FINGERPRINT="Andrey Shibalov"

# JAVA
export JAVA_HOME=`/usr/libexec/java_home -v 17`
