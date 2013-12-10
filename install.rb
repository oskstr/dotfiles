#!/usr/bin/env ruby

file_links = {
  "Xmodmap" => ".Xmodmap",
  "ackrc" => ".ackrc",
  "bashrc" => ".bashrc",
  "bashrc.aliases" => ".bashrc.aliases",
  "bashrc.prompt" => ".bashrc.prompt",
  "bashrc.utils" => ".bashrc.utils",
  "bin" => ".bin",
  "ctags" => ".ctags",
  "emacs.d" => ".emacs.d",
  "exelse" => ".exelse",
  "git" => ".git",
  "gitconfig" => ".gitconfig",
  "gitignore" => ".gitignore",
  "gnus" => ".gnus",
  "octaverc" => ".octaverc",
  "quicklisp" => ".quicklisp",
  "rspec" => ".rspec",
  "sbclrc" => ".sbclrc",
  "ssh-config" => ".ssh/config",
  "tmux.conf" => ".tmux.conf",
  "wallpaper" => ".wallpaper",
  "xinitrc" => ".xinitrc"
}

file_links.each do |source, target|
  target_file = File.expand_path("~/#{target}")
  source_file = File.expand_path("~/.dotfiles/#{source}")

  unless File.exists?(target_file) || File.symlink?(target_file)
    File.symlink(source_file, target_file)
  end
end