################################################################################
# patch pour tknotepad 0.7.9 pour obtenir le syntax highlihting
#
# Version: 0.0.1
#
# auteur: yves guerin, GPL 2004 - (C) copyright yves guerin, yvesguerin@yahoo.ca
################################################################################


################################################################################
# charge wcb package
################################################################################

#==============================================================================
# Contains common Wcb procedures.
#
# Copyright (c) 1999-2002  Csaba Nemethi (E-mail: csaba.nemethi@t-online.de)
#==============================================================================

#
# Namespace initialization
# ========================
#

namespace eval wcb {
    #
    # Bind some cleanup operations to the <Destroy> event
    # for all widgets having the binding tag WcbCleanup
    #
    bind WcbCleanup <Destroy> {
        wcb::cleanup %W
    }
}

#
# Basic procedures
# ================
#

#------------------------------------------------------------------------------
# wcb::callback
#
# Retrieves, sets, or removes the callbacks for the widget w, the argument
# when, and the command corresponding to option.  when can be "before" or
# "after", and option can take one of the following values:
#
#   - "insert", "delete", or "motion",	for an entry, spinbox, or text widget;
#   - "activate",			for a listbox or tablelist widget;
#   - "selset" or "selclear",		for a listbox, tablelist, or text
#					widget.
#
# If no arguments after the option parameter are specified, then the procedure
# just returns the current before- or after-callback list, respectively, for
# the given widget operation.
#
# Otherwise, if at least one of the arguments following the option parameter is
# a nonempty string, then:
#
#   - if called for the first time for this widget with at least one nonempty
#     argument following the option parameter, then it replaces the Tcl command
#     w with a new procedure in which the execution of the widget operations
#     associated with the above values of option is preceded by invocations of
#     the corresponding before-callbacks and followed by calls to the
#     corresponding after-callbacks, in the global scope;
#   - it sets the callback list to the one built from these arguments and
#     returns the new list.
#
# Otherwise (i.e. if all arguments following the option parameter are empty),
# then the procedure unregisters all the corresponding callbacks for the given
# widget and returns an empty string.
#
# When a callback is invoked, the name of the original Tcl command for the
# widget w as well as the command arguments are automatically appended to it as
# parameters.
#------------------------------------------------------------------------------
proc wcb::callback {w when option args} {
    if {![winfo exists $w]} {
        return -code error "bad window path name \"$w\""
    }
    
    if {[string first $when before] == 0} {
        set when before
    } elseif {[string first $when after] == 0} {
        set when after
    } else {
        return -code error "bad argument \"$when\": must be before or after"
    }
    
    if {[catch {fullCallbackOpt $w $option} result] != 0} {
        return -code error $result
    }
    set option $result
    
    variable data
    if {[llength $args] == 0} {
        if {[info exists data($w-$when-$option)]} {
            return $data($w-$when-$option)
        } else {
            return {}
        }
    } elseif {[areAllEmptyStrings $args]} {
        catch {unset data($w-$when-$option)}
        return ""
    } else {
        switch [winfo class $w] {
            Entry -
            Spinbox {
                set widgetCmd entryWidgetCmd
            }
            Listbox -
            Tablelist {
                set widgetCmd listboxWidgetCmd
            }
            Text {
                set widgetCmd textWidgetCmd
            }
        }
        redefWidgetCmd $w $widgetCmd
        return [set data($w-$when-$option) $args]
    }
}

#------------------------------------------------------------------------------
# wcb::cbappend
#
# Appends the arguments represented by args to the current before- or after-
# callback list, respectively, for the given widget operation.
#------------------------------------------------------------------------------
proc wcb::cbappend {w when option args} {
    if {[catch {callback $w $when $option} result] != 0} {
        return -code error $result
    }
    
    eval lappend result $args
    return [eval [list callback $w $when $option] $result]
}

#------------------------------------------------------------------------------
# wcb::cbprepend
#
# Prepends the arguments represented by args to the current before- or after-
# callback list, respectively, for the given widget operation.
#------------------------------------------------------------------------------
proc wcb::cbprepend {w when option args} {
    if {[catch {callback $w $when $option} result] != 0} {
        return -code error $result
    }
    
    set result [eval [list linsert $result 0] $args]
    return [eval [list callback $w $when $option] $result]
}

