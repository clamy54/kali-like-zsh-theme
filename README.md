#### KALI-LIKE Theme for Oh-My-Zsh 

![Preview](screenshots/kali-like-zsh.png)

Kali-Like is a [oh-my-zsh](https://ohmyz.sh/) theme that looks like Kali Linux default zsh theme.
Kali-Like can be installed on any linux distribution and isn't Kali Linux dependent.

## Installation  

1. `mkdir $ZSH_CUSTOM/themes` _You can skip this command if the directory exists already_
2. `wget -O $ZSH_CUSTOM/themes/kali-like.zsh-theme https://raw.githubusercontent.com/clamy54/kali-like-zsh-theme/master/kali-like.zsh-theme`  
3. `vim ~/.zshrc`  
4. Set `ZSH_THEME="current_theme"` to `ZSH_THEME="kali-like"`  


## Options  
Kali-Like use zsh_autosuggestions and zsh-syntax-highlighting plugins.
If it doesn't find theses plugins, it downloads them automatically in your ~/.zsh folder.

If you dont' want to automatically download missing plugins, you can set AUTO_DOWNLOAD_SYNTAX_HIGHLIGHTING_PLUGIN and AUTO_DOWNLOAD_ZSH_AUTOSUGGESTIONS_PLUGIN to "no" at the beginning of the theme file.

If you don't want to use theses plugins, you can set USE_SYNTAX_HIGHLIGHTING and USE_ZSH_AUTOSUGGESTIONS vars to "no" at the beginning of the theme file.

By default, this theme fits on two lines on screen. You can switch to single-line mode by pressing Ctrl+P. If you want to use single line mode by default, you can set PROMPT_ALTERNATIVE=oneline instead of
PROMPT_ALTERNATIVE=twoline.

## Font  
By default, Kali Linux uses FiraCode as default terminal font.
You can [install](https://github.com/tonsky/FiraCode/wiki/Installing) it on your distro for a better Kali Look'n'Feel ...

## License
MIT [Cyril Lamy](https://github.com/clamy54)