#!/usr/bin/perl -w

# $Id: petris-options.pl,v 1.8 1999/08/08 15:46:59 root Exp $

# Copyright (c) Mark Summerfield 1998/9. All Rights Reserved.
# May be used/distributed under the GPL.

use strict ;

package options ;


my $OptionsWin ; 

# Local variables to store values. Want them global to the module.
my( $Interval, 
    $BoardSquaresX, 
    $BoardSquaresY, 
    $BoardSquareLength, 
    $UseSpecialShapes,
    $UseSpecialLayouts,
    $UseRandomLayouts,
    $SpeedUp,
    ) ;


sub options {
    package main ;

    # Start with existing values.
    $Interval          = $Opt{INTERVAL} ;
    $SpeedUp           = $Opt{SPEED_UP} ;
    $BoardSquaresX     = $Opt{BOARD_SQUARES_X} ;
    $BoardSquaresY     = $Opt{BOARD_SQUARES_Y} ;
    $BoardSquareLength = $Opt{BOARD_SQUARE_LENGTH} ;
    $UseSpecialShapes  = $Opt{USE_SPECIAL_SHAPES} ;
    $UseSpecialLayouts = $Opt{USE_SPECIAL_LAYOUTS} ;
    $UseRandomLayouts  = $Opt{USE_RANDOM_LAYOUTS} ;

    # Set up the options window. 
    $OptionsWin = $Win->Toplevel() ;
    $OptionsWin->title( 'Petris Options' ) ;
    $OptionsWin->protocol( "WM_DELETE_WINDOW", [ \&options::close, 0 ] ) ;

    &options::key_bindings ;

    # Scales.
    my $scale ; 
    $scale = &options::create_scale( 
        $Const{INTERVAL_MIN}, $Const{INTERVAL_MAX}, 
        100, "Interval (millisecs)", 0, 0 ) ;
    $scale->configure( -variable => \$Interval ) ;
    
    $scale = &options::create_scale( 
        $Const{SPEED_UP_MIN}, $Const{SPEED_UP_MAX}, 
        1, "Interval speed up (millisecs)", 0, 3 ) ;
    $scale->configure( -variable => \$SpeedUp ) ;

 
    $scale = &options::create_scale(
        $Const{BOARD_SQUARES_X_MIN}, $Const{BOARD_SQUARES_X_MAX}, 
        2, "Width (squares)", 2, 0 ) ;
    $scale->configure( -variable => \$BoardSquaresX, ) ;

    $scale = &options::create_scale(
        $Const{BOARD_SQUARES_Y_MIN}, $Const{BOARD_SQUARES_Y_MAX}, 
        5, "Height (squares)", 2, 3 ) ;
    $scale->configure( -variable => \$BoardSquaresY, ) ;
 
    $scale = &options::create_scale(
        $Const{BOARD_SQUARE_LENGTH_MIN}, $Const{BOARD_SQUARE_LENGTH_MAX},
        4, "Square width (pixels)", 4, 0 ) ;
    $scale->configure( -variable => \$BoardSquareLength, ) ;

    # Special shapes checkbox.
    $OptionsWin->Checkbutton(
        -text     => 'Extra shapes?',
        -variable => \$UseSpecialShapes,
        )->grid( -row => 4, -column => 3, -columnspan => 1, -sticky => 'w' ) ;

    # Special layouts checkbox.
    $OptionsWin->Checkbutton(
        -text     => 'Layouts?',
        -variable => \$UseSpecialLayouts,
        )->grid( -row => 4, -column => 4, -columnspan => 1, -sticky => 'w' ) ;

    # Random layouts checkbox.
    $OptionsWin->Checkbutton(
        -text     => 'Random Layouts?',
        -variable => \$UseRandomLayouts,
        )->grid( -row => 4, -column => 5, -columnspan => 1, -sticky => 'w' ) ;


    my $Frame = $OptionsWin->Frame()->
                grid( -row => 5, -column => 3, -columnspan => 3 ) ;

    # Save button.
    $Frame->Button(
        -text      => 'Save',
        -underline => 0,
        -width     => $Const{BUTTON_WIDTH},
        -command   => [ \&options::close, 1 ],
        )->grid( -row => 1, -column => 1, -sticky => 'w' ) ;

    # Cancel button.
    $Frame->Button(
        -text      => 'Cancel',
        -underline => 0,
        -width     => $Const{BUTTON_WIDTH},
        -command   => [ \&options::close, 0 ],
        )->grid( -row => 1, -column => 2, -sticky => 'w' ) ;

    # Defaults button.
    $Frame->Button(
        -text      => 'Defaults',
        -underline => 0,
        -width     => $Const{BUTTON_WIDTH},
        -command   => \&options::defaults,
        )->grid( -row => 1, -column => 3, -sticky => 'w' ) ;

    &window_centre( $OptionsWin ) ;
}


