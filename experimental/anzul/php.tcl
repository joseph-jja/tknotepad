#-----------------------------------------------------------------------------------
#       SYNTAX HIGHLIGHTING 
proc Phpkeywords {} {
        namespace eval tcl {
        variable phpwords {
		and break case class continue default delete do echo else elseif end endfor endif endswitch endwhile extends false \
		for foreach function if include global new null or require return switch this true var while
	}
        set win .text
        set si 1.0
        while {1} {
        set res [$win search -count length -regexp "\\m([join $phpwords {|}])\\M" $si end]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                set prevchar [$win get "$res - 1 chars"]
                        if {$prevchar == "\." || $prevchar == "\-" || $prevchar == "\$" || $prevchar == "\/" || $prevchar == "\""} {
                                set res end
                        }
                $win tag add phpwords $res $end
                set si $end
        }
        $win tag configure phpwords -foreground green4 -font {Helvetica 12 bold}
        }
}
proc phpkeywords {} {
        namespace eval tcl {
        variable phpwords {
		and break case class continue default delete do else elseif end endfor endif endswitch endwhile extends false \
		for foreach function if include global new null or require return switch this true var while
	}
        set win .text
        set si [$win index "insert linestart"]
        set en [$win index "insert lineend"]
	$win tag remove temporal $si $en
        while {1} {
        set res [$win search -count length -regexp "\\m([join $phpwords {|}])\\M" $si $en]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                set prevchar [$win get "$res - 1 chars"]
                        if {$prevchar == "\." || $prevchar == "\-" || $prevchar == "\$" || $prevchar == "\/" || $prevchar == "\""} {
                                set res end
                        }
                $win tag add phpwords $res $end
                set si $end
        }
        $win tag configure phpwords -foreground green4 -font {Helvetica 12 bold}
        }
}
proc Brace {} {
foreach s {"\{" "\}" "\[" "\]" "\(" "\)" "\;" "\:"} {
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
        $win tag configure brace -foreground green4 -font {Helvetica 12 bold}
        }
}
proc brace {} {
foreach s {"\{" "\}" "\[" "\]" "\(" "\)" "\;" "\:"} {
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
        $win tag configure brace -foreground green4 -font {Helvetica 12 bold}
        }
}
proc Comments {} {
        set win .text
        set si 1.0
        while {1} {
                set res [$win search -count length -regexp {//.*} $si end]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                $win tag add comments $res $end
                set si $end
        }
        $win tag configure comments -foreground  orange -font {Helvetica 12 bold}
}
proc comments {} {
        set win .text
        set si [$win index "insert linestart"]
        set en [$win index "insert lineend"]
        while {1} {
                set res [$win search -count length -regexp {^[\t]*\//.*} $si $en]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                $win tag add comments $res $end
                set si $end
        }
        $win tag configure comments -foreground orange -font {Helvetica 12 bold}
}
proc Quotes {} {
        set win .text
        set si 1.0
        while {1} {
                set res [$win search -count length -regexp {"(?:[^\\])([^\"]|\\.)*"} $si end]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                $win tag add quotes $res $end
                set si $end
        }
        $win tag configure quotes -foreground red -font {Helvetica 12 bold}
}
proc quotes {} {
        set win .text
        set si [$win index "insert linestart"]
        set en [$win index "insert lineend"]
        while {1} {
                set res [$win search -count length -regexp {"(?:[^\\])([^\"]|\\.)*"} $si end]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                $win tag add quotes $res $end
                set si $end
        }
        $win tag configure quotes -foreground red -font {Helvetica 12 bold}
	
}
proc Supercomments {} {
	set win .text
	set si 1.0
	set en end
	while {1} {
		set index1 [.text search -regexp -count count -- {/\*} $si $en] 
		set res $index1
		if {$res == ""} {
                        break
               }
		set index2 [.text search -regexp -count count -- {\*/} $index1 end]
		set end [$win tag add supcomment $index1 "$index2 + $count chars"]
		set si $index2
	}
       $win tag configure supcomment -foreground orange -font {Helvetica 12 bold} 
}
proc supercomments {} {
	set win .text
        set si [$win index "insert linestart"]
	set en [$win index insert]
	while {1} {
		set index1 [.text search -regexp -count count -- {/\*} $si $en] 
		set res $index1
		if {$res == ""} {
                        break
               }
		set index2 [.text search -regexp -count count -- {\*/} $index1 [.text index "insert lineend"]]
		if {$index2 == ""} {	
			.text insert [.text index "insert lineend"] " */"	
			set index2 [.text search -regexp -count count -- {\*/} $index1 [.text index "insert lineend"]]
		}
		set end [$win tag add supcomment $index1 "$index2 + $count chars"]
		set si $index2
	}
        $win tag configure supcomment -foreground orange -font {Helvetica 12 bold} 
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
$win tag configure var -foreground purple -font {Helvetica 12 bold}
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
$win tag configure var -foreground purple -font {Helvetica 12 bold}
}
proc fasthighlight {} {
bind .text <KeyRelease> {
	phpkeywords
	brace
	comments
	supercomments
	quotes
	var
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
        if {$tag == "phpwords"} {
                set si [$win index "insert linestart"]
                set en [$win index "insert lineend"]
        }
        if {$tag == "comments"} {
                set si [$win index insert]
                set en [$win index "insert lineend"]
        }
        if {$tag == "supcomment"} {
                set si [$win index insert]
                set en [$win index "insert lineend"]
        }
        if {$tag == "quotes"} {
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
        foreach tag  {phpwords comments quotes supcomment var} {
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
        if {$tag == "phpwords"} {
		set si [$win index "insert linestart"]
		set en [$win index "insert lineend"]            
        }
        if {$tag == "comments"} {
                set si [$win index insert]
                set en [$win index "insert lineend"]
        }
        if {$tag == "supcomment"} {
                set si [$win index insert]
                set en [$win index "insert lineend"]
        }
        if {$tag == "quotes"} {
                set si [$win index insert]
                set en [$win index "insert lineend"]
        }
        if {$tag == "var"} {
		set si [$win index "insert linestart"]
		set en [$win index "insert lineend"]
        }
        if {$tag == "sel"} {
                set si [$win index insert]
                set en [$win index "insert lineend"]
        }	 
        $win tag add temporal $si $en
        $win tag configure temporal -foreground black -font {Helvetica 12 normal}
        foreach tag  {phpwords comments quotes var supcomment} {
                $win tag remove $tag $si $en
        }
}
}
proc highlight {} {
	Phpkeywords
	Brace
	Comments
	Quotes
	Supercomments
	Var
}

