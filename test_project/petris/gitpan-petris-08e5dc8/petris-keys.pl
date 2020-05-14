#!/usr/bin/perl -w

# $Id: petris-keys.pl,v 1.4 1999/08/28 21:46:10 root Exp $

# Copyright (c) Mark Summerfield 1998/9. All Rights Reserved.
# May be used/distributed under the GPL.

use strict ;

package main ;


# Key bindings for the main window. 
$Win->bind( '<Control-s>', \&button::start ) ;
$Win->bind( '<Alt-s>',     \&button::start ) ;
$Win->bind( '<s>',         \&button::start ) ;

$Win->bind( '<Control-p>', \&button::pause ) ; # Pause
$Win->bind( '<Alt-p>',     \&button::pause ) ;
$Win->bind( '<p>',         \&button::pause ) ;
$Win->bind( '<Control-r>', \&button::pause ) ; # Resume
$Win->bind( '<Alt-r>',     \&button::pause ) ;
$Win->bind( '<r>',         \&button::pause ) ;
$Win->bind( '<space>',     \&button::pause ) ;

$Win->bind( '<Control-o>', \&button::options ) ;
$Win->bind( '<Alt-o>',     \&button::options ) ;
$Win->bind( '<o>',         \&button::options ) ;

$Win->bind( '<Control-a>', \&button::about ) ;
$Win->bind( '<Alt-a>',     \&button::about ) ;
$Win->bind( '<a>',         \&button::about ) ;

$Win->bind( '<Control-h>', \&button::help ) ;
$Win->bind( '<Alt-h>',     \&button::help ) ;
#$Win->bind( '<h>',         \&button::help ) ; # Can't do this with vi keys later.
$Win->bind( '<F1>',        \&button::help ) ;

$Win->bind( '<Control-q>', \&button::quit ) ;
$Win->bind( '<Alt-q>',     \&button::quit ) ;
$Win->bind( '<q>',         \&button::quit ) ;

$Win->bind( '<Up>',        \&action::rotate ) ;
$Win->bind( '<k>',         \&action::rotate ) ;     # vi
$Win->bind( '<f>',         \&action::rotate ) ;     # left hand
$Win->bind( '<Down>',      \&action::drop ) ;
$Win->bind( '<j>',         \&action::drop ) ;       # vi
$Win->bind( '<b>',         \&action::drop ) ;       # left hand
$Win->bind( '<Left>',      \&action::move_left ) ;
$Win->bind( '<h>',         \&action::move_left ) ;  # vi
$Win->bind( '<d>',         \&action::move_left ) ;  # left hand
$Win->bind( '<Right>',     \&action::move_right ) ;
$Win->bind( '<l>',         \&action::move_right ) ; # vi
$Win->bind( '<g>',         \&action::move_right ) ; # left hand


1 ;
