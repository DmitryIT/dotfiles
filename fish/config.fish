if status is-interactive
    # Commands to run in interactive sessions can go here
end
starship init fish | source
alias ls="eza --color=always --long --icons=always"
alias cd="z"

zoxide init fish | source

set -gx PATH $PATH (go env GOPATH)/bin
