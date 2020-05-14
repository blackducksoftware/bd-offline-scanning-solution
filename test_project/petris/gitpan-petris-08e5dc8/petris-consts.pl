#!/usr/bin/perl -w

# $Id: petris-consts.pl,v 1.8 1999/08/28 21:46:10 root Exp $

# Copyright (c) Mark Summerfield 1998/9. All Rights Reserved.
# May be used/distributed under the GPL.

use strict ;

package main ;


if( $^O =~ /win32/i ) {
    $Const{OPTS_FILE} = 'PETRIS.INI' ;
}
else {
    $Const{OPTS_FILE} = ( $ENV{HOME} or $ENV{LOGDIR} or (getpwuid( $> ))[7]) 
                        . '/.games/petrisrc' ;
}

# Enumerations.
( $BOARD, $HEAP, $BLOCK )           = ( 0, 1, 2 ) ;
( $ROTATE, $LEFT, $RIGHT, $DOWN )   = ( 0, 1, 2, 3 ) ;
( $RUNNING, $PAUSED, $NOTRUNNING )  = ( 1, 2, 0 ) ;

# Limits and defaults.
$Const{BUTTON_WIDTH}                =   10 ;

$Const{INTERVAL_DEF}                =  300 ;
$Const{INTERVAL_MIN}                =  100 ;
$Const{INTERVAL_MAX}                = 1000 ;

$Const{SPEED_UP_DEF}                =    1 ;
$Const{SPEED_UP_MIN}                =    0 ;
$Const{SPEED_UP_MAX}                =   10 ;

$Const{BOARD_SQUARES_X_DEF}         =   12 ; 
$Const{BOARD_SQUARES_X_MIN}         =   10 ; 
$Const{BOARD_SQUARES_X_MAX}         =   30 ; 

$Const{BOARD_SQUARES_Y_DEF}         =   25 ; 
$Const{BOARD_SQUARES_Y_MIN}         =   15 ; 
$Const{BOARD_SQUARES_Y_MAX}         =   70 ; 

$Const{BOARD_SQUARE_LENGTH_DEF}     =   22 ; 
$Const{BOARD_SQUARE_LENGTH_MIN}     =    8 ; 
$Const{BOARD_SQUARE_LENGTH_MAX}     =   40 ; 

# We specify colours in hex because of the get_colour routine.
$Const{BOARD_BACKGROUND_COLOUR}     = '#FFFFFF' ; # white
$Const{BOARD_OUTLINE_COLOUR}        = '#DFDFDF' ; # grey80
$Const{ROW_HIGHLIGHT_COLOUR}        = '#000000' ; # black

$Const{USE_SPECIAL_SHAPES}          = 1 ;
$Const{USE_SPECIAL_LAYOUTS}         = 1 ;
$Const{USE_RANDOM_LAYOUTS}          = 1 ;

$Const{HELP_FILE}                   = "$RealBin/petris-help.pod" ;


1 ;
