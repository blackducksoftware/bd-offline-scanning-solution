#!/usr/bin/perl -w

# $Id: petris-help.pl,v 1.7 1999/08/28 21:46:10 root Exp $

# Copyright (c) Mark Summerfield 1998/9. All Rights Reserved.
# May be used/distributed under the GPL.

use strict ;

package help ;


my $HelpWin ; 
my $TextBox ;


sub help {
    package main ;

    # Set up the help window and some bindings to close it.
    $HelpWin = $Win->Toplevel() ; 
    $HelpWin->title( 'Petris Help' ) ;
    $HelpWin->protocol( "WM_DELETE_WINDOW", \&help::close ) ;
    $HelpWin->bind( '<q>',         \&help::close ) ;
    $HelpWin->bind( '<Alt-q>',     \&help::close ) ;
    $HelpWin->bind( '<Control-q>', \&help::close ) ;
    $HelpWin->bind( '<Escape>',    \&help::close ) ;

    # Set up the text widget.
    $TextBox = $HelpWin->Scrolled( 'Text', 
                    -background => 'white', 
                    -wrap       => 'word',
                    -scrollbars => 'e',
                    -width      => 80, 
                    -height     => 40,
                    )->pack( -fill => 'both', -expand => 'y' ) ;
    my $text = $TextBox->Subwidget( 'text' ) ;
    $text->configure( -takefocus => 1 ) ;
    $text->focus ;

    if( open HELP, $Const{HELP_FILE} ) {
		local $/ = '' ; # render_pod requires paragraphs.
		&tk::text::render_pod( $text, <HELP> ) ;
		close HELP ;
	}
	else {
		message( 
		    'Warning', 
		    'Help', 
		    "Cannot open help file `$Const{HELP_FILE}': $!"
		    ) ;
	}

    $text->configure( -state => 'disabled' ) ;
}


sub close {

    &board::status( 'Paused' ) ;
    $HelpWin->destroy ;
}


1 ;
