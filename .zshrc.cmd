# This setting is for the new UTF-8 terminal support
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Set default editor to vim
export EDITOR='vim'

# Youtube-dl default output template.  Usage: youtube-dl --output "$YOUTUBE_DL_OUTPUT" -f "$YOUTUBE_DL_QUALITY"
export YOUTUBE_DL_OUTPUT='%(id)s - %(title)s (%(uploader)s) (%(id)s) (%(upload_date)s).%(ext)s'
export YOUTUBE_DL_QUALITY='http-1080p-1/http-1080p/http-720p-1/http-720p/http-540p-1/http-540p/http-360p-1/http-360p'

## Make terminal better
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias ll='ls -FGlAhp'
cd() { builtin cd "$@"; ll; }
alias cd..='cd ../'
alias ~="cd ~"
alias c='clear'
alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
alias show_options='shopt'                  # Show_options: display bash options settings
alias chdirs="find . -type d -exec chmod 755 {} \;"
alias chfiles="find . -type f -exec chmod 644 {} \;"

# extract: Extract most know archives with one command
extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}



# PROCESS MANAGEMENT

# findPid: find out the pid of a specified process
findPid () { lsof -t -c "$@" ; }

# memHogsTop, memHogsPs:  Find memory hogs
alias memHogsTop='top -l 1 -o rsize | head -20'
alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

# cpuHogs:  Find CPU hogs
alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

# topForever:  Continual 'top' listing (every 10 seconds)
alias topForever='top -l 9999999 -s 10 -o cpu'

# ttop: Recommended 'top' invocation to minimize resources
#  Taken from this macosxhints article
#  http://www.macosxhints.com/article.php?story=20060816123853639
alias ttop="top -R -F -s 10 -o rsize"

# psme: List processes owned by my user:
psme() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }

# NETWORKING

alias myip='curl ip.appspot.com'                    # myip:         Public facing IP Address
alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections

# ii: display useful host related informaton
ii() {
 echo -e "\nYou are logged on ${RED}$HOST"
 echo -e "\nAdditionnal information:$NC " ; uname -a
 echo -e "\n${RED}Users logged on:$NC " ; w -h
 echo -e "\n${RED}Current date :$NC " ; date
 echo -e "\n${RED}Machine stats :$NC " ; uptime
 echo -e "\n${RED}Current network location :$NC " ; scselect
 echo -e "\n${RED}Public facing IP Address :$NC " ;myip
 #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
 echo
}

# cleanupDS: Recursively delete .DS_Store files
alias cleanDS="find . -type f -name '*.DS_Store' -ls -delete"

# cleanupLS: Clean up LaunchServices to remove duplicates in the "Open With" menu
alias cleanLS="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# short cuts
alias hosts='sudo vim /etc/hosts'

# System
alias brewery='brew update && brew upgrade && brew cleanup'
alias update='mas upgrade; brew cleanup; brew upgrade; brew update; brew cask cleanup; brew cu -a -y; composer global update; npm update -g; npm install npm@latest -g'
alias show_files='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
alias hide_files='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'
alias show_desktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
alias hide_desktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias enable_gate="sudo spctl --master-enable"
alias disable_gate="sudo spctl --master-disable"

# NPM
alias nom='rm -rf node_modules/ && npm cache verify && npm install'

# GitHub
alias wip="git add .; git commit -m 'wip'"
alias nah='git reset --hard; git clean -df'

# Chrome
alias kill_chrome="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

# Dummy
alias shrug="printf '¯\_(ツ)_/¯' | pbcopy"
alias flipt="printf '(╯°□°)╯︵ ┻━┻' | pbcopy"
alias fight="printf '(ง'̀-'́)ง' | pbcopy"
