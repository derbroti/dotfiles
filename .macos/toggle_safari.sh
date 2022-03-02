# MIT License. Copyright (c) 2022 Mirko Palmer (derbroti)

# NOTE: needs shortcut for "Tile Window to Left of Screen"
# SystemPrefs -> Keyboard -> Shortcuts -> App Shortcuts -> All Applications
# -> add "Tile Window to Left of Screen"
# here: <cmd>+<ctrl>+<alt>+ä

if [ -f /tmp/splitter_safari_window ]
then
    id=$(cat /tmp/splitter_safari_window)

    /usr/bin/osascript <<EOF
        tell application "Safari"
            tell every window whose id is ${id} to close
        end tell
EOF
    rm /tmp/splitter_safari_window
    exit 0
fi

tmux_client_id=$(tmux display -p "#{client_pid}")

if [ -z $tmux_client_id ]
then
    echo "\nPlease hold"
else
    tmux display-popup -h11 -w50 "echo \"\n\n\n\n                   Please Hold\n\n\n\"" &
fi

# weird check: either we run on main screen (1050 high) or on the second one, which is above the first
# and macos sets 0,0 to be the left corner of the main screen
is_fullscreen=$(/usr/bin/osascript <<EOF
tell application "iTerm2" to set windowBounds to bounds of front window
if item 4 of windowBounds is 1050 then
    return 1
else if item 4 of windowBounds is 0 and item 2 of windowBounds is -1692 then
    return 2
else
    return 0
end if
EOF
)

# <cmd>+<ctrl>+f if toggle fullscreen
if [ $is_fullscreen -ne 0 ]
then
    ret=$(/usr/bin/osascript <<EOF
    tell application "System Events"
            keystroke "f" using [command down, control down]
    end tell
    delay 0.5
    tell application "Safari"
        make new document at beginning with properties {URL:"https://google.de"}
        set window_id to id of window 1
    end tell
    delay 0.5
    tell application "System Events"
            keystroke "ä" using [command down, control down, option down]
    end tell
    return window_id
EOF
)
    echo $ret > /tmp/splitter_safari_window
    /bin/sleep 0.5
    # move mouse to 2/3 of screenX and click to select the safari window
    /opt/homebrew/bin/cliclick -r m:1260,525 w:50 c:.
    /bin/sleep 0.5
    ret=$(/usr/bin/osascript <<EOF
    tell application "Safari" to activate
    tell application "System Events"
        tell process "Safari"
            click menu item 5 of menu "User Agent" of menu item "User Agent" of menu "Develop" of menu bar item "Develop" of menu bar 1
        end tell
    end tell
EOF
)
    # drag from middle to 5/6 of screenX to shrink the window
    /opt/homebrew/bin/cliclick -e3 -r dd:840,525 w:100 du:1400,525 w:250
    /bin/sleep 0.25
    if [ -z $tmux_client_id ]
    then
        echo "Done - move alone!"
    else
        tmux display-popup -C
    fi
else
    tmux display-popup -C

    if [ -z $tmux_client_id ]
    then
        echo "Not in full-screen!"
    else
        tmux display-popup -h15 -w53 "echo \"\n\n\n\n\n\n                Not in full-screen!\n\n\n\n\n\""
    fi
fi

