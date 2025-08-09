### This file is overridden by .bashrc.local!

[[ $- != *i* ]] && return

[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$HOME/.local/bin:$PATH"

# This is here for tmux AFAIK
if [[ -x /usr/bin/dircolors ]]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

if command -v vim &>/dev/null; then
	export EDITOR='vim'
	export VISUAL='vim'
else
	export EDITOR='nano'
	export VISUAL='nano'
fi

export TERMINAL='foot'
export BROWSER='firefox'
export PAGER='less'

# Deletion candy
export LESS='-R -i -M -S -x4'
export LESSHISTFILE='-'

export XCURSOR_SIZE=32

export HISTCONTROL='ignoredups:erasedups:ignorespace'
export HISTIGNORE='history:clear:exit'
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTTIMEFORMAT='%F %T '
shopt -s histappend
shopt -s histverify

shopt -s checkwinsize
shopt -s extglob
shopt -s cdspell  # Correct minor typos in cd commands
shopt -s dirspell # Correct typos in directory names during completion
shopt -s autocd   # Change to directory by just typing its name
shopt -s globstar # Enable ** recursive globbing

gitps1() {
	sourceFile='/usr/share/git/git-prompt.sh'
	if [[ -r $sourceFile ]]; then
		source $sourceFile
		export GIT_PS1_SHOWDIRTYSTATE=1
		export GIT_PS1_SHOWUNTRACKEDFILES=1
		export GIT_PS1_SHOWSTASHSTATE=1
		export GIT_PS1_SHOWUPSTREAM='auto'
		__git_ps1 " (%s)"
	fi
}; export gitps1

export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
PS1='[\[\e[32m\]\u@\h\[\e[0m\] \[\e[34;1m\]\W\[\e[0m\]]\[\e[33m\]$(gitps1)\[\e[0m\]\$ '

alias l='ls --color=never'
alias ls='ls --color=auto --group-directories-first'
alias la='ls --color=auto -A --group-directories-first'
alias ll='ls --color=auto -ltrh --group-directories-first'
alias lla='ls --color=auto -ltrAh --group-directories-first'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias diff='diff --color=auto'

# Safety but...
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias lck="swaylock -f -k -i $HOME/Pictures/lockscreen"
alias hibernate='sudo -v && lck && sudo zzz -Z'
alias psgrep='pgrep -ia'

win() {
	if (( EUID == 0 )); then
		echo -e "\e[31mError: Root can't do that!\e[0m"
		return 1
	fi
	
	if [[ -n "$WAYLAND_DISPLAY" || -n "$DISPLAY" ]]; then
		echo -e "\e[33mWarning: Already in a graphical session\e[0m"
		read -p "Continue anyway? [y/N]: " -n 1 -r
		echo
		[[ ! $REPLY =~ ^[Yy]$ ]] && return 1
	fi
	
	# Dumb sway
	export XDG_SESSION_DESKTOP='sway'
	export XDG_CURRENT_DESKTOP='sway'
	export XDG_SESSION_TYPE='wayland'

	export CLUTTER_BACKEND='wayland'
	export SDL_VIDEODRIVER='wayland'
	
	export QT_QPA_PLATFORM='wayland-egl;xcb'
	export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
	export QT_QPA_PLATFORMTHEME='gtk3'
	
	export _JAVA_AWT_WM_NONREPARENTING=1

	export NO_AT_BRIDGE=1
	
	echo 'Launching Wayland session...'
	cd ~ && exec dbus-run-session -- sh -c 'pipewire & exec sway'
}

cpcp() {
	local NAME="${1%.*}"
	g++ "$1" -Wall -Wextra ${2:+"$2"} -std=c++23 -O2 -o "${NAME}.out"
	if [[ $? -ne 0 ]]; then
		echo -e "\e[31mCompilation failed <:\e[0m"
		return 1
	fi
}

crun() {
	local NAME="${1%.*}"
	if [[ ! -f "${NAME}.out" ]]; then
		echo -e "\e[31mExecutable '${NAME}.out' not found!\e[0m"
		return 1
	fi
	./"${NAME}.out"
}

cpgo() {
	cpcp "$1" "$2" && crun "$1"
}

tgen() {
	for NAME in "$@"; do
		local EXT="${NAME##*.}"
		if [[ -f "$NAME" ]]; then
			echo -e "\e[33mWarning: '$NAME' already exists\e[0m"
			read -p "Overwrite? [y/N]: " -n 1 -r
			echo
			[[ ! $REPLY =~ ^[Yy]$ ]] && continue
		fi
		cp -f "$HOME/Templates/temp.$EXT" ./"$NAME" 2>/dev/null
		if [[ $? -ne 0 ]]; then
			echo -e "\e[31mTemplate for '$EXT' extension not found \\:\e[0m"
		fi
	done
}

# Override all you want <:
[[ -f ~/.bashrc.local ]] && source ~/.bashrc.local
