#!/usr/bin/perl -w

# $Id: petris-button-commands.pl,v 1.9 1999/08/08 15:46:59 root Exp $

# Copyright (c) Mark Summerfield 1998/9. All Rights Reserved.
# May be used/distributed under the GPL.

use strict ;

package button ;


sub start {
    package main ;

    return if $Global{STATE} != $NOTRUNNING ;

    # The shorter the interval the higher the scoring since this is harder.
    # Similarly, the smaller the board the harder, so again this is reflected
    # in the scoring.
    $Global{SCORE_INC} = 
        int( ( ( $Const{BOARD_SQUARES_X_MAX} - $Opt{BOARD_SQUARES_X} ) + 
               ( $Const{BOARD_SQUARES_Y_MAX} - $Opt{BOARD_SQUARES_Y} ) + 
               ( ( $Const{INTERVAL_MAX} - $Opt{INTERVAL} ) / 100 )  
             ) / 5 ) ;

    $Global{NEW_BOARD_TRIGGER} = $Global{SCORE_INC} * $Opt{BOARD_SQUARES_Y} ;

    $Buttons{START}->configure( -state => 'disabled' ) ;
    $Buttons{PAUSE}->configure( -state => 'normal' ) ;

    $Opt{SCORE}    = 0 ;
    $Buttons{SCORE}->configure(      -text => $Opt{SCORE} ) ;
    $Buttons{HIGH_SCORE}->configure( -text => $Opt{HIGH_SCORE} ) ;

    $Global{LINES} = 0 ;
    $Buttons{LINES}->configure(      -text => $Global{LINES} ) ;

    &action::clear_board ;

    if( $Opt{USE_SPECIAL_LAYOUTS} ) {
        $Const{LAYOUT} = int( rand( $Const{LAYOUT_MAX} + 1 ) ) ;
        &action::new_board ;
    }

    # Delete any old block.
    %Block = () ;

    $Global{BLOCK_MAX} = $Opt{USE_SPECIAL_SHAPES} ? 
                         $Const{BLOCK_SPL_MAX} : $Const{BLOCK_STD_MAX} ;
    $Global{BLOCK_MAX}++ ;

    # Set up new block.
    $Global{INTERVAL} = $Opt{INTERVAL} ;
    &action::create_block ;
    &action::draw_block ;

    $Global{STATE} = $RUNNING ;
    &board::status( 'Running' ) ;
    $Win->configure( -cursor => 'left_ptr' ) ; # The default cursor.
    &action::tick ; 
}


sub pause {
    package main ;

    $Win->configure( -cursor => 'left_ptr' ) ; # The default cursor.

    if( $Global{STATE} == $RUNNING ) {
        $Global{STATE} = $PAUSED ;
        $Win->configure( -cursor => 'clock' ) ;
        &board::status( 'Paused' ) ;
        $Buttons{PAUSE}->configure( -text => 'Resume' ) ;

        if( $DEBUG ) { 
            for( my $y = int( $Opt{BOARD_SQUARES_Y} / 2 ) ; 
                    $y < $Opt{BOARD_SQUARES_Y} ; $y++ ) {
                print STDERR "$y\t";
                for( my $x = 0 ; $x < $Opt{BOARD_SQUARES_X} ; $x++ ) {
                    print STDERR "$Board{SQUARES}[$x][$y]{TYPE}" ;
                }
                print STDERR "\n";
            }
            print STDERR "\n";
        }        
    }
    elsif( $Global{STATE} == $PAUSED ) {
        $Global{STATE} = $RUNNING ;
        &board::status( 'Running' ) ;
        $Buttons{PAUSE}->configure( -text => 'Pause' ) ;
        &action::tick ;
    }
    else {
        # $Global{STATE} == $NOTRUNNING so we do nothing.
        &board::status( 'Ready' ) ;
    }
}


sub quit {
    package main ;

    &write_opts unless $Global{WROTE_OPTS} ; 
    exit ;
}


sub options {
    package main ;


    &button::pause if $Global{STATE} != $PAUSED ;
    $Win->configure( -cursor => 'watch' ) ;
    &board::status( 'Setting options...' ) ;

    &options::options ;

    $Win->configure( -cursor => 'clock' ) ;
}


sub help {
    package main ;

    &button::pause if $Global{STATE} != $PAUSED ;
    $Win->configure( -cursor => 'watch' ) ;
    &board::status( 'Showing help...' ) ;

    &help::help ;

    $Win->configure( -cursor => 'clock' ) ;
}


sub about {
    package main ;

    &button::pause if $Global{STATE} != $PAUSED ;
    &board::status( 'Showing about box...' ) ;
    
    my $text = <<__EOT__ ;
Petris v $VERSION

summer\@chest.ac.uk

Copyright (c) Mark Summerfield 1998/9. 
All Rights Reserved.

May be used/distributed under the GPL.
__EOT__

    my $msg = $Win->MesgBox(
        -title => "About Petris",
        -text  => $text, 
        ) ;
    $msg->Show ;
    
    &board::status( 'Paused' ) ;
}


1 ;
