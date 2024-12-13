package main

import "base:runtime"
import "base:intrinsics"
import t "core:time"
import "core:fmt"
import "core:os"
import "core:math"
import "core:math/linalg"
import "core:math/ease"
import "core:math/rand"
import "core:mem"

import sapp "../sokol/app"
import sg "../sokol/gfx"
import slog "../sokol/log"
import sglue "../sokol/glue"

    
window_w :: 640
window_h :: 480

state: struct {
    pip: sg.Pipeline,
    bind: sg.Bindings,
    pass_action: sg.Pass_Action,
}

init :: proc "c" () {
    using linalg, fmt
    context = runtime.default_context()

    sg.setup({
        environment = sglue.environment(),
        logger = { func = slog.func },
    })

    vertices := [?]f32 {
        // Positions        RGBA
        -0.5, -0.5, 0.0,    1.0, 0.0, 0.0, 1.0,
         0.5, -0.5, 0.0,    0.0, 1.0, 0.0, 1.0,
         0.0,  0.5, 0.0,    0.0, 0.0, 1.0, 1.0,
    }

    state.bind.vertex_buffers[0] = sg.make_buffer({
        data = { ptr = &vertices, size = size_of(vertices) }
    })

    state.pip = sg.make_pipeline({
        shader = sg.make_shader(triangle_shader_desc(sg.query_backend())),
        layout = {
            attrs = {
                ATTR_triangle_position = { format = .FLOAT3 },
                ATTR_triangle_color0 = { format = .FLOAT4 },
            },
        },
    })

    state.pass_action = {
        colors = {
            0 = { load_action = .CLEAR, clear_value = { r = 0.267, g = 0.2, b = 0.333, a = 1}},
        },
    }
}


frame :: proc "c" (){
    context = runtime.default_context()
    sg.begin_pass({ action = state.pass_action, swapchain = sglue.swapchain() })
    sg.apply_pipeline(state.pip)
    sg.apply_bindings(state.bind)
    sg.draw(0, 3, 1)
    sg.end_pass()
    sg.commit()
}

cleanup :: proc "c" () {
    context = runtime.default_context()
    sg.shutdown()
}

main :: proc() {
    fmt.println("Program starting...")

    sapp.run({
        init_cb = init,
        frame_cb = frame,
        cleanup_cb = cleanup,
        width = window_w,
        height = window_h,
        window_title = "game2",
        icon = { sokol_default = true },
        logger = { func = slog.func },
    })

    fmt.println("Program closing...")

}