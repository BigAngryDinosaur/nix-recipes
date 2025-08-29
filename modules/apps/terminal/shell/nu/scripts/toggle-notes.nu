#!/usr/bin/env nu

def main [] {
    let notes_pid = (try { pgrep -f "ghostty --title=Notes" } catch { null })

    if not ($notes_pid | is-empty) {
        let pid_int = try { $notes_pid | into int } catch { null }
        if $pid_int != null {
            kill $pid_int
        }
    } else {
        run-external "ghostty" "--title=Notes" "-e" "zellij" "-l" "notes" | ignore
    }
}
