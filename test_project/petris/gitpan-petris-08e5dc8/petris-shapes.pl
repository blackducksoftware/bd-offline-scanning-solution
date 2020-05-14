#!/usr/bin/perl -w

# $Id: petris-shapes.pl,v 1.2 1999/08/08 15:46:59 root Exp $

# Copyright (c) Mark Summerfield 1998/9. All Rights Reserved.
# May be used/distributed under the GPL.

use strict ;

package main ;


# Starting offsets.
my $x = int( ( $Opt{BOARD_SQUARES_X} - 4 ) / 2 ) ; # Centred.
my $y = 0 ;

# Pieces are described here. There can be as many different kinds as you like.
# They don't have to be made of four squares either - any number is fine, so
# long as it isn't wider than the board, and they should fit within a 4 x 4
# area - and component parts don't have to join up.

# If you want to test out a new piece then add it at the END of the ones given
# but name it $Const{BLOCK_0}, i.e. make it overwrite the standard block zero;
# then set the $Const{BLOCK_SPL_MAX} to zero so the only block that will
# appear will be the new one. Once satisfied that its shape is OK, change its
# number to the next in line and set the special max to that number.

# Standard pieces.

# 0     1    2   3   4     5   6
#
# @@@@   @   @@  @@    @@  @    @
#       @@@  @@   @@  @@   @    @
#                          @@  @@

$Const{BLOCK_0}  = [ [$x,   $y],   [$x+1, $y],   [$x+2, $y],   [$x+3, $y] ] ;
$Const{BLOCK_1}  = [ [$x+1, $y],   [$x,   $y+1], [$x+1, $y+1], [$x+2, $y+1] ] ;
$Const{BLOCK_2}  = [ [$x,   $y],   [$x+1, $y],   [$x,   $y+1], [$x+1, $y+1] ] ;
$Const{BLOCK_3}  = [ [$x,   $y],   [$x+1, $y],   [$x+1, $y+1], [$x+2, $y+1] ] ;
$Const{BLOCK_4}  = [ [$x+1, $y],   [$x+2, $y],   [$x,   $y+1], [$x+1, $y+1] ] ;
$Const{BLOCK_5}  = [ [$x,   $y],   [$x,   $y+1], [$x,   $y+2], [$x+1, $y+2] ] ;
$Const{BLOCK_6}  = [ [$x+1, $y],   [$x+1, $y+1], [$x+1, $y+2], [$x,   $y+2] ] ;

$Const{BLOCK_STD_MAX} = 6 ; # The index of the last standard block type.


# Special pieces.

# 7
#
# @@
#  @
$Const{BLOCK_7}  = [ [$x,   $y],   [$x+1, $y],   [$x+1, $y+1] ] ;


# 8
#
# @
#  @
$Const{BLOCK_8}  = [ [$x,   $y],   [$x+1, $y+1] ] ;


# 9
#
#  @ 
# @@@
#  @
$Const{BLOCK_9}  = [ [$x+1, $y],   [$x,   $y+1],   [$x+1, $y+1], [$x+2, $y+1],
                     [$x+1, $y+2] ] ;


# 10 
#
# @ @
# @ @
$Const{BLOCK_10} = [ [$x,   $y],   [$x+2, $y],   [$x,   $y+1], [$x+2, $y+1] ] ;


$Const{BLOCK_SPL_MAX} = 8 ; # The index of the last block type.
# NB We don't use types 9 and 10 - they're too difficult!


1 ;
