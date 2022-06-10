# vim: set sw=4 ai cin et:

# NOTE: this must be sychronized with VGA adaptor module


if { [namespace exists ::de1vga] } { namespace delete ::de1vga }

namespace eval ::de1vga {
    namespace eval var {
        set zoom 4
        set width 160
        set height 120
        set bg "#808080"
        set count 0
    }


    proc init {} {
        if ({[winfo exists .de1vga]}) { destroy .de1vga }

        toplevel .de1vga -padx 5 -pady 5
        wm title .de1vga "fake VGA screen"

        frame .de1vga.draw
        pack .de1vga.draw -expand 1 -fill both

        frame .de1vga.status
        button .de1vga.status.reset -width 5 -relief ridge -text "CLEAR" -command [namespace code reset]
        label .de1vga.status.count_legend -text "  count:"
        label .de1vga.status.count_val -relief groove -width 10

        label .de1vga.status.drawn_legend -text "last:"
        label .de1vga.status.drawn_pos -relief groove -width 7
        label .de1vga.status.click_legend -text "  clicked:"
        label .de1vga.status.click_pos -relief groove -width 7
        label .de1vga.status.mouse_legend -text "  mouse:"
        label .de1vga.status.mouse_pos -relief groove -width 7
        pack .de1vga.status.reset .de1vga.status.count_legend .de1vga.status.count_val -side left
        pack .de1vga.status.mouse_pos .de1vga.status.mouse_legend .de1vga.status.click_pos .de1vga.status.click_legend \
             .de1vga.status.drawn_pos .de1vga.status.drawn_legend -side right
        pack .de1vga.status -side bottom -fill x
        .de1vga.status.drawn_pos configure -text "-,-"
        .de1vga.status.mouse_pos configure -text "-,-"
        .de1vga.status.click_pos configure -text "-,-"

        set w [expr $var::width * $var::zoom]
        set h [expr {$var::height * $var::zoom}]
        canvas .de1vga.draw.c -width $w -height $h -bg $var::bg
        pack .de1vga.draw.c -expand 1 -fill both
        bind .de1vga.draw.c <Motion> [namespace code { show_mouse %x %y }]
        bind .de1vga.draw.c <ButtonPress> [namespace code { show_click %x %y }]
        bind .de1vga.draw.c <Leave> [namespace code { .de1vga.status.mouse_pos configure -text "-,-" }]
    }

    proc reset {} {
        .de1vga.draw.c create rectangle 0 0 [expr $var::width * $var::zoom - 1] [expr $var::height * $var::zoom - 1] -outline $var::bg -fill $var::bg
        set var::count 0
        .de1vga.status.count_val configure -text "$var::count"
        .de1vga.status.drawn_pos configure -text "-,-"
    }

    proc rgb_to_hex {c} {
        set b [expr ($c & 1) * 255]
        set g [expr (($c >> 1) & 1) * 255]
        set r [expr (($c >> 2) & 1) * 255]
        return [format "#%02x%02x%02x" $r $g $b]
    }

    proc plot {x y c} {
        if !({[winfo exists .de1vga]}) {init}

        set x [string tolower $x]
        set y [string tolower $y]
        set c [string tolower $c]
        if { [string equal $x "x"] || [string equal $x "z" ]} { return }
        if { [string equal $y "x"] || [string equal $y "z" ]} { return }
        if { [string equal $c "x"] || [string equal $c "z" ]} { return }
        if {[expr $x < 0]} { return }
        if {[expr $x >= $var::width]} { return }
        if {[expr $y < 0]} { return }
        if {[expr $y >= $var::height]} { return }
        if !({[winfo exists .de1vga]}) { init }
        set x0 [expr $x * $var::zoom]
        set y0 [expr $y * $var::zoom]
        set x1 [expr ($x+1) * $var::zoom - 1]
        set y1 [expr ($y+1) * $var::zoom - 1]
        set clr [rgb_to_hex $c]
        .de1vga.draw.c create rectangle $x0 $y0 $x1 $y1 -outline $clr -fill $clr
        incr var::count
        .de1vga.status.count_val configure -text "$var::count"
        .de1vga.status.drawn_pos configure -text "$x,$y:$c"
    }

    proc show_mouse {x0 y0} {
         set x [expr $x0 / $var::zoom]
         set y [expr $y0 / $var::zoom]
         .de1vga.status.mouse_pos configure -text "$x,$y"
    }

    proc show_click {x0 y0} {
         set x [expr $x0 / $var::zoom]
         set y [expr $y0 / $var::zoom]
         .de1vga.status.click_pos configure -text "$x,$y"
    }
}

namespace inscope ::de1vga init
