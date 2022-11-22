source $HOME/.zsh_profile.zsh
source $HOME/.zsh_alias.zsh

if [ -d /etc/profile.d ]; then
  for profile in /etc/profile.d/*.sh; do
    if [ -r $profile ]; then
      . $profile
    fi
  done
  unset profile
fi

eval "$(starship init zsh)"
