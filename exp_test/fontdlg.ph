


# menu fontdlg
menu .filemenu.fontdlg -tearoff 0 -font $menuFont

.filemenu  add cascade -label "Font" -underline 0 -menu .filemenu.fontdlg
.filemenu.fontdlg add command -label "Menu font..." -underline 0 -command {ft:dlgFont menu}
.filemenu.fontdlg add command -label "textarea font..." -underline 0 -command {ft:dlgFont texte}

#
# Creates a font dialog to select a font.
#
# Comment out test code at end of file for real usage.
#

#
# Creates a font dialog like that in Windows 95.
# returns 1 if user chose a font, 0 otherwise.
#

# code pris de: Graphical applications with tcl/tk 2 edition
# de Eric foster-Johnson
# edition: M&T Books 1997
# ISBN 1-55851-569-0
# chap 7 p 425-436

proc FontDialog { font_name } {
    global fd_family fd_style fd_size fd_close 
    global fd_strikeout fd_underline

    set fd_family {}
    set fd_style  {}
    set fd_size   {}
    set fd_strikeout 0
    set fd_underline 0
    set fd_close  -1

    set unsorted_fam [font families]

    set families [lsort $unsorted_fam]

    #
    # Get current font's family and so on.
    #
        # Calculate font style.
    set slant     [font actual $font_name -slant]
    set weight    [font actual $font_name -weight]

        # Default style.
    set fd_style "Regular"

    if { $slant == "italic" } {
        if { $weight == "bold" } {
            set fd_style "Bold Italic"
        } else {
            set fd_style "Italic"
        }
    } else {
        if { $weight == "bold" } {
            set fd_style "Bold"
        } 
    }

    set family [font actual $font_name -family]
    set fd_family $family
    set size   [font actual $font_name -size]
    set fd_size   $size
    set strikeout [font actual $font_name -underline]
    set fd_strikeout $strikeout
    set underline [font actual $font_name -overstrike]
    set fd_underline $underline

    #
    # Create font dialog.
    #
    set dlg .fontdialog
    toplevel $dlg
    wm protocol $dlg WM_DELETE_WINDOW "set fd_close 0"

    wm title $dlg Font
    setwingeom $dlg

    label $dlg.family_lbl -text "Font:" -anchor w
    entry $dlg.family_ent -textvariable fd_family \
         -background white
    bind  $dlg.family_ent <Key-Return> \
         "FontDialogRegen $font_name"
    grid config $dlg.family_lbl -column 0 -row 0 \
         -sticky w 
    grid config $dlg.family_ent -column 0 -row 1 \
         -sticky snew 


    label $dlg.style_lbl  -text "Font Style:" -anchor w
    entry $dlg.style_ent  -textvariable fd_style \
         -width 11 -background white
    bind  $dlg.style_ent  <Key-Return> \
         "FontDialogRegen $font_name"
    grid config $dlg.style_lbl  -column 1 -row 0 \
         -sticky w 
    grid config $dlg.style_ent  -column 1 -row 1 \
         -sticky snew 

    label $dlg.size_lbl   -text "Size:" -anchor w
    entry $dlg.size_ent   -textvariable fd_size \
         -width 4 -background white
    bind  $dlg.size_ent   <Key-Return> \
         "FontDialogRegen $font_name"
    grid config $dlg.size_lbl   -column 2 -row 0 \
         -sticky w
    grid config $dlg.size_ent   -column 2 -row 1 \
         -sticky snew 

    # Font family listbox.
    set fr $dlg.family_list
    frame $fr -bd 0
    listbox $fr.list -height 6 -selectmode single \
        -yscrollcommand "$fr.scroll set" \
         -width 30 -background white

    scrollbar $fr.scroll -command "$fr.list yview"

    foreach f $families {
        $fr.list insert end $f
    }

    bind $fr.list <Double-Button-1> \
     "FontDialogFamily $fr.list $font_name $dlg.family_ent"

    pack $fr.scroll -side right -fill y
    pack $fr.list -side left
    grid config $fr -column 0 -row 2 -rowspan 16 

    # Font style listbox.
    set fr $dlg.style_list
    frame $fr -bd 0
    listbox $fr.list -height 6 -selectmode single \
        -yscrollcommand "$fr.scroll set" \
        -width 11 -background white

    scrollbar $fr.scroll -command "$fr.list yview"

    $fr.list insert end "Regular"
    $fr.list insert end "Bold"
    $fr.list insert end "Italic"
    $fr.list insert end "Bold Italic"

    bind $fr.list <Double-Button-1> \
     "FontDialogStyle $fr.list $font_name $dlg.style_ent"

    pack $fr.scroll -side right -fill y
    pack $fr.list -side left
    grid config $fr -column 1 -row 2 -rowspan 16 


    # Font size listbox.
    set fr $dlg.size_list
    frame $fr -bd 0
    listbox $fr.list -height 6 -selectmode single \
        -yscrollcommand "$fr.scroll set" \
        -width 4 -background white

    scrollbar $fr.scroll -command "$fr.list yview"

    set i 8
    while { $i <= 32 } {
        $fr.list insert end $i
        set i [expr $i + 2]
    }

    bind $fr.list <Double-Button-1> \
      "FontDialogSize $fr.list $font_name $dlg.size_ent"

    pack $fr.scroll -side right -fill y
    pack $fr.list -side left
    grid config $fr -column 2 -row 2 -rowspan 16 

    # OK/Cancel
    set fr $dlg.ok_cancel
    frame $fr -bd 0

    button $fr.ok -text "OK" -command "set fd_close 1"
    button $fr.cancel  -text "Cancel" \
         -command "set fd_close 0"
    pack $fr.ok -side top -fill x 
    pack $fr.cancel -side top -fill x -pady 2
    grid config $fr -column 4 -row 1 -rowspan 2 \
         -sticky snew -padx 12

    # Effects.
    set fr $dlg.effects
    frame $fr -bd 3 -relief groove

    label $fr.effects -text "Effects" -anchor w
    checkbutton $fr.strikeout -variable fd_strikeout \
        -text "Strikeout" -anchor w \
        -command "FontDialogRegen $font_name"
    checkbutton $fr.underline -variable fd_underline \
        -text "Underline" -anchor w \
        -command "FontDialogRegen $font_name"

    pack $fr.effects $fr.strikeout $fr.underline \
         -side top -fill x

    grid config $fr -column 1 -columnspan 2 -row 20 \
        -rowspan 2 -sticky snew -pady 10 

    # Sample text
    set fr $dlg.sample
    frame $fr -bd 3 -relief groove
    label $fr.l_sample -text "Sample" -anchor w

    label $fr.sample -text "Every good boy\n does fine." \
        -font $font_name -bd 2 -relief sunken

    pack  $fr.l_sample -side top -fill x -pady 4
    pack  $fr.sample -side top -pady 4 -ipadx 10 -ipady 10

    grid config $fr -column 0 -columnspan 1 -row 20 \
        -rowspan 2 -sticky snew -pady 10 -padx 2

    # Make this a modal dialog.
    tkwait variable fd_close

    # Get rid of dialog and return value.
    destroy $dlg

    #
    # Restore old font characteristics on a cancel.
    #
    if { $fd_close == 0 } {
            font configure $font_name -family $family \
                    -size $size -underline $underline \
                    -overstrike $strikeout -slant $slant \
                    -weight $weight
    }

    return $fd_close
}


