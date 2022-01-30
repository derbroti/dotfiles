# MIT License. Copyright (c) 2022 Mirko Palmer

# NOTE: needs shortcut for "Tile Window to Left of Screen"
# SystemPrefs -> Keyboard -> Shortcuts -> App Shortcuts -> All Applications
# -> add "Tile Window to Left of Screen"

if [ -f /tmp/splitter_safari_window ]
then
    id=$(cat /tmp/splitter_safari_window)

    osascript <<EOF
        tell application "Safari"
            tell every window whose id is ${id} to close
        end tell
EOF
    rm /tmp/splitter_safari_window
    exit 0
fi

echo "\nPlease hold"

ret=$(osascript <<EOF
tell application "iTerm2" to set windowBounds to bounds of front window

if item 4 of windowBounds is 1050 then
    tell application "System Events"
            keystroke "f" using [command down, control down]
    end tell
    delay 0.5
    tell application "Safari"
        make new document at beginning with properties {URL:"https://google.com"}
        set window_id to id of window 1
    end tell
    delay 0.5
    tell application "System Events"
            keystroke "ä" using [command down, control down, option down]
    end tell
    return window_id
else
    return -1
end if
return window_id
EOF
)

if [ $ret -ge 0 ]
then
    echo $ret > /tmp/splitter_safari_window
    sleep 0.5
    # move mouse to 2/3 of screenX and click to select the safari window
    cliclick -r m:1260,525 w:50 c:.
    sleep 0.5
    ret=$(osascript <<EOF
    tell application "Safari" to activate
    tell application "System Events"
        tell process "Safari"
            click menu item 5 of menu "User Agent" of menu item "User Agent" of menu "Develop" of menu bar item "Develop" of menu bar 1
        end tell
    end tell
EOF
)
    # drag from middle to 5/6 of screenX to shrink the window
    cliclick -e3 -r dd:840,525 w:100 du:1400,525 w:250
    sleep 0.25
    echo "Done - move alone!"
else
    echo "Not in full screen!"
fi

