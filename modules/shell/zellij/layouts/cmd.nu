#! /usr/bin/env nu

def main [] {

}

# Open ai-assistant in pane
def "main coding-assistant" [type: string] {
    match $type {
        "claude" => { zellij run -d down -c -- claude }
        "gemini" => { zellij run -d down -c -- gemini }
        _ => { }
    }
}
