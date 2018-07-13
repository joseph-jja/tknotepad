#-----------------------------------------------------------------------------------
#       SYNTAX HIGHLIGHTING
proc Reservedwords {} {
        namespace eval tcl {
        variable reservedwords {
	case do done elif else esac fi for function if in select then time until while}
        set win .textarea
        set si 1.0
        while {1} {
        set res [$win search -count length -regexp "\\m([join $reservedwords {|}])\\M" $si end]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                set prevchar [$win get "$res - 1 chars"]
                        if {$prevchar == "\." || $prevchar == "\-" || $prevchar == "\$" || $prevchar == "\/"} {
                                set res end
                        }
                $win tag add reservedwords $res $end
                set si $end
        }
        $win tag configure reservedwords -foreground orange -font {Helvetica 12 bold}
        }
}
proc reservedwords {} {
        namespace eval tcl {
        variable reservedwords {
	case do done elif else esac fi for function if in select then time until while}
        set win .textarea
        set si [$win index "insert linestart"]
        set en [$win index "insert lineend"]
	$win tag remove temporal $si $en
        while {1} {
        set res [$win search -count length -regexp "\\m([join $reservedwords {|}])\\M" $si $en]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                set prevchar [$win get "$res - 1 chars"]
                        if {$prevchar == "\." || $prevchar == "\-" || $prevchar == "\$" || $prevchar == "\/"} {
                                set res end
                        }
                $win tag add reservedwords $res $end
                set si $end
        }
        $win tag configure reservedwords -foreground orange -font {Helvetica 12 bold}
        }
}
proc Builtin {} {
        namespace eval tcl {
        variable builtin {
	alias bg bind break builtin cd command continue declare dirs disown echo enable eval exec exit export false fc fg getconf getopts hash hist jobs kill let local logout newgrp popd print printf pushd pwd read readonly return \
	set shift shopt sleep source suspend test times trap true type typeset ulimit umask unalias unset wait whence}
        set win .textarea
        set si 1.0
        while {1} {
        set res [$win search -count length -regexp "\\m([join $builtin {|}])\\M" $si end]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                set prevchar [$win get "$res - 1 chars"]
                        if {$prevchar == "\." || $prevchar == "\-" || $prevchar == "\$" || $prevchar == "\/"} {
                                set res end
                        }
                $win tag add builtin $res $end
                set si $end
        }
        $win tag configure builtin -foreground navy -font {Helvetica 12 bold}
        }
}
proc builtin {} {
        namespace eval tcl {
        variable builtin {
	alias bg bind break builtin cd command continue declare dirs disown echo enable eval exec exit export false fc fg getconf getopts hash hist jobs kill let local logout newgrp popd print printf pushd pwd read readonly return \
	set shift shopt sleep source suspend test times trap true type typeset ulimit umask unalias unset wait whence}
        set win .textarea
        set si [$win index "insert linestart"]
        set en [$win index "insert lineend"]
        while {1} {
        set res [$win search -count length -regexp "\\m([join $builtin {|}])\\M" $si $en]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                set prevchar [$win get "$res - 1 chars"]
                        if {$prevchar == "\." || $prevchar == "\-" || $prevchar == "\$" || $prevchar == "\/"} {
                                set res end
                        }
                $win tag add builtin $res $end
                set si $end
        }
        $win tag configure builtin -foreground navy -font {Helvetica 12 bold}
        }
}
proc Var {} {
        set win .textarea
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
        set win .textarea
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
proc Brace {} {
foreach s {"\{" "\}" "\[" "\]" "\(" "\)"} {
        set win .textarea
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
        $win tag configure brace -foreground #f416f8 -font {Helvetica 12 bold}
        }
}
proc brace {} {
foreach s {"\{" "\}" "\[" "\]" "\(" "\)"} {
        set win .textarea
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
        $win tag configure brace -foreground #f416f8 -font {Helvetica 12 bold}
        }
}
proc Comments {} {
        set comments green4
        set win .textarea
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
        set win .textarea
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
bind .textarea <KeyRelease> {
	reservedwords
	builtin
        var
	brace
        comments
        set counter [.textarea index insert]
        set linea [lindex [split $counter .] 0]
        set counter [.textarea index insert]
}
bind .textarea <BackSpace> {
        set win textarea
        set si [$win index insert]
        set en [$win index "insert lineend"]
        set tag [$win tag names [$win index insert]]
        if {$tag == ""} {
                set tag [$win tag names [tkTextPrevPos $win insert tcl_startOfPreviousWord]]
        }
        if {$tag == "reservedwords" || $tag == "builtin"} {
                set si [$win index "insert linestart"]
                set en [$win index "insert lineend"]
        }
        if {$tag == "comments"} {
                set si [$win index insert]
                set en [$win index "insert lineend"]
        }
        if {$tag == "var"} {
                set si [$win index insert]
                set en [$win index "insert wordend"]
	}
        if {$tag == "sel"} {
                set si [$win index insert]
                set en [$win index "insert lineend"]
        }	 
        $win tag add temporal $si $en
        $win tag configure temporal -foreground black -font {Helvetica 12 normal}
        foreach tag  {reservedwords builtin comments var} {
                $win tag remove $tag $si $en
        }
}
bind .textarea <Delete> {
        set win .textarea
        set si [$win index insert]
        set en [$win index "insert lineend"]
        set tag [$win tag names [$win index insert]]
        if {$tag == ""} {
                set tag [$win tag names [tkTextPrevPos $win insert tcl_startOfPreviousWord]]
        }
        if {$tag == "reservedwords" || $tag == "builtin"} {
       set si [$win index "insert linestart"]
        set en [$win index "insert lineend"]            
        }
        if {$tag == "comments"} {
                set si [$win index insert]
                set en [$win index "insert lineend"]
        }
        if {$tag == "flag" || $tag == "var"} {
		set si [$win index "insert linestart"]
 		set en [$win index "insert lineend"]
	}
        if {$tag == "sel"} {
                set si [$win index insert]
                set en [$win index "insert lineend"]
        }	 
        $win tag add temporal $si $en
        $win tag configure temporal -foreground black -font {Helvetica 12 normal}
        foreach tag  {reservedwords builtin comments var} {
                $win tag remove $tag $si $en
        }
}
}
proc highlight {} {
	Reservedwords
	Builtin
	Var
	Brace
       Comments
}

