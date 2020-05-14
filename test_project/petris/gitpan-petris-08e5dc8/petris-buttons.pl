#!/usr/bin/perl -w

# $Id: petris-buttons.pl,v 1.3 1999/08/08 15:46:59 root Exp $

# Copyright (c) Mark Summerfield 1998/9. All Rights Reserved.
# May be used/distributed under the GPL.

use strict ;

package main ;


my $Buttons = $Win->Frame()->pack( 
                -side   => 'left',
                -anchor => 'nw',
                ) ;

$Buttons{START} = $Buttons->Button(
                    -text      => 'Start',
                    -underline => 0,
                    -width     => $Const{BUTTON_WIDTH},
                    -command   => \&button::start,
                    )->grid( -row => 0, -column => 0 ) ;

$Buttons{PAUSE} = $Buttons->Button(
                    -text      => 'Pause',
                    -underline => 0,
                    -width     => $Const{BUTTON_WIDTH},
                    -command   => \&button::pause,
                    )->grid( -row => 1, -column => 0 ) ;

$Buttons{OPTIONS} = $Buttons->Button(
                    -text      => 'Options',
                    -underline => 0,
                    -width     => $Const{BUTTON_WIDTH},
                    -command   => \&button::options,
                    )->grid( -row => 2, -column => 0 ) ;

$Buttons{ABOUT} = $Buttons->Button(
                    -text      => 'About',
                    -underline => 0,
                    -width     => $Const{BUTTON_WIDTH},
                    -command   => \&button::about,
                    )->grid( -row => 3, -column => 0 ) ;

$Buttons{HELP} = $Buttons->Button(
                    -text      => 'Help',
                    -underline => 0,
                    -width     => $Const{BUTTON_WIDTH},
                    -command   => \&button::help,
                    )->grid( -row => 4, -column => 0 ) ;


$Buttons{QUIT} = $Buttons->Button(
                    -text      => 'Quit',
                    -underline => 0,
                    -width     => $Const{BUTTON_WIDTH},
                    -command   => \&button::quit,
                    )->grid( -row => 5, -column => 0 ) ;

$Buttons->Label(
                    -text      => 'High Score',
                    -width     => $Const{BUTTON_WIDTH},
                    )->grid( -row => 6, -column => 0 ) ;

$Buttons{HIGH_SCORE} = $Buttons->Label(
                    -text      => $Opt{HIGH_SCORE}, 
                    -width     => $Const{BUTTON_WIDTH},
                    -fg        => 'DarkRed',
                    -relief    => 'sunken',
                    )->grid( -row => 7, -column => 0 ) ;

$Buttons->Label(
                    -text      => 'Score',
                    -width     => $Const{BUTTON_WIDTH},
                    )->grid( -row => 8, -column => 0 ) ;

$Buttons{SCORE} = $Buttons->Label(
                    -text      => '0',
                    -width     => $Const{BUTTON_WIDTH},
                    -fg        => 'DarkGreen',
                    -relief    => 'sunken',
                    )->grid( -row => 9, -column => 0 ) ;


$Buttons->Label(
                    -text      => 'Lines',
                    -width     => $Const{BUTTON_WIDTH},
                    )->grid( -row => 10, -column => 0 ) ;

$Buttons{LINES} = $Buttons->Label(
                    -text      => '0',
                    -width     => $Const{BUTTON_WIDTH},
                    -fg        => 'DarkGreen',
                    -relief    => 'sunken',
                    )->grid( -row => 11, -column => 0 ) ;


$Board{STATUS} = $Buttons->Label( 
                    -width     => $Const{BUTTON_WIDTH} * 1.2,
                    -text      => 'Running',
                    -relief    => 'groove',
                    )->grid( -pady => 10, -row => 13, -column => 0 ) ;


1 ;
