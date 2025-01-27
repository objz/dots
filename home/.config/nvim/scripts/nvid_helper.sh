#!/usr/bin/env bash

# This script is meant to run in the background (detached).
# 1. It launches Neovide, passing along any arguments.
# 2. When Neovide closes, it opens a new Kitty in the saved directory.

saved_dir="$1"
shift  

neovide "$@"

kitty --directory "$saved_dir"
