{ ... }:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = ''
      # used for less common options, intelligently combines if defined in multiple places.
      set-option -g prefix C-a
      bind C-a send-prefix

      # Start numbering at 1
      set -g base-index 1

      # Faster key repetition
      set -s escape-time 10

      set -g mouse on

      set -g status-position bottom
      set -g default-terminal "tmux-256color"
      set-option -sa terminal-overrides ',*256col*:Tc'
      set-option -g focus-events on

      bind -r ^ last-window
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind b confirm kill-window
      bind B confirm kill-server

      # tokyonight
      light=#7AA2F7
      mid=#3B4261
      dark=#A9B1D6
      darker=#1F2335
      #    
      LSS="" # LSS -> left section separator
      RSS="" # RSS -> right section separator
      LCS="" # LCS -> left component separator
      RCS="" # RCS -> right component separator

      light_mid="fg=$light,bg=$mid"
      dark_darker="fg=$dark,bg=$darker"

      set -g mode-style $light_mid
      set -g message-style $light_mid
      set -g message-command-style $light_mid
      set -g pane-border-style fg=$mid
      set -g pane-active-border-style fg=$light
      set -g status on
      set -g status-justify left
      set -g status-style fg=$light,bg=$darker
      set -g status-left-length 100
      set -g status-right-length 100
      set -g status-left-style default
      set -g status-right-style default
      set -g status-left "#[default]$RSS#[fg=$darker,bg=$light]#S#[default]$LSS "
      set -g status-right "#[fg=$mid,bg=default]$RSS#[fg=$light,bg=$mid]%H:%M#[fg=$mid,bg=default]$LSS #[default]$RSS#[reverse]%Y-%m-%d#[default]$LSS"
      setw -g window-status-activity-style $dark_darker
      setw -g window-status-separator ""
      setw -g window-status-style $dark_darker
      setw -g window-status-format "#[fg=$darker,bg=$darker]$LSS#[default]#I | #W #F#[fg=$darker,bg=$darker]$LSS"
      setw -g window-status-current-format "#[fg=$mid,bg=$darker]$RSS#[fg=$light,bg=$mid]#I | #W #F#[fg=$mid,bg=$darker]$LSS "
    '';
  };
}
