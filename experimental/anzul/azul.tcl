#!/usr/bin/wish
##################################################################################################
# Editor - Azul Code Editor - ver 1.11
# Author: Luis Rodriguez
# Email: luis.rodriguez@equifax.com.sv
##################################################################################################
#       WIDGETS PROGRAMMING
##################################################################################################
#       MAIN FRAME 
wm title . "Azul Code Editor"
wm iconname . "Azul Code Editor"
wm minsize . 1 1
#-----------------------------------------------------------------------------------
#       MENU BAR
frame .menu -relief raised -bd 2 -bg navy 
pack .menu -side top -fill x
#-----------------------------------------------------------------------------------
#       ICON BAR
set icons icons
image create photo inew -file $icons/filenew.gif
image create photo iopen -file $icons/fileopen.gif
image create photo isave -file $icons/filesave.gif
image create photo iprint -file $icons/fileprint.gif
image create photo icopy -file $icons/editcopy.gif
image create photo ipaste -file $icons/editpaste.gif
image create photo ifind -file $icons/editfind.gif
frame .icons -bd 2 -relief raised -bg grey
pack .icons -fill x
button .icons.but1 -image inew -relief flat -command FileNew -highlightbackground grey -bg grey -activebackground #cdcec8
button .icons.but2 -image iopen -relief flat -command FileOpen -highlightbackground grey -bg grey -activebackground #cdcec8
button .icons.but3 -image isave -relief flat -command FileSave -highlightbackground grey -bg grey -activebackground #cdcec8
button .icons.but4 -image iprint -relief flat -command FilePrint -highlightbackground grey -bg grey -activebackground #cdcec8
button .icons.but5 -image icopy -relief flat -command EditCopy -highlightbackground grey -bg grey -activebackground #cdcec8
button .icons.but6 -image ipaste -relief flat -command EditPaste -highlightbackground grey -bg grey -activebackground #cdcec8
button .icons.but7 -image ifind -relief flat -command EditFind -highlightbackground grey -bg grey -activebackground #cdcec8
label .icons.lines -fg blue -text Line: -highlightbackground grey -bg grey
label .icons.count -width 5 -fg blue -relief sunken -highlightbackground grey -bg grey
pack .icons.but1 .icons.but2 .icons.but3 .icons.but4 .icons.but5 .icons.but6 .icons.but7 .icons.lines .icons.count -side left
#------------------------------------------------------------------------------------------------------------------------------------
#       SCROLL AND EDIT AREA
text .text -fg black -bg white -yscrollcommand ".scrolly set" -xscrollcommand ".scrollx set" -font "helvetica 12" -setgrid true -wrap none -selectbackground CornflowerBlue -insertbackground blue -tabs {1c left}
scrollbar .scrolly -command ".text yview" -bg grey -highlightbackground #cdcec8 -activebackground #cdcec8
scrollbar .scrollx -command ".text xview" -orient horizontal -bg grey -highlightbackground #cdcec8 -activebackground #cdcec8
pack .scrolly  -side right -fill both
pack .text -side left -expand 1 -fill both
pack .scrollx  -side bottom -after .scrolly -fill x
set counter [.text index insert] 
set linea [lindex [split $counter .] 0]
.icons.count configure -text $linea 
#-----------------------------------------------------------------------------------
#       MAIN MENU BUTTONS
menubutton .menu.file -text File -underline 0 -menu .menu.file.menu -bg navy -fg white -activeforeground white -activebackground #107aef
menubutton .menu.edit -text Edit -underline 0 -menu .menu.edit.menu -bg navy -fg white -activeforeground white -activebackground #107aef
button .menu.about -text About -relief flat -bg navy -fg white -activebackground #107aef -activeforeground white -command About -highlightbackground navy
pack .menu.file .menu.edit -side left
pack .menu.about -side right
#-----------------------------------------------------------------------------------
#       FILE SUB MENU 
menu .menu.file.menu -tearoff 0 -bg navy -fg white -activebackground #107aef -activeforeground white
.menu.file.menu add command -label New -accelerator "Ctrl-N" -command FileNew
.menu.file.menu add command -label Open -accelerator "Ctrl-O" -command FileOpen
.menu.file.menu add command -label Save -accelerator "Ctrl-S" -command FileSave
.menu.file.menu add command -label Print -accelerator "Ctrl-P" -command FilePrint
.menu.file.menu add command -label Quit -command exit
#-----------------------------------------------------------------------------------
#       EDIT SUB MENU
menu .menu.edit.menu -tearoff 0 -bg navy -fg white -activebackground #107aef -activeforeground white
.menu.edit.menu add command -label Copy -accelerator "Ctrl-C" -command EditCopy
.menu.edit.menu add command -label Paste -accelerator "Ctrl-V" -command EditPaste
.menu.edit.menu add command -label Find -accelerator "Ctrl-F" -command EditFind
##################################################################################################
#       FAST KEYS
##################################################################################################
focus .text
set shortcut .text
bind $shortcut <Control-N> "FileNew ;break"
bind $shortcut <Control-n> "FileNew ;break"
bind $shortcut <Control-O> "FileOpen ;break"
bind $shortcut <Control-o> "FileOpen ;break"
bind $shortcut <Control-S> "FileSave ;break"
bind $shortcut <Control-s> "FileSave ;break"
bind $shortcut <Control-C> "tk_textCopy $shortcut ;break"
bind $shortcut <Control-c> "tk_textCopy $shortcut ;break"
bind $shortcut <Control-V> "tk_textPaste $shortcut ;break"
bind $shortcut <Control-v> "tk_textPaste $shortcut ;break"
bind $shortcut <Control-F> "EditFind ;break"
bind $shortcut <Control-f> "EditFind ;break"
bind $shortcut <Control-P> "FilePrint ;break"
bind $shortcut <Control-p> "FilePrint ;break"
bind .text <ButtonRelease> {
        set counter [.text index insert]
        set linea [lindex [split $counter .] 0]
        set counter [.text index insert]
        .icons.count configure -text $linea
}
bind .text <KeyRelease> {
        set counter [.text index insert]
        set linea [lindex [split $counter .] 0]
        set counter [.text index insert]
        .icons.count configure -text $linea
}
        source bash.tcl  
	highlight
	fasthighlight
