# other module init
source '~/.cargo/env.nu'
source './catppuccin-mocha.nu'
#env
$env.EDITOR = "nvim"
$env.PATH = $env.PATH | append "~/.bun/bin/"
$env.config.buffer_editor = "nvim"
$env.MANPAGER = "sh -c 'col -bx | bat -l man -p'"
$env.MANROFFOPT = "-c"
$env.config.show_banner = false
$env.config.menus = (
    $env.config.menus
    | where name != history_menu
    | append {
        name: history_menu
        only_buffer_difference: false
        marker: "? "
        type: { layout: list page_size: 10 }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
    }
)
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
