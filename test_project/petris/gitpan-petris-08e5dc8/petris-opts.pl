#!/usr/bin/perl -w

# $Id: petris-opts.pl,v 1.3 1999/08/08 15:46:59 root Exp $

# Copyright (c) Mark Summerfield 1998/9. All Rights Reserved.
# May be used/distributed under the GPL.

use strict ;

package main ;


$Opt{INTERVAL}            = $Const{INTERVAL_DEF} ; 
$Opt{SPEED_UP}            = $Const{SPEED_UP_DEF} ;

$Opt{BOARD_SQUARES_X}     = $Const{BOARD_SQUARES_X_DEF} ;
$Opt{BOARD_SQUARES_Y}     = $Const{BOARD_SQUARES_Y_DEF} ;

$Opt{BOARD_SQUARE_LENGTH} = $Const{BOARD_SQUARE_LENGTH_DEF} ;

$Opt{HIGH_SCORE}          = 4662 ;

$Opt{USE_SPECIAL_SHAPES}  = $Const{USE_SPECIAL_SHAPES} ;
$Opt{USE_SPECIAL_LAYOUTS} = $Const{USE_SPECIAL_LAYOUTS} ;
$Opt{USE_RANDOM_LAYOUTS}  = $Const{USE_RANDOM_LAYOUTS} ;


sub opts_check {

    $Opt{INTERVAL} = $Const{INTERVAL_DEF} 
    if $Opt{INTERVAL} < $Const{INTERVAL_MIN} or 
       $Opt{INTERVAL} > $Const{INTERVAL_MAX} ;

    $Opt{BOARD_SQUARES_X} = $Const{BOARD_SQUARES_X_DEF} 
    if $Opt{BOARD_SQUARES_X} < $Const{BOARD_SQUARES_X_MIN} or 
       $Opt{BOARD_SQUARES_X} > $Const{BOARD_SQUARES_X_MAX} ;

    $Opt{BOARD_SQUARES_Y} = $Const{BOARD_SQUARES_Y_DEF} 
    if $Opt{BOARD_SQUARES_Y} < $Const{BOARD_SQUARES_Y_MIN} or 
       $Opt{BOARD_SQUARES_Y} > $Const{BOARD_SQUARES_Y_MAX} ;

    $Opt{BOARD_SQUARE_LENGTH} = $Const{BOARD_SQUARE_LENGTH_DEF} 
    if $Opt{BOARD_SQUARE_LENGTH} < $Const{BOARD_SQUARE_LENGTH_MIN} or 
       $Opt{BOARD_SQUARE_LENGTH} > $Const{BOARD_SQUARE_LENGTH_MAX} ;
}


1 ;
