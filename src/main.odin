package main

import "core:fmt"

import sapp "../sokol/app"
    
window_w :: 1280
window_h :: 720


main :: proc() {
    fmt.println("Program starting...")

    sapp.run({
        width = window_w,
        height = window_h,
        window_title = "game2",
        icon = { sokol_default = true },
    })

    fmt.println("Program closing...")

}