#------------------------------------------------------------------------------
# wcb::cancel
#
# If invoked from a before-callback for a widget command, this procedure
# cancels the execution of that command and of the remaining callbacks, and
# calls script in the global scope.
#------------------------------------------------------------------------------
proc wcb::cancel {{script bell}} {
    variable data
    set data(canceled-[info level 1]) 1
    
    if {[string compare $script ""] != 0} {
        uplevel #0 $script
    }
}

#------------------------------------------------------------------------------
# wcb::canceled
#
# Returns 1 if the most recent invocation of the widget operation correspondig
# to w and option has been aborted by some before-callback, and 0 otherwise.
#------------------------------------------------------------------------------
proc wcb::canceled {w option} {
    if {![winfo exists $w]} {
        return -code error "bad window path name \"$w\""
    }
    
    if {[catch {fullCallbackOpt $w $option} result] != 0} {
        return -code error $result
    }
    set option $result
    
    variable data
    if {[info exists data($w-canceled-$option)]} {
        return $data($w-canceled-$option)
    } else {
        return 0
    }
}

#------------------------------------------------------------------------------
# wcb::extend
#
# If invoked from a before-callback for a widget command, this procedure
# appends the values given in args to the argument list of that command.  The
# new argument list will be passed to the remaining callbacks for that command,
# too.
#------------------------------------------------------------------------------
proc wcb::extend args {
    variable data
    upvar 0 data(args-[info level 1]) var
    eval lappend var $args
}

#------------------------------------------------------------------------------
# wcb::replace
#
# If invoked from a before-callback for a widget command, this procedure
# replaces the arguments having the indices first through last of that command
# with the values given in args.  The new argument list will be passed to the
# remaining callbacks for that command, too.  The arguments are numbered from 0.
#------------------------------------------------------------------------------
proc wcb::replace {first last args} {
    variable data
    upvar 0 data(args-[info level 1]) var
    set var [eval [list lreplace $var $first $last] $args]
}

#------------------------------------------------------------------------------
# wvb::pathname
#
# Returns the path name of the widget corresponding to the Tcl command origCmd
# (which is supposed to be of the form "::_pathName").
#------------------------------------------------------------------------------
proc wcb::pathname origCmd {
    return [string range $origCmd 3 end]
}

#
# Private procedures
# ==================
#

#------------------------------------------------------------------------------
# wcb::cleanup
#
# Unregisters all callbacks defined for w and deletes the Tcl command w.
#------------------------------------------------------------------------------
proc wcb::cleanup w {
    variable data
    foreach when {before after canceled} {
        foreach option {insert delete motion activate selset selclear} {
            catch {unset data($w-$when-$option)}
        }
    }
    
    catch {rename ::$w ""}
    catch {rename ::_$w ""}		;# necessary for tablelist widgets
}

#------------------------------------------------------------------------------
# wcb::fullCallbackOpt
#
# Returns the full callback option corresponding to the possibly abbreviated
# option opt.
#------------------------------------------------------------------------------
proc wcb::fullCallbackOpt {w opt} {
    set opLen [string length $opt]
    if {[string first $opt insert] == 0} {
        set opt insert
    } elseif {[string first $opt delete] == 0} {
        set opt delete
    } elseif {[string first $opt motion] == 0} {
        set opt motion
    } elseif {[string first $opt activate] == 0} {
        set opt activate
    } elseif {[string first $opt selset] == 0 && $opLen >= 4} {
        set opt selset
    } elseif {[string first $opt selclear] == 0 && $opLen >= 4} {
        set opt selclear
    }
    
    switch [winfo class $w] {
        Entry -
        Spinbox {
            if {[string compare $opt insert] != 0 &&
                [string compare $opt delete] != 0 &&
                [string compare $opt motion] != 0} {
                return -code error \
                        "bad option \"$opt\": must be insert, delete, or motion"
            }
        }
        
        Listbox -
        Tablelist {
            if {[string compare $opt activate] != 0 &&
                [string compare $opt selset]   != 0 &&
                [string compare $opt selclear] != 0} {
                return -code error \
                        "bad option \"$opt\": must be activate, selset, or\
                        selclear"
            }
        }
        
        Text {
            if {[string compare $opt insert] != 0 &&
                [string compare $opt delete] != 0 &&
                [string compare $opt motion] != 0 &&
                [string compare $opt selset] != 0 &&
                [string compare $opt selclear] != 0} {
                return -code error \
                        "bad option \"$opt\": must be insert, delete, motion,\
                        selset, or selclear"
            }
        }
        
        default {
            return -code error \
                    "window \"$w\" is not an entry, spinbox, listbox,\
                    tablelist, or text widget"
        }
    }
    
    return $opt
}