proc FontDialogFamily { listname font_name entrywidget } {

    # Get selected text from list.
    catch {
        set item_num [$listname curselection]
        set item [$listname get $item_num]

        # Set selected list item into entry for font family.
        $entrywidget delete 0 end
        $entrywidget insert end $item

        # Use this family in the font and regenerate font.
        FontDialogRegen $font_name
    }
}


proc FontDialogStyle { listname font_name entrywidget } {

    # Get selected text from list.
    catch {
        set item_num [$listname curselection]
        set item [$listname get $item_num]

        # Set selected list item into entry for font family.
        $entrywidget delete 0 end
        $entrywidget insert end $item

        # Use this family in the font and regenerate font.
        FontDialogRegen $font_name
    }
}



proc FontDialogSize { listname font_name entrywidget } {

    # Get selected text from list.
    catch {
        set item_num [$listname curselection]
        set item [$listname get $item_num]

        # Set selected list item into entry for font family.
        $entrywidget delete 0 end
        $entrywidget insert end $item

        # Use this family in the font and regenerate font.
        FontDialogRegen $font_name
    }
}




    # Regenerates font from attributes.
proc FontDialogRegen { font_name } {
    global fd_family fd_style fd_size 
    global fd_strikeout fd_underline

    set weight "normal"
    if { $fd_style == "Bold Italic" || $fd_style == "Bold" } {
        set weight "bold"
    }

    set slant "roman"
    if { $fd_style == "Bold Italic" || $fd_style == "Italic" } {
        set slant "italic"
    }

    #
    # Change font to have new characteristics.
    #
    font configure $font_name -family $fd_family \
        -size $fd_size -underline $fd_underline \
        -overstrike $fd_strikeout -slant $slant \
        -weight $weight
}

#######################################################################################
# ft:dlgFont
#	fonction permettant d'afficher la dlg de font selon l'item choisi
#
# Entree:
#    - type: a quel type de control va le changement, s'il y a
#        val par defaut: menu
#
# Sortie: neant
#
#
# Auteur:
#    Yves guerin - 2004

proc ft:dlgFont {{type {menu}}} {
    # init var local
    set ctrl ""
    set police ""
    set ancienFont ""
    set faireInterface 0
    
    # a qui ?
    switch -exact -- $type {
        "menu" {
                set ctrl .filemenu
                set police menuFont
                # faire l'interface au complet avec les autres patchs
                set faireInterface 1
        }
        "texte" {
            set ctrl .textarea
            set police textFont
        }
    }
    
    # creation d'un font test
    font create testfont -family helvetica
    
    # affiche dlgfont
    if {[FontDialog testfont]} {
        # l'util a choisi
        # applique font
        $ctrl configure -font testfont
        
        # si menu pour chaque sous-menu
        foreach enfant [winfo children $ctrl] {
            $enfant configure -font testfont
        }
        
        if {$faireInterface} {
            # pour linenum.ph
            if {[winfo exists .statusind]} {
                .statusind configure -font testfont
            }
            
            if {[winfo exists .modified]} {
                .modified configure -font testfont
            }
        }
        
    } 
    
    # enleve le font de test
    font delete testfont
    
    update
    return
}

