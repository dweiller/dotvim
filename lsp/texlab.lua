return {
    settings  = {
        latex = {
            forwardSearch = {
                executable = "evince_dbus.py",
                args = { "%p", "%l", "%f" }
            },
        },
        texlab = {
            diagnostics = {
                ignoredPatterns = { 'Unused label' },
            },
        },
    },
}
