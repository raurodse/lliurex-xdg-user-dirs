#!/bin/bash
#
# Simple script substitution for xdg-user-dirs-update
# and make the custom actions needed by the LliureX Classroom Model
#
# This script is licensed under GPL v3 or higher
#
# Authors: 
# 	Raul Rodrigo Segura <raurodse@gmail.com>
#	Angel Berlanas Vicente <angel.berlanas@gmail.com>


# Get the lang
# LNG="$(set | grep GDM_LANG |sed -e "s#GDM_LANG=\(.*\)#\1#g;s#\(.*\)\.\(.*\)#\1#")"

# Source for user-dirs if it exists
[ ! -r "~/.config/user-dirs.dirs" ] || source "~/.config/user-dirs.dirs"

# Source the token file if it exists
TOKEN_FILE=".config/user-dirs.created"
[ ! -r "$TOKEN_FILE" ] || source "$TOKEN_FILE"

# Locale values 
TEXTDOMAIN="xdg-user-dirs"
export TEXTDOMAIN

# Download directory actions
DOWNLOADS_LOCALE="$(LANGUAGE="$LANG" gettext "Downloads")"
DESKTOP_LOCALE="$(LANGUAGE="$LANG" gettext "Desktop")"
DOCUMENTS_LOCALE="$(LANGUAGE="$LANG" gettext "Documents")"
SHARE_LOCALE="$(LANGUAGE="$LANG" gettext "Share")"
SHARETEACHERS_LOCALE="$(LANGUAGE="$LANG" gettext "Share teachers")"
# Get Usernames 
GRP_USER="$(id -ng $USER_NAME)"


if [ -d "/var/run/$USER_NAME/home" ]; then
    #Fat clients
    mount --bind /run/$USER_NAME/home/$GRP_USER/$USER_NAME/Desktop ~/$DESKTOP_LOCALE || true
    mount --bind /run/$USER_NAME/home/$GRP_USER/$USER_NAME/Documents ~/$DOCUMENTS_LOCALE  || true
    mount --bind /run/$USER_NAME/share ~/$SHARE_LOCALE  || true
    if [ "$GRP_USER" == "teachers" ]; then
        mount --bind /run/$USER_NAME/share_teachers ~/$SHARETEACHERS_LOCALE  || true
    fi
elif [ -d "/net/home/" ]; then
    # other machines in aula
    mount --bind /net/server-sync/home/$GRP_USER/$USER_NAME/Desktop ~/$DESKTOP_LOCALE || true
    mount --bind /net/server-sync/home/$GRP_USER/$USER_NAME/Documents ~/$DOCUMENTS_LOCALE  || true
    mount --bind /net/server-sync/share ~/$SHARE_LOCALE  || true
    if [ "$GRP_USER" == "teachers" ]; then
        mount --bind /net/server-sync/share_teachers ~/$SHARETEACHERS_LOCALE  || true
    fi
else
    # Exists XDG_DESKTOP and $TOKEN	
    if [ -d "$XDG_DESKTOP_DIR" ] ; then
    
        mv -f "$XDG_DESKTOP_DIR" "~/$DESKTOP_LOCALE"
    else
        # This is the first time or directory not present
        mkdir -p "~/$DESKTOP_LOCALE"
	echo "TOKEN_DESKTOP=$DESKTOP_LOCALE" > "$TOKEN_FILE" 
    fi
    if [ -d "$XDG_DOCUMENTS_DIR" ] ; then
        mv -f "$XDG_DOCUMENTS_DIR" "~/$DOCUMENTS_LOCALE"
    else
        mkdir -p "~/$DOCUMENTS_LOCALE"
    fi
fi

if [ -d "$XDG_DOWNLOAD_DIR" ] ; then
    mv -f "$XDG_DOWNLOAD_DIR" "~/$DOWNLOADS_LOCALE"
else
    mkdir -p "~/$DOWNLOADS_LOCALE"
fi