sub create_scale {
    package main ;

    my( $min, $max, $interval, $title, $row, $col ) = @_ ;

    my $scale = $OptionsWin->Scale( 
        -orient       => 'horizontal',
        -from         => $min,
        -to           => $max,
        -tickinterval => $interval,
        -label        => $title,
        '-length'     => 290,
        )->grid( -row => $row, -column => $col, -rowspan => 2, -columnspan => 3 ) ;

    $scale ;
}


sub key_bindings {
    package main ;

    # Cancel keyboard bindings.
    $OptionsWin->bind( '<Alt-c>',     [ \&options::close, 0 ] ) ;
    $OptionsWin->bind( '<Control-c>', [ \&options::close, 0 ] ) ;
    $OptionsWin->bind( '<Escape>',    [ \&options::close, 0 ] ) ;

    # Save keyboard bindings.
    $OptionsWin->bind( '<Alt-s>',     [ \&options::close, 1 ] ) ;
    $OptionsWin->bind( '<Control-s>', [ \&options::close, 1 ] ) ;
    $OptionsWin->bind( '<Return>',    [ \&options::close, 1 ] ) ;

    # Defaults keyboard bindings.
    $OptionsWin->bind( '<Alt-d>',     \&options::defaults ) ;
    $OptionsWin->bind( '<Control-d>', \&options::defaults ) ;
}


sub close {
    package main ;

    shift if ref $_[0] ; # Some callers include an object ref.
    my $save = shift ;

    if( $save ) {
        my $redo_board = 0 ;
        if( $Opt{BOARD_SQUARES_X}     != $BoardSquaresX or 
            $Opt{BOARD_SQUARES_Y}     != $BoardSquaresY or 
            $Opt{BOARD_SQUARE_LENGTH} != $BoardSquareLength ) {
            $redo_board = 1 ;
        }

        $Opt{INTERVAL}            = $Interval ;
        $Opt{BOARD_SQUARES_X}     = $BoardSquaresX ;
        $Opt{BOARD_SQUARES_Y}     = $BoardSquaresY ;
        $Opt{BOARD_SQUARE_LENGTH} = $BoardSquareLength ;
        $Opt{USE_SPECIAL_SHAPES}  = $UseSpecialShapes ;
        $Opt{USE_SPECIAL_LAYOUTS} = $UseSpecialLayouts ;
        $Opt{USE_RANDOM_LAYOUTS}  = $UseRandomLayouts ;
        $Opt{SPEED_UP}            = $SpeedUp ;

        &write_opts ;
        if( $redo_board ) {
            &board::create ;
            &window_centre( $Win ) ;
            &action::game_over( 'OPTIONS' ) ;
        }
    }
    &board::status( 'Paused' ) unless $save ;
    $OptionsWin->destroy ;
}


sub defaults {
    package main ;

    $Interval          = $Const{INTERVAL_DEF} ;
    $SpeedUp           = $Const{SPEED_UP_DEF} ;
    $BoardSquaresX     = $Const{BOARD_SQUARES_X_DEF} ;
    $BoardSquaresY     = $Const{BOARD_SQUARES_Y_DEF} ;
    $BoardSquareLength = $Const{BOARD_SQUARE_LENGTH_DEF} ;
    $UseSpecialShapes  = $Const{USE_SPECIAL_SHAPES} ;
    $UseSpecialLayouts = $Const{USE_SPECIAL_LAYOUTS} ;
    $UseRandomLayouts  = $Const{USE_RANDOM_LAYOUTS} ;
}


1 ;
