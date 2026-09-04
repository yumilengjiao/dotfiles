# other module init
source '~/.cargo/env.nu'
source './catppuccin-mocha.nu'
#env
$env.EDITOR = "nvim"
$env.config.buffer_editor = "nvim"
$env.config.show_banner = false
# alias
alias v = nvim
alias lg = lazygit
alias ldk = lazydocker
# define commands 
def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	^yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != $env.PWD and ($cwd | path exists) {
		cd $cwd
	}
	rm -fp $tmp
}
# excute
fastfetch