#------------------------------------------------------------------------------
# wcb::areAllEmptyStrings
#
# Returns 1 if all elements of the list lst are empty strings and 0 otherwise.
#------------------------------------------------------------------------------
proc wcb::areAllEmptyStrings lst {
    foreach elem $lst {
        if {[string compare $elem ""] != 0} {
            return 0
        }
    }
    
    return 1
}

#------------------------------------------------------------------------------
# wcb::redefWidgetCmd
#
# Renames the Tcl command w to _w, builds a new widget procedure w that invokes
# cmd, and appends WcbCleanup to the list of binding tags of the widget w.
#------------------------------------------------------------------------------
proc wcb::redefWidgetCmd {w cmd} {
    if {[catch {rename ::$w ::_$w}] != 0} {
        return ""
    }
    
    #
    # If the command within the catch below returns an error, we
    # will substitute all occurrences of ::_$w with $w.  To this
    # end we need a version of $w in which the characters |, *, +,
    # ?, (, ., ^, $, \, [, {, }, ,, :, =, and ! are escaped, and
    # another version in which the characters & and \ are escaped
    # (to suppress the special processing of &, \0, \1, ..., \9).
    #
    regsub -all {\||\*|\+|\?|\(|\.|\^|\$|\\|\[|\{|\}|\,|\:|\=\!} $w {\\\0} w1
    regsub -all {&|\\} $w {\\\0} w2
    
    proc ::$w args [format {
        if {[catch {wcb::%s %s $args} result] == 0} {
            return $result
        } else {
            regsub -all -- %s $result %s result
            return -code error $result
        }
    } $cmd [list $w] [list ::_$w1] [list $w2]]
    
    bindtags $w [linsert [bindtags $w] end WcbCleanup]
}

#------------------------------------------------------------------------------
# wcb::processCmd
#
# Invokes the before-callbacks registered for the widget w and the command
# corresponding to wcbOp, then executes the script "::_w cmdOp argList", and
# finally invokes the after-callbacks.
#------------------------------------------------------------------------------
proc wcb::processCmd {w wcbOp cmdOp argList} {
    variable data
    set data($w-canceled-$wcbOp) 0
    set orig [list ::_$w]
    
    #
    # Invoke the before-callbacks
    #
    if {[info exists data($w-before-$wcbOp)]} {
        foreach cb $data($w-before-$wcbOp) {
            if {[string compare $cb ""] != 0} {
                #
                # Set the two array elements that might be changed
                # by cancel, extend, or replace, invoked (directly
                # or indirectly) from within the callback
                #
                set cb [eval list $cb]
                set cbScript [concat $cb $orig $argList]
                set data(canceled-$cbScript) 0
                set data(args-$cbScript) $argList
                
                #
                # Invoke the callback and get the new
                # values of the two array elements
                #
                uplevel #0 $cb $orig $argList
                set data($w-canceled-$wcbOp) $data(canceled-$cbScript)
                set argList $data(args-$cbScript)
                
                #
                # Remove the two array elements
                #
                unset data(canceled-$cbScript)
                unset data(args-$cbScript)
                
                if {$data($w-canceled-$wcbOp)} {
                    return ""
                }
            }
        }
    }
    
    #
    # Execute the widget command
    #
    eval $orig $cmdOp $argList
    
    #
    # Invoke the after-callbacks
    #
    if {[info exists data($w-after-$wcbOp)]} {
        foreach cb $data($w-after-$wcbOp) {
            if {[string compare $cb ""] != 0} {
                uplevel #0 $cb $orig $argList
            }
        }
    }
}



#==============================================================================
# Contains Wcb procedures for text widgets.
#
# Copyright (c) 1999-2002  Csaba Nemethi (E-mail: csaba.nemethi@t-online.de)
#==============================================================================

#
# Namespace initialization
# ========================
#

namespace eval wcb {
    #
    # Some regexp patterns:
    #
    if {$tk_version >= 8.1} {
        variable alphaOrNlPat	{^[[:alpha:]\n]*$}
        variable digitOrNlPat	{^[[:digit:]\n]*$}
        variable alnumOrNlPat	{^[[:alnum:]\n]*$}
    } else {
        # Ugly because of the \n:
        variable alphaOrNlPat	"^\[A-Za-z\n]*$"
        variable digitOrNlPat	"^\[0-9\n]*$"
        variable alnumOrNlPat	"^\[A-Za-z0-9\n]*$"
    }
}

#
# Simple before-insert callback routines for text widgets
# =======================================================
#

#------------------------------------------------------------------------------
# wcb::checkStrsForRegExp
#
# Checks whether the strings to be inserted into the text widget w, contained
# in the list args of the form "string ?tagList string tagList ...?", are
# matched by the regular expression exp; if not, it cancels the insert
# operation.
#------------------------------------------------------------------------------
proc wcb::checkStrsForRegExp {exp w idx args} {
    foreach {str tagList} $args {
        if {![regexp -- $exp $str]} {
            cancel
            return ""
        }
    }
}

#------------------------------------------------------------------------------
# wcb::checkStrsForAlpha
#
# Checks whether the strings to be inserted into the text widget w, contained
# in the list args of the form "string ?tagList string tagList ...?", are
# alphabetic; if not, it cancels the insert operation.
#------------------------------------------------------------------------------
proc wcb::checkStrsForAlpha {w idx args} {
    variable alphaOrNlPat
    checkStrsForRegExp $alphaOrNlPat $w $idx $args
}

#------------------------------------------------------------------------------
# wcb::checkStrsForNum
#
# Checks whether the strings to be inserted into the text widget w, contained
# in the list args of the form "string ?tagList string tagList ...?", are
# numeric; if not, it cancels the insert operation.
#------------------------------------------------------------------------------
proc wcb::checkStrsForNum {w idx args} {
    variable digitOrNlPat
    checkStrsForRegExp $digitOrNlPat $w $idx $args
}

#------------------------------------------------------------------------------
# wcb::checkStrsForAlnum
#
# Checks whether the strings to be inserted into the text widget w, contained
# in the list args of the form "string ?tagList string tagList ...?", are
# alphanumeric; if not, it cancels the insert operation.
#------------------------------------------------------------------------------
proc wcb::checkStrsForAlnum {w idx args} {
    variable alnumOrNlPat
    checkStrsForRegExp $alnumOrNlPat $w $idx $args
}

#------------------------------------------------------------------------------
# wcb::convStrsToUpper
#
# Replaces the strings to be inserted into the text widget w, contained in the
# list args of the form "string ?tagList string tagList ...?", with their
# uppercase equivalents.
#------------------------------------------------------------------------------
proc wcb::convStrsToUpper {w idx args} {
    set n 1
    foreach {str tagList} $args {
        replace $n $n [string toupper $str]
        incr n 2
    }
}

#------------------------------------------------------------------------------
# wcb::convStrsToLower
#
# Replaces the strings to be inserted into the text widget w, contained in the
# list args of the form "string ?tagList string tagList ...?", with their
# lowercase equivalents.
#------------------------------------------------------------------------------
proc wcb::convStrsToLower {w idx args} {
    set n 1
    foreach {str tagList} $args {
        replace $n $n [string tolower $str]
        incr n 2
    }
}

#
# Private procedure
# =================
#

#------------------------------------------------------------------------------
# wcb::textWidgetCmd
#
# Processes the Tcl command corresponding to a text widget w with registered
# callbacks.  In this procedure, the execution of the commands insert, delete,
# and mark set insert is preceded by calls to the corresponding before-
# callbacks and followed by calls to the corresponding after-callbacks, in the
# global scope.
#------------------------------------------------------------------------------
proc wcb::textWidgetCmd {w argList} {
    set orig [list ::_$w]
    
    set argCount [llength $argList]
    if {$argCount == 0} {
        # Let Tk report the error
        return [uplevel 2 $orig $argList]
    }
    
    set option [lindex $argList 0]
    set opLen [string length $option]
    set opArgs [lrange $argList 1 end]
    
    if {[string first $option insert] == 0 && $opLen >= 3} {
        if {$argCount >= 2} {
            return [wcb::processCmd $w insert insert $opArgs]
        } else {
            # Let Tk report the error
            return [uplevel 2 $orig $argList]
        }
        
    } elseif {[string first $option delete] == 0 && $opLen >= 3} {
        if {$argCount == 2 || $argCount == 3} {
            return [wcb::processCmd $w delete delete $opArgs]
        } else {
            # Let Tk report the error
            return [uplevel 2 $orig $argList]
        }
        
    } elseif {[string first $option mark] == 0} {
        set markOption [lindex $opArgs 0]
        
        if {[string first $markOption set] == 0} {
            if {$argCount == 4 &&
                [string compare [lindex $opArgs 1] insert] == 0} {
                set markOpArgs [lrange $opArgs 2 end]
                return [wcb::processCmd $w motion "mark set insert" \
                        $markOpArgs]
            } else {
                return [uplevel 2 $orig $argList]
            }
        } else {
            return [uplevel 2 $orig $argList]
        }
        
    } elseif {[string first $option tag] == 0} {
        set tagOption [lindex $opArgs 0]
        
        if {[string first $tagOption add] == 0} {
            if {$argCount >= 4 &&
                [string compare [lindex $opArgs 1] sel] == 0} {
                set selOpArgs [lrange $opArgs 2 end]
                return [wcb::processCmd $w selset "tag add sel" \
                        $selOpArgs]
            } else {
                return [uplevel 2 $orig $argList]
            }
        } elseif {[string first $tagOption remove] == 0} {
            if {$argCount >= 4 &&
                [string compare [lindex $opArgs 1] sel] == 0} {
                set selOpArgs [lrange $opArgs 2 end]
                return [wcb::processCmd $w selclear "tag remove sel" \
                        $selOpArgs]
            } else {
                return [uplevel 2 $orig $argList]
            }
        } else {
            return [uplevel 2 $orig $argList]
        }
        
    } else {
        return [uplevel 2 $orig $argList]
    }
}

#==============================================================================
# Main Wcb package module.
#
# Copyright (c) 1999-2002  Csaba Nemethi (E-mail: csaba.nemethi@t-online.de)
#==============================================================================

package require Tcl 8
package require Tk  8

namespace eval wcb {
    #
    # Public variables:
    #
    variable version	2.8
    variable library	[file dirname [info script]]
    
    #
    # Basic procedures:
    #
    namespace export	callback cbappend cbprepend cancel canceled \
            extend replace pathname
    
    #
    # Utility procedures for entry and spinbox widgets:
    #
    namespace export	changeEntryText postInsertEntryLen postInsertEntryText
    
    #
    # Simple before-insert callback routines for entry and spinbox widgets:
    #
    namespace export	checkStrForRegExp checkStrForAlpha checkStrForNum \
            checkStrForAlnum convStrToUpper convStrToLower
    
    #
    # Further before-insert callback routines for entry and spinbox widgets:
    #
    namespace export	checkEntryForInt  checkEntryForUInt \
            checkEntryForReal checkEntryForFixed \
            checkEntryLen
    
    #
    # Simple before-insert callback routines for text widgets:
    #
    namespace export	checkStrsForRegExp checkStrsForAlpha checkStrsForNum \
            checkStrsForAlnum convStrsToUpper convStrsToLower
}

package provide Wcb $wcb::version
package provide wcb $wcb::version

#lappend auto_path [file join $wcb::library scripts]

################################################################################
# charge markup.tcl
################################################################################

# markup.tcl --
#
#     Syntax highlighting for the Tk text widget
#
# Copyright (C) 2002  Brian P. Theado
#
# See the file "license.terms" for information on usage and redistribution
# of this file, and for a DISCLAIMER OF ALL WARRANTIES.
#
package require wcb
namespace eval markup {
    namespace export addRule removeRule rehighlight enableHighlighting flashTag
    
    proc getTagRange {win tag index} {
        set indices [$win tag prevrange $tag $index]
        if {([llength $indices] == 0) ||
            [$win compare [lindex $indices 1] < $index]} {
            set indices [$win tag nextrange $tag $index]
        }
        return $indices
    }
    proc tagUntilLeaveEvent {win tag startIdx endIdx} {
        $win tag raise $tag
        $win tag add $tag $startIdx $endIdx
        $win tag bind $tag <Any-Leave> \
                "$win tag remove $tag $startIdx $endIdx;\
                event generate $win <Enter>"
    }
    
    # Configures the given tag so that any mouseover event
    # will cause the given flashtag to be applied until the
    # mouse leaves the tag
    proc flashTag {win tag flashTag} {
        $win tag bind $tag <Any-Enter> "eval ::markup::tagUntilLeaveEvent $win $flashTag \[::markup::getTagRange $win $tag @%x,%y]"
    }
    
    # Use marks instead of a tag because there may be no text in
    # the widget to tag (i.e. before the first insert)
    proc markRange {win startIdx endIdx} {
        $win mark set rehighlight:left $startIdx
        $win mark gravity rehighlight:left left
        $win mark set rehighlight:right $endIdx
        $win mark gravity rehighlight:right right
    }
    proc markInsertLine {win idx args} {
        if {![isHighlightInProgress $win]} {
            set startIdx "$idx linestart"
            set endIdx "$idx lineend"
            markRange $win $startIdx $endIdx
        }
    }
    proc markDelLine {win idx1 {idx2 ""}} {
        set idx1 [$win index "$idx1 linestart"]
        if {[string length $idx2] == 0} {
            set idx2 "$idx1 lineend"
        } else {
            set idx2 [$win index "$idx2 lineend"]
        }
        markRange $win $idx1 $idx2
    }
    proc isHighlightInProgress {win} {
        return [expr [lsearch [$win mark names] rehighlight:in_progress] >= 0]
    }
    proc rehighlightMarkedRange {win} {
        if {![isHighlightInProgress $win]} {
            $win mark set rehighlight:in_progress end
            rehighlight $win rehighlight:left rehighlight:right
            $win mark unset rehighlight:in_progress
            $win mark unset rehighlight:left
            $win mark unset rehighlight:right
        }
    }
    proc suspend {win} {
        $win mark set rehighlight:in_progress end
    }
    proc resume {win} {
        $win mark unset rehighlight:in_progress
    }
    proc enableHighlighting {win} {
        if {[lsearch [wcb::callback $win before insert] ::markup::markInsertLine] < 0} {
            wcb::cbappend $win before insert ::markup::markInsertLine
            wcb::cbappend $win after insert ::markup::rehighlightWrapper
            wcb::cbappend $win before delete ::markup::markDelLine
            wcb::cbappend $win after delete ::markup::rehighlightWrapper
        }
    }
    proc unhighlight {win startIdx endIdx} {
        variable patterns
        
        # Construct a list of tags to remove
        set tags {}
        foreach key [array names patterns $win,*] {
            array set p $patterns($key)
            set tags [concat $tags $p(tag) $p(auxTags)]
            unset p
        }
        
        # Remove the tags
        foreach tag $tags {
            $win tag remove $tag $startIdx $endIdx
        }
    }
    
    proc rehighlight {win startIdx endIdx} {
        variable patterns
        
        # Convert indices to numbers in case any callback modifies text and causes
        # any mark based indices to be deleted
        set startIdx [$win index $startIdx]
        set endIdx [$win index $endIdx]
        unhighlight $win $startIdx $endIdx
        foreach key [array names patterns $win,*] {
            set pattern [string range $key [expr [string first , $key] + 1] end]
            array set p $patterns($key)
            
            if {$p(regexp)} {
                set opts {-regexp -count len}
            } else {
                set opts ""
                set len [string length $pattern]
            }
            
            #puts "opts: $opts"
            
            # Find all matches for the current pattern
            set matchIdxs {}
            set idx [eval $win search -elide $opts [list $pattern $startIdx $endIdx+1c]]
            
            #puts "idx: $idx, opts: $opts, pattern:$pattern"
            
            while {[string length $idx] > 0} {
                lappend matchIdxs $idx $idx+${len}c
                set idx [eval $win search -elide $opts [list $pattern $idx+[expr $len]c $endIdx+1c]]
                #puts "l:idx: $idx, opts: $opts, pattern:$pattern"
            }
            
            # Apply tags to each of the matches found
            foreach {matchStart matchEnd} $matchIdxs {
                if {[string length $p(tag)] > 0} {
                    $win tag add $p(tag) $matchStart $matchEnd
                }
                if {[string length $p(callback)] > 0} {
                    set p(auxTags) [eval [concat $p(callback) $win $matchStart $matchEnd]]
                    set patterns($key) [array get p]
                }
            }
            unset p
        }
    }
    proc rehighlightWrapper {win args} {
        # Remove the underscore from the window name
        set origWin [string range [namespace tail $win] 1 end]
        rehighlightMarkedRange $origWin
    }
    proc addRule {win args} {
        variable patterns
        if {[lindex $args 0] == "-regexp"} {
            set p(regexp) 1
            set args [lrange $args 1 end]
        } else {
            set p(regexp) 0
        }
        set pattern [lindex $args 0]
        set args [lrange $args 1 end]
        set p(tag) {}
        set p(callback) {}
        set p(auxTags) {}
        switch -- [lindex $args 0] {
            -tag {set p(tag) [lindex $args 1]}
            -callback {set p(callback) [lindex $args 1]}
            default {error "[lindex $args 0] should be -tag or -callback"}
        }
        if {[llength [array names pattern $win*]] == 0} {
            bind $win <Destroy> "+::markup::removeRules %W"
        }
        set patterns($win,$pattern) [array get p]
    }
    proc removeRules {win} {
        variable patterns
       
        foreach key [array names patterns $win*] {
            unset patterns($key)
        }
    }
    proc removeRule {win pattern} {
        variable patterns
        unset patterns($win,$pattern)
    }
}

package provide markup 0.1


################################################################################
# debut code highlight
################################################################################



#######################################################################################
# hl:dlgTag
#	fonction permettant d'afficher les tags du .textarea
#
# Entree:
#    - root: la racine ou le parent de la dlg
#    - args: les arguments
#
# Sortie: neant
#
# Remarques: fait avec SpecTcl.
#
# Auteur:
#    Yves guerin - 2004


proc hl:dlgTag {root args} {
    
    # this treats "." as a special case
    
    if {$root == "."} {
        set base ""
    } else {
        set base $root
        toplevel $base
        wm title $base "Highlight tags"
        wm geometry $base 300x200
        wm focusmodel $base passive
    }
    
    listbox $base.listbox#1 \
            -height 0 \
            -width 0 \
            -xscrollcommand "$base.scrollbar#2 set" \
            -yscrollcommand "$base.scrollbar#1 set" \
            -background white \
            -selectbackground blue \
            -selectforeground white
    
    scrollbar $base.scrollbar#1 \
            -command "$base.listbox#1 yview"
    
    scrollbar $base.scrollbar#2 \
            -command "$base.listbox#1 xview" \
            -orient horizontal
    
    button $base.button#1 \
            -cursor hand2 \
            -text Close \
            -command "destroy $base" \
            -activeforeground red
    
    
    # Geometry management
    
    grid $base.listbox#1 -in $root	-row 1 -column 1  \
            -sticky nesw
    grid $base.scrollbar#1 -in $root	-row 1 -column 2  \
            -sticky nsw
    grid $base.scrollbar#2 -in $root	-row 2 -column 1  \
            -sticky new
    grid $base.button#1 -in $root	-row 3 -column 1  \
            -columnspan 2
    
    # Resize behavior management
    
    grid rowconfigure $root 1 -weight 1 -minsize 30
    grid rowconfigure $root 2 -weight 0 -minsize 30
    grid rowconfigure $root 3 -weight 0 -minsize 30
    grid columnconfigure $root 1 -weight 1 -minsize 30
    grid columnconfigure $root 2 -weight 0 -minsize 30
    # additional interface code
    # end additional interface code
    
    # rempli la listbox des tags
    set lstTag [.textarea tag names]
    
    foreach item [lsort $lstTag] {
        $base.listbox#1 insert end $item
    }
    
    focus $base.button#1
    
    return
    
}


#######################################################################################
# hl:effaceSyntax
#	fonction permettant d'arreter le highlight (interface)
#
# Entree: neant
#    
# Sortie: neant
#
#
# Auteur:
#    Yves guerin - 2004

proc hl:effaceSyntax {} {
    # enleve highlight
    ::markup::unhighlight .textarea 1.0 end

    return
}

#######################################################################################
# hl:faireSyntax
#	fonction permettant de demarrer le highlight (interface)
#
# Entree: neant
#
# Sortie: neant
#
#
# Auteur:
#    Yves guerin - 2004

proc hl:faireSyntax {} {
    ::markup::rehighlight .textarea 1.0 end
}

#######################################################################################
# hl:ouvrirFichierSyntax
#	fonction permettant de sourcer le fichier de regles pour les tags
#
# Entree: neant
#
# Sortie: neant
#
#
# Auteur:
#    Yves guerin - 2004


proc hl:ouvrirFichierSyntax {} {
    upvar #0 etatSyntax syntax
    
    set parent .
    
    set typeFichier {
        {"Rules set" {.rls}}
        {"Tcl/Tk" {.tcl .TCL .tk .TK}}
        {"All" {*}}
    }
    
    set reponse [tk_getOpenFile -initialdir [pwd] -filetypes $typeFichier -title "Open rules set" -parent $parent]
    
    # verif si annuler
    if {$reponse != ""} {
        # avant de faire un source
        # faut nettoyer
        ::markup::removeRules .textarea
        
        # fait un source
        if {[catch { source $reponse} erreur]} {
            # err
            tk_messageBox -icon error -message "Source error:\n$erreur" -title "Error" -parent $parent
        } else  {
            # enable menu tous le menu hl
            .filemenu.hl entryconfigure 0 -label "Syntax file: [file tail $reponse]"
            .filemenu.hl entryconfigure 2 -state normal
            
            # demande util s'il veut highlight on, a OFF actuellement
            if {[expr [string compare $syntax off]== 0]} {
                set reponse  [tk_messageBox -icon info -message "Do you want to put the highlight ON" -type yesno -parent . -default yes]
                
                if {[expr [string compare $reponse yes]== 0]} {
                    # il le veut
                    set syntax on
                    hl:verifSyntax
                    
                    .filemenu.hl.cascade entryconfigure 2 -state disabled
                }
                
            } else {
                # deja a ON, refaire change les regles
                set syntax on
                hl:verifSyntax
                
            }
        }
    }
    
    return
}


#######################################################################################
# hl:resumeSyntax
#	fonction permettant de redemarrer le highlight (interface)
#
# Entree: neant
#
# Sortie: neant
#
#
# Auteur:
#    Yves guerin - 2004

proc hl:resumeSyntax {} {
    # retour highlight
    ::markup::resume .textarea
    
    # disable menu resume
    .filemenu.hl.cascade entryconfigure 2 -state disabled
    
    # enable menu suspend
    .filemenu.hl.cascade entryconfigure 3 -state normal
    
    return
}

#######################################################################################
# hl:suspendSyntax
#	fonction permettant de suspendre le highlight (interface)
#
# Entree: neant
#
# Sortie: neant
#
#
# Auteur:
#    Yves guerin - 2004

proc hl:suspendSyntax {} {
    # stop highlight
    ::markup::suspend .textarea
    
    # disable menu suspend
    .filemenu.hl.cascade entryconfigure 3 -state disabled
    
    # enable menu resume
    .filemenu.hl.cascade entryconfigure 2 -state normal

}    


#######################################################################################
# hl:verifSyntax
#	fonction permettant de demarrer le highlight (interface)
#
# Entree: neant
#
# Sortie: neant
#
#
# Auteur:
#    Yves guerin - 2004

proc hl:verifSyntax {} {
    upvar #0 etatSyntax syntax
    
    # verif si off
    if {[expr [string compare $syntax off] == 0]} {
        .filemenu.hl entryconfigure 3 -state disabled
        
        if {[.textarea get 1.0 end] != ""} {
            # non vide
            ::markup::unhighlight .textarea 1.0 end
        }
    } else  {
        ::markup::enableHighlighting .textarea
        ::markup::rehighlight .textarea 1.0 end
        
        .filemenu.hl entryconfigure 3 -state normal
    }
    
    return
}


# menu highlight
menu .filemenu.hl -tearoff 0 -font $menuFont
menu .filemenu.hl.cascade -tearoff 0 -font $menuFont

.filemenu  add cascade -label "Highlight" -underline 1 -menu .filemenu.hl
.filemenu.hl add command -label "Syntax file: none" -underline 2 -command {hl:ouvrirFichierSyntax}
.filemenu.hl add separator
.filemenu.hl add check -label "highlight syntax" -variable etatSyntax -underline 2 -command {hl:verifSyntax} -state disabled \
        -onvalue on -offvalue off

set etatSyntax off

.filemenu.hl add cascade -label "highlight commands" -underline 4 -state disabled -menu .filemenu.hl.cascade
.filemenu.hl.cascade add command -label "Clear highlight" -underline 0 -command {hl:effaceSyntax}
.filemenu.hl.cascade add command -label "Re-highlight" -underline 0 -command {hl:faireSyntax}
.filemenu.hl.cascade add command -label "Resume" -underline 1 -command {hl:resumeSyntax}
.filemenu.hl.cascade add command -label "Suspend" -underline 0 -command {hl:suspendSyntax}
.filemenu.hl add command -label "Highlight tag..." -underline 8 -command {hl:dlgTag .dlgtag}





