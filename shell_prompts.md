# Ubuntu

```
PS1='[\D{%F %T %Z}] \[\]\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ \[\]'
```

# macOS

```
PS1=[$(date "+%Y:-%m-%d %H:%M:%S %Z")]' %n@%m %1~ '
PS1='[20%D %*]  %n@%m %1~ '
```

# Windows

```
function Prompt { "[$(get-date )] $Env:USERNAME@$Env:COMPUTERNAME  [$PWD] PS> " }
```
