export PATH="/usr/local/sbin:$PATH"

if [ -f "/vagrant/private/environment" ]; then
  . "/vagrant/private/environment"
fi

if [ -f ~/dotfiles/private/environment ]; then
  . ~/dotfiles/private/environment
fi

if [ -f ~/git-completion.sh ]; then
  . ~/git-completion.sh
fi

if [ -f ~/git-prompt.sh ]; then
  GIT_PS1_SHOWDIRTYSTATE=true
  GIT_PS1_SHOWUNTRACKEDFILES=true
  GIT_PS1_SHOWUPSTREAM=auto
  PS1='\u@\h:\w$(__git_ps1) '
  . ~/git-prompt.sh
fi

if [ -f ~/.nvm/nvm.sh ]; then
  . ~/.nvm/nvm.sh
fi

if [ -f "$(brew --prefix)/etc/profile.d/z.sh" ]; then
  . "$(brew --prefix)/etc/profile.d/z.sh"
fi

if [ -f "$(brew --prefix)/etc/bash_completion.d/password-store" ]; then
  . "$(brew --prefix)/etc/bash_completion.d/password-store"
fi

# From https://gist.github.com/bmhatfield/cc21ec0a3a2df963bffa3c1f884b676b
if [ -f ~/.gnupg/.gpg-agent-info ] && [ -n "$(pgrep gpg-agent)" ]; then
    source ~/.gnupg/.gpg-agent-info
    export GPG_AGENT_INFO
else
    eval $(gpg-agent --daemon 2>/dev/null)
fi

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /Users/michael/.nvm/versions/node/$(nvm version)/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash ] && . /Users/michael/.nvm/versions/node/$(nvm version)/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash
