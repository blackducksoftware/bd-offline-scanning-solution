#!/usr/bin/perl -w

# $Id: petris-board-commands.pl,v 1.4 1999/09/06 19:04:38 root Exp $

# Copyright (c) Mark Summerfield 1998/9. All Rights Reserved.
# May be used/distributed under the GPL.

use strict ;

package board ;


sub create {
    package main ;

    $Board{CANVAS}->delete( 'all' ) ;
    
    $Board{CANVAS}->configure(
        -width  => $Opt{BOARD_SQUARES_X} * $Opt{BOARD_SQUARE_LENGTH},
        -height => $Opt{BOARD_SQUARES_Y} * $Opt{BOARD_SQUARE_LENGTH},
        ) ; 

    for( my $x = 0 ; $x < $Opt{BOARD_SQUARES_X} ; $x++ ) {
        my $xlen = $x    * $Opt{BOARD_SQUARE_LENGTH} ;
        my $Xlen = $xlen + $Opt{BOARD_SQUARE_LENGTH} ;
        for( my $y = 0 ; $y < $Opt{BOARD_SQUARES_Y} ; $y++ ) {
            my $ylen = $y * $Opt{BOARD_SQUARE_LENGTH} ;
            $Board{SQUARES}[$x][$y]{SQUARE} = $Board{CANVAS}->create(
                'rectangle', 
                $xlen,
                $ylen,
                $Xlen,
                $ylen + $Opt{BOARD_SQUARE_LENGTH},
                -fill    => $Const{BOARD_BACKGROUND_COLOUR},
                -outline => $Const{BOARD_OUTLINE_COLOUR},
                -tag     => 'BOARD',
                ) ;
            $Board{SQUARES}[$x][$y]{TYPE}   = $BOARD ;
            $Board{SQUARES}[$x][$y]{COLOUR} = $Const{BOARD_BACKGROUND_COLOUR} ;
        }
    }

    $Board{CANVAS}->update ;
}


sub status {
    package main ;

    local $_ = shift ;

    s/ /\n/g ;
    $Board{STATUS}->configure( -text => $_ ) ;
    $Board{STATUS}->update ;
}


1 ;
