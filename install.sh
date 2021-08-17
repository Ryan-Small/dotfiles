#!/bin/sh

# Exit immediately if a commond exists with a non-zero status.
set -e


# Strings for formatting output
PROMPT_OK=$'  [ \033[00;32mOK\033[0m ]'
PROMPT_FAIL=$'  [\033[0;31mFAIL\033[0m]'
PROMPT_INFO=$'  [ \033[00;34m..\033[0m ]'
PROMPT_USER=$'  [ \033[00;33m??\033[0m ]'


main () {
  # Link all of the Dotfiles.
  printf "${PROMPT_INFO} - Installing Dotfiles\n"
  install_dotfiles
  printf "${PROMPT_OK} - Installed Dotfiles\n"
}


#
# Iterates through each of the directories looking for .symlink files and symbolically links them to the home directory.
#
install_dotfiles () {
  local overwrite_all=false
  local backup_all=false
  local skip_all=false

  # Iterate over all directories in our dotfiles root looking for .symlink files.
  for src in $(find -H "$(pwd -P)" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
  do
    dst="$HOME/$(basename "${src%.*}")"
    link_file "$src" "$dst"
  done
}


#
# Does the actual linking of two files and provides the user with options if a file already exists in the home
# directory with the same name.
#
link_file () {
  local src=$1 dst=$2
  local overwrite= backup= skip=
  local action=

  # If the file exists and is readable, a directory, or a symbolic link...
  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    # Have we already specified some master override option.
    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      # Is the file already linked correctly?
      if [ "$(readlink $dst)" == "$src" ]
      then
        skip=true;
      else

        read -n 1 -p "${PROMPT_USER} - File already exists: $dst ($(basename "$src")) - [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all:" action
	    printf "\n"

	    case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac
      fi
    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      printf "${PROMPT_OK} - Removed ${dst}\n"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      printf "${PROMPT_OK} - Moved ${dst} to ${dst}.backup\n"
    fi

    if [ "$skip" == "true" ]
    then
      printf "${PROMPT_OK} - Skipping ${src}\n"
    fi
  fi

  if [ "$skip" != "true" ]
  then
    ln -s "$1" "$2"
    printf "${PROMPT_OK} - Linked ${1} to ${2}\n"
  fi
}


main

