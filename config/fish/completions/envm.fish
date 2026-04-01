complete -c envm -e

complete -c envm -n '__fish_use_subcommand' -l file -d 'Override the managed env file' -r -F
complete -c envm -n '__fish_use_subcommand' -l help -d 'Print help'
complete -c envm -n '__fish_use_subcommand' -l version -d 'Print version'

complete -c envm -n '__fish_use_subcommand' -a add -d 'Add a new variable'
complete -c envm -n '__fish_use_subcommand' -a edit -d 'Edit an existing variable'
complete -c envm -n '__fish_use_subcommand' -a remove -d 'Remove a variable'
complete -c envm -n '__fish_use_subcommand' -a list -d 'List variables'
complete -c envm -n '__fish_use_subcommand' -a export -d 'Print exports for the current shell'
complete -c envm -n '__fish_use_subcommand' -a completions -d 'Generate shell completions'
complete -c envm -n '__fish_use_subcommand' -a help -d 'Print help information'

complete -c envm -n '__fish_seen_subcommand_from edit remove' -xa '(grep "=" "$HOME/.config/envm/env" 2>/dev/null | string split -f1 =)'

complete -c envm -n '__fish_seen_subcommand_from export' -l shell -xa 'posix fish'

complete -c envm -n '__fish_seen_subcommand_from completions' -xa 'bash zsh fish'
