if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.bashrc
source ~/.dotfiles/.zshrc.oh-my-zsh
source ~/.dotfiles/.zshrc.settings
source ~/.dotfiles/.zshrc.cmd
source $(brew --prefix powerlevel10k)/share/powerlevel10k/powerlevel10k.zsh-theme
source ~/.dotfiles/nvm.sh
source ~/.dotfiles/.git.settings

# To customize prompt, run p10k configure or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
