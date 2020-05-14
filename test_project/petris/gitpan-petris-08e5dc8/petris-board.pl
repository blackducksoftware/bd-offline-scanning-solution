#!/usr/bin/perl -w

# $Id: petris-board.pl,v 1.3 1999/08/08 15:46:59 root Exp $

# Copyright (c) Mark Summerfield 1998/9. All Rights Reserved.
# May be used/distributed under the GPL.

use strict ;

package main ;


$Board{CANVAS} = $Win->Canvas(
            -width  => $Const{BOARD_X_LENGTH},
            -height => $Const{BOARD_Y_LENGTH},
            )->pack() ;


1 ;
