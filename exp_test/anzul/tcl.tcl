#-----------------------------------------------------------------------------------
#       SYNTAX HIGHLIGHTING
proc Tclcom {} {
        namespace eval tcl {
        variable tclwords {
        after append array bgerror binary break catch cd clock close concat continue dde encoding \       
        eof error eval exec exit expr fblocked fconfigure fcopy file fileevent filename flush for foreach \
        format gets glob global history if then else incr info interp join lappend lindex linsert list llength load lrange \
        lreplace lsearch lsort memory msgcat namespace open package parray pid proc puts pwd \
        read regexp registry regsub rename resource return scan seek set socket source split string \
        subst switch tclvars tell time trace unknown unset update uplevel upvar variable vwait while}
        set win .text
        set si 1.0
        while {1} {
        set res [$win search -count length -regexp "\\m([join $tclwords {|}])\\M" $si end]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                set prevchar [$win get "$res - 1 chars"]
                        if {$prevchar == "\." || $prevchar == "\-" || $prevchar == "\$" || $prevchar == "\/"} {
                                set res end
                        }
                $win tag add tclcommands $res $end
                set si $end
        }
        $win tag configure tclcommands -foreground #00007c -font {Helvetica 12 bold}
        }
}
proc tclcom {} {
        namespace eval tcl {
        variable tclwords {
        after append array bgerror binary break catch cd clock close concat continue dde encoding \       
        eof error eval exec exit expr fblocked fconfigure fcopy file fileevent filename flush for foreach \
        format gets glob global history if incr info interp join lappend lindex linsert list llength load lrange \
        lreplace lsearch lsort memory msgcat namespace open package parray pid proc puts pwd \
        read regexp registry regsub rename resource return scan seek set socket source split string \
        subst switch tclvars tell time trace unknown unset update uplevel upvar variable vwait while}
        set win .text
        set si [$win index "insert linestart"]
        set en [$win index "insert lineend"]
	$win tag remove temporal $si $en
        while {1} {
        set res [$win search -count length -regexp "\\m([join $tclwords {|}])\\M" $si $en]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                set prevchar [$win get "$res - 1 chars"]
                        if {$prevchar == "\." || $prevchar == "\-" || $prevchar == "\$" || $prevchar == "\/"} {
                                set res end
                        }
                $win tag add tclcommands $res $end
                set si $end
        }
        $win tag configure tclcommands -foreground #00007c -font {Helvetica 12 bold}
        }
}
proc Tkcom {} {
        namespace eval tcl {
        variable tkwords {
        bell bind bindtags bitmap button canvas checkbutton clipboard colors cursors destroy entry \
        event focus font frame grab grid image keysyms label listbox loadTk lower menu menubutton \
        message option options pack photo place radiobutton raise scale scrollbar selection send text \
        tk tkerror tkvars tkwait toplevel winfo wm}
        set win .text
        set si 1.0
        while {1} {
        set res [$win search -count length -regexp "\\m([join $tkwords {|}])\\M" $si end]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                set prevchar [$win get "$res - 1 chars"]
                        if {$prevchar == "\." || $prevchar == "\-" || $prevchar == "\$" || $prevchar == "\/"} {
                                set res end
                        }
                $win tag add tkcommands $res $end
                set si $end
        }
        $win tag configure tkcommands -foreground red -font {Helvetica 12 bold}
        }
}
proc tkcom {} {
        namespace eval tcl {
        variable tkwords {
        bell bind bindtags bitmap button canvas checkbutton clipboard colors cursors destroy entry \
        event focus font frame grab grid image keysyms label listbox loadTk lower menu menubutton \
        message option options pack photo place radiobutton raise scale scrollbar selection send text \
        tk tkerror tkvars tkwait toplevel winfo wm}
        set win .text
        set si [$win index "insert linestart"]
        set en [$win index "insert lineend"]
        while {1} {
        set res [$win search -count length -regexp "\\m([join $tkwords {|}])\\M" $si $en]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                set prevchar [$win get "$res - 1 chars"]
                        if {$prevchar == "\." || $prevchar == "\-" || $prevchar == "\$" || $prevchar == "\/"} {
                                set res end
                        }
                $win tag add tkcommands $res $end
                set si $end
        }
        $win tag configure tkcommands -foreground red -font {Helvetica 12 bold}
        }
}
proc Flag {} {
        set win .text
        set si 1.0
while {1} {
        set res [$win search -count length -regexp "\\ -\[a-zA-Z\\-\]+" $si end]
                if {$res == ""} {
                break
                }
        set end "$res + $length chars"
        $win tag add flag $res $end
        set si $end
        }
$win tag configure flag -foreground #f416f8 
}
proc flag {} {
        set win .text
        set si [$win index "insert linestart"]
        set en [$win index "insert lineend"]
while {1} {
        set res [$win search -count length -regexp "\\ -\[a-zA-Z\\-\]+" $si end]
                if {$res == ""} {
                break
                }
        set end "$res + $length chars"
        $win tag add flag $res $end
        set si $end
        }
$win tag configure flag -foreground #f416f8 
}
proc Brace {} {
foreach s {"\{" "\}" "\[" "\]" "\(" "\)"} {
        set win .text
        set si 1.0
                while {1} {
                set res [$win search -count length $s $si end]
                        if {$res == ""} {
                        break
                        }
                set end "$res + $length chars"
                $win tag add brace $res $end
                set si $end
                }
        $win tag configure brace -foreground #00dc00 -font {Helvetica 12 bold}
        }
}
proc brace {} {
foreach s {"\{" "\}" "\[" "\]" "\(" "\)"} {
        set win .text
        set si [$win index "insert linestart"]
        set en [$win index "insert lineend"]
                while {1} {
                set res [$win search -count length $s $si $en]
                        if {$res == ""} {
                        break
                        }
                set end "$res + $length chars"
                $win tag add brace $res $end
                set si $end
                }
        $win tag configure brace -foreground #00dc00 -font {Helvetica 12 bold}
        }
}
proc Var {} {
        set win .text
        set si 1.0
while {1} {
        set res [$win search -count length -regexp "\\$\[a-zA-Z0-9_:\\-\]+" $si end]
                if {$res == ""} {
                break
                }
        set end "$res + $length chars"
        $win tag add var $res $end
        set si $end
        }
$win tag configure var -foreground #5252f4
}
proc var {} {
        set win .text
       set si [$win index "insert linestart"]
        set en [$win index "insert lineend"]
	while {1} {
        set res [$win search -count length -regexp "\\$\[a-zA-Z0-9_:\\-\]+" $si $en]
                if {$res == ""} {
                break
                }
        set end "$res + $length chars"
        $win tag add var $res $end
        set si $end
        }
$win tag configure var -foreground #5252f4
}
proc Comments {} {
        set comments green4
        set win .text
        set si 1.0
        while {1} {
                set res [$win search -count length -regexp {^[\t]*\#.*} $si end]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                $win tag add comments $res $end
                set si $end
        }
        $win tag configure comments -foreground  $comments -font {Helvetica 12}
}
proc comments {} {
        set comments green4
        set win .text
        set si [$win index "insert linestart"]
        set en [$win index "insert lineend"]
        while {1} {
                set res [$win search -count length -regexp {^[\t]*\#.*} $si $en]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                $win tag add comments $res $end
                set si $end
        }
        $win tag configure comments -foreground $comments -font {Helvetica 12}
}
proc fasthighlight {} {
bind .text <KeyRelease> {
        tclcom
        tkcom
        flag
        brace
        var
        comments
        set counter [.text index insert]
        set linea [lindex [split $counter .] 0]
        set counter [.text index insert]
        .icons.count configure -text $linea
}
bind .text <BackSpace> {
        set win .text
        set si [$win index insert]
        set en [$win index "insert lineend"]
        set tag [$win tag names [$win index insert]]
        if {$tag == ""} {
                set tag [$win tag names [tkTextPrevPos $win insert tcl_startOfPreviousWord]]
        }
        if {$tag == "tclcommands" || $tag == "tkcommands"} {
                set si [$win index "insert linestart"]
                set en [$win index "insert lineend"]
        }
        if {$tag == "flag" || $tag == "var"} {
                set si [$win index insert]
                set en [$win index "insert wordend"]
        }
        if {$tag == "comments"} {
                set si [$win index insert]
                set en [$win index "insert lineend"]
        }
        if {$tag == "sel"} {
                set si [$win index insert]
                set en [$win index "insert lineend"]
        }
        $win tag add temporal $si $en
        $win tag configure temporal -foreground black -font {Helvetica 12 normal}
        foreach tag  {tclcommands tkcommands comments flag var} {
                $win tag remove $tag $si $en
        }
}
bind .text <Delete> {
        set win .text
        set si [$win index insert]
        set en [$win index "insert lineend"]
        set tag [$win tag names [$win index insert]]
        if {$tag == ""} {
                set tag [$win tag names [tkTextPrevPos $win insert tcl_startOfPreviousWord]]
        }
        if {$tag == "tclcommands" || $tag == "tkcommands"} {
		set si [$win index "insert linestart"]
		set en [$win index "insert lineend"]            
        }
        if {$tag == "flag" || $tag == "var"} {
		set si [$win index "insert linestart"]
		set en [$win index "insert lineend"]
        }
        if {$tag == "comments"} {
                set si [$win index insert]
                set en [$win index "insert lineend"]
        }
        if {$tag == "sel"} {
                set si [$win index insert]
                set en [$win index "insert lineend"]
        }	 
        $win tag add temporal $si $en
        $win tag configure temporal -foreground black -font {Helvetica 12 normal}
        foreach tag  {tclcommands tkcommands comments flag var} {
                $win tag remove $tag $si $en
        }
}
}
proc highlight {} {
        Tclcom
        Tkcom
        Flag
        Brace
        Var
        Comments
}