##################################################################################################
#       PROCEDURES
##################################################################################################
#       FILE NEW
proc FileNew {} {
        .text delete 1.0 end
        set counter [.text index insert]
        set linea [lindex [split $counter .] 0]
        .icons.count configure -text $linea
        wm title . "Azul Code Editor"
        source bash.tcl  
	highlight
	fasthighlight
	.text configure -fg black -font {Helvetica 12 normal}
}
#-----------------------------------------------------------------------------------
#       FILE OPEN
proc FileOpen {} {
        set file_name [tk_getOpenFile]
        .text delete 1.0 end
        if {[string compare $file_name {} ] == 0} then {return}
        set file_channel [open $file_name r]
        while {![eof $file_channel]} {
                .text insert end [read $file_channel 1000]
        }
        close $file_channel
	set prearchivo [string range $file_name [ string last / $file_name] end]
	set archivo [string trim $prearchivo /] 
        wm title . "Azul Code Editor          Archivo: $archivo                              Path:  $file_name"
        focus .text
        set preextension [string range $archivo [ string last . $archivo] end]
        set extension [string trim $preextension .]
        if {$extension == "tcl"} {
	        source tcl.tcl  
		highlight
  		fasthighlight
		.text configure -fg black -font {Helvetica 12 normal}
	} elseif {$extension == "c" || $extension == "cp" || $extension == "cpp" || $extension == "h" || $extension == "hp" || $extension == "hpp"} {
	        source c.tcl  
		highlight
  		fasthighlight
		.text configure -fg black -font {Helvetica 12 normal}
	} elseif {$extension == "php" || $extension == "php3" || $extension == "phtml" || $extension == "phtm3" || $extension == "phtml3" || $extension == "html" || $extension == "htm"} {
	        source php.tcl  
		highlight
  		fasthighlight
		.text configure -fg blue -font {Helvetica 12 bold}
        } else {
		source bash.tcl  
		highlight
  		fasthighlight
		.text configure -fg black -font {Helvetica 12 normal}
        }	
}
#-----------------------------------------------------------------------------------
#       FILE SAVE
proc FileSave {} {
        set file_name [tk_getSaveFile]
        if {[string compare $file_name {} ] == 0} then {return}
        set file_channel [open $file_name w]
        puts $file_channel [.text get 1.0 end]
        close $file_channel
	set prearchivo [string range $file_name [ string last / $file_name] end]
	set archivo [string trim $prearchivo /] 
        wm title . "Azul Code Editor          Archivo: $archivo                              Path:  $file_name"
        focus .text
        set preextension [string range $archivo [ string last . $archivo] end]
        set extension [string trim $preextension .]
        if {$extension == "tcl"} {
	        source tcl.tcl  
		highlight
  		fasthighlight
		.text configure -fg black -font {Helvetica 12 normal}
	} elseif {$extension == "c" || $extension == "cp" || $extension == "cpp" || $extension == "h" || $extension == "hp" || $extension == "hpp" } {
	        source c.tcl  
		highlight
  		fasthighlight
		.text configure -fg black -font {Helvetica 12 normal}
	} elseif {$extension == "php" || $extension == "php3" || $extension == "phtml" || $extension == "phtm3" || $extension == "phtml3" || $extension == "html" || $extension == "htm"} {
	        source php.tcl  
		highlight
  		fasthighlight
		.text configure -fg blue -font {Helvetica 12 bold}
        } else {
	        source bash.tcl  
		highlight
  		fasthighlight
		.text configure -fg black -font {Helvetica 12 normal}
        }	
}
#-----------------------------------------------------------------------------------
#       FILE PRINT
proc FilePrint {} {
        exec enscript << [.text get 1.0 end]
}
#-----------------------------------------------------------------------------------
#       EDIT COPY
proc EditCopy {} {
    tk_textCopy .text
}
#-----------------------------------------------------------------------------------
#       EDIT PASTE
proc EditPaste {} {
        tk_textPaste .text
}
#-----------------------------------------------------------------------------------
#       FIND TEXT WINDOW
proc EditFind {} {
        set find .find
        set con 0
        set cur 1.0
        toplevel $find
        wm title $find "Find"
        wm resizable $find 0 0
        set label [label $find.label -text "Find text"]
        set entry [entry $find.entry -textvariable string -width 30 -bg white -fg black ]
        bind $entry <Return> ".find.ok invoke"
        pack $label
        pack $entry -side left -padx 4 -pady 4
        set ok [button $find.ok -text Ok -command "EditFindText \$string $con $cur"]
        set close [button $find.close -text Close -command "destroy $find" ]
        pack $ok -after $entry -side left -padx 5 -pady 5
        pack $close -after $entry -side right -padx 5 -pady 5
        focus $entry
        bind $entry <Escape> "destroy $find ;break"
}
#-----------------------------------------------------------------------------------
#       FIND TEXT
proc EditFindText {string con cur} {
        if {$con == 0} {
                set cur [.text search $string 1.0 end]
                if {[string compare $cur {}] == 0} then {
                        tk_messageBox -type ok -icon info -message {No text found}
                raise .find
                return
                }
                .text tag add sel $cur [tkTextNextWord .text $cur]
                .text mark set insert $cur
                .text see insert
                set ok [.find.ok configure -text OK -command "EditFindText \$string [set con 1] $cur"]
                pack .find.ok -after .find.entry -side left -padx 5 -pady 5
        } else  {                       
                set cur [tkTextNextWord .text $cur]
                .text tag remove sel 1.0 end
                set cur [.text search $string $cur end]
                if {[string compare $cur {}] == 0} then {
                        tk_messageBox -type ok -icon info -message {No text found}
                raise .find
                return 
                }
                .text tag add sel $cur [tkTextNextWord .text $cur]
                .text mark set insert $cur
                .text see insert
                set ok [.find.ok configure -text OK -command "EditFindText \$string $con $cur"]
                pack .find.ok -after .find.entry -side left -padx 5 -pady 5
        }
}
#-----------------------------------------------------------------------------------
#       ABOUT
proc About {} {
        set about .about
        toplevel $about
        wm title $about "About Azul Editor"
        wm resizable $about 0 0
	set f [frame $about.f -bg blue]
        set label1 [label $f.label1 -text "Azul Code Editor" -fg white -bg blue]
        set label2 [label $f.label2 -text "Version 2.1" -fg white -bg blue]
        set label3 [label $f.label3 -text "Author: Luis Rodriguez" -fg white -bg blue]
        set label4 [label $f.label4 -text "email: luis.rodriguez@equifax.com.sv" -fg white -bg blue]
        set label5 [label $f.label5 -text " homepage: http://www.plazalinux.com/azul" -fg white -bg blue]
        pack $f $label1 $label2 $label3 $label4 $label5 
        set close [button $f.close -text Close -command "destroy $about"]
        pack $close -padx 5 -pady 5
        focus $close
}





