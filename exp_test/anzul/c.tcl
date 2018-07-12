#-----------------------------------------------------------------------------------
#       SYNTAX HIGHLIGHTING
proc Ckeywords {} {
        namespace eval tcl {
        variable cwords {
		auto break case char const continue default dodouble else enum extern float for goto if \
		int long register return short signed sizeof static struct switch typedef union unsigned void volatile while
	}
        set win .text
        set si 1.0
        while {1} {
        set res [$win search -count length -regexp "\\m([join $cwords {|}])\\M" $si end]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                set prevchar [$win get "$res - 1 chars"]
                        if {$prevchar == "\." || $prevchar == "\-" || $prevchar == "\$" || $prevchar == "\/"} {
                                set res end
                        }
                $win tag add cwords $res $end
                set si $end
        }
        $win tag configure cwords -foreground blue -font {Helvetica 12 bold}
        }
}
proc ckeywords {} {
        namespace eval tcl {
        variable cwords {
		auto break case char const continue default dodouble else enum extern float for goto if \
		int long register return short signed sizeof static struct switch typedef union unsigned void volatile while
	}
        set win .text
        set si [$win index "insert linestart"]
        set en [$win index "insert lineend"]
	$win tag remove temporal $si $en
        while {1} {
        set res [$win search -count length -regexp "\\m([join $cwords {|}])\\M" $si $en]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                set prevchar [$win get "$res - 1 chars"]
                        if {$prevchar == "\." || $prevchar == "\-" || $prevchar == "\$" || $prevchar == "\/"} {
                                set res end
                        }
                $win tag add cwords $res $end
                set si $end
        }
        $win tag configure cwords -foreground blue -font {Helvetica 12 bold}
        }
}
proc Cpluskeywords {} {
        namespace eval tcl {
        variable cpwords {
		bool catch class cout delete friend inline new namespace operator private protected public tempate this throw try template}
        set win .text
        set si 1.0
        while {1} {
        set res [$win search -count length -regexp "\\m([join $cpwords {|}])\\M" $si end]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                set prevchar [$win get "$res - 1 chars"]
                        if {$prevchar == "\." || $prevchar == "\-" || $prevchar == "\$" || $prevchar == "\/"} {
                                set res end
                        }
                $win tag add cpwords $res $end
                set si $end
        }
        $win tag configure cpwords -foreground red -font {Helvetica 12 bold}
        }
}
proc cpluskeywords {} {
        namespace eval tcl {
        variable cpwords {
		bool catch class cout delete friend inline new namespace operator private protected public tempate this throw try template	
	}
        set win .text
        set si [$win index "insert linestart"]
        set en [$win index "insert lineend"]
        while {1} {
        set res [$win search -count length -regexp "\\m([join $cpwords {|}])\\M" $si $en]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                set prevchar [$win get "$res - 1 chars"]
                        if {$prevchar == "\." || $prevchar == "\-" || $prevchar == "\$" || $prevchar == "\/"} {
                                set res end
                        }
                $win tag add cpwords $res $end
                set si $end
        }
        $win tag configure cpwords -foreground red -font {Helvetica 12 bold}
        }
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
        $win tag configure comments -foreground  green4 -font {Helvetica 12}
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
        $win tag configure comments -foreground green4 -font {Helvetica 12}
}
proc Preprocesor {} {
        set win .text
        set si 1.0
        set en [$win index "insert lineend"]
        while {1} {
                set res [$win search -count length -regexp {^[ \t]*\#[^ \t]*} $si end]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                $win tag add preprocesor $res $end
                set si $end
        }
        $win tag configure preprocesor -foreground purple -font {Helvetica 12}
}
proc preprocesor {} {
        set win .text
        set si [$win index "insert linestart"]
        set en [$win index "insert lineend"]
        while {1} {
                set res [$win search -count length -regexp {^[ \t]*\#[^ \t]*} $si end]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                $win tag add preprocesor $res $end
                set si $end
        }
        $win tag configure preprocesor -foreground purple -font {Helvetica 12}
}
proc Cstring {} {
        set win .text
        set si 1.0
        while {1} {
                set res [$win search -count length -regexp {"(?:[^\\])([^\"]|\\.)*"} $si end]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                $win tag add cstring $res $end
                set si $end
        }
        $win tag configure cstring -foreground #fe8e00 -font {Helvetica 12}
}
proc cstring {} {
        set win .text
        set si [$win index "insert linestart"]
        set en [$win index "insert lineend"]
        while {1} {
                set res [$win search -count length -regexp {"(?:[^\\])([^\"]|\\.)*"} $si end]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                $win tag add cstring $res $end
                set si $end
        }
        $win tag configure cstring -foreground #fe8e00 -font {Helvetica 12}
	
}
proc Cstring2 {} {
        set win .text
        set si 1.0
        while {1} {
                set res [$win search -count length -regexp {'(?:[^\\])([^\"]|\\.)*'} $si end]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                $win tag add cstring $res $end
                set si $end
        }
        $win tag configure cstring -foreground #fe8e00 -font {Helvetica 12}
}
proc cstring2 {} {
        set win .text
        set si [$win index "insert linestart"]
        set en [$win index "insert lineend"]
        while {1} {
                set res [$win search -count length -regexp {'(?:[^\\])([^\"]|\\.)*'} $si end]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                $win tag add cstring $res $end
                set si $end
        }
        $win tag configure cstring -foreground #fe8e00 -font {Helvetica 12}
	
}
proc Bstring {} {
        set win .text
        set si 1.0
        while {1} {
                set res [$win search -count length -regexp {<(?:[^\\])([^\"]|\\.)*>} $si end]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                $win tag add bstring $res $end
                set si $end
        }
        $win tag configure bstring -foreground #fe8e00 -font {Helvetica 12}
}
proc bstring {} {
        set win .text
        set si [$win index "insert linestart"]
        set en [$win index "insert lineend"]
        while {1} {
                set res [$win search -count length -regexp {<(?:[^\\])([^\"]|\\.)*>} $si end]
                if {$res == ""} {
                        break
                }
                set end "$res + $length chars"
                $win tag add bstring $res $end
                set si $end
        }
        $win tag configure bstring -foreground #fe8e00 -font {Helvetica 12}
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
       $win tag configure supcomment -foreground green4 
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
        $win tag configure supcomment -foreground green4 
}
proc fasthighlight {} {
bind .text <KeyRelease> {
	ckeywords
	cpluskeywords
	brace
	comments
	preprocesor
	supercomments
	cstring
	cstring2
	bstring
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
        if {$tag == "cwords" || $tag == "cpwords"} {
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
        if {$tag == "cstring" || $tag == "cstring2" || $tag == "bstring"} {
                set si [$win index insert]
                set en [$win index "insert lineend"]
        }
	if {$tag == "preprocesor"} {
                set si [$win index insert]
                set en [$win index "insert lineend"]
        }
        if {$tag == "sel"} {
                set si [$win index insert]
                set en [$win index "insert lineend"]
        }	 
        $win tag add temporal $si $en
        $win tag configure temporal -foreground black -font {Helvetica 12 normal}
        foreach tag  {cwords cpwords comments preprocesor cstring cstring2 bstring supcomment} {
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
        if {$tag == "cwords" || $tag == "cpwords"} {
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
        if {$tag == "supercomment"} {
                set si [$win index insert]
                set en [$win index "insert lineend"]
        }
        if {$tag == "cstring" || $tag == "cstring2" || $tag == "bstring"} {
                set si [$win index insert]
                set en [$win index "insert lineend"]
        }
	if {$tag == "preprocesor"} {
                set si [$win index insert]
                set en [$win index "insert lineend"]
        }
        if {$tag == "sel"} {
                set si [$win index insert]
                set en [$win index "insert lineend"]
        }	 
        $win tag add temporal $si $en
        $win tag configure temporal -foreground black -font {Helvetica 12 normal}
        foreach tag  {cwords cpwords comments preprocesor cstring cstring2 bstring supcomment} {
                $win tag remove $tag $si $en
        }
}
}
proc highlight {} {
       Ckeywords
	Cpluskeywords
	Brace
	Comments
	Cstring
	Cstring2
	Bstring
	Preprocesor
	Supercomments
}









