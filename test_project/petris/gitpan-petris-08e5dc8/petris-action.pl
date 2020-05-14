#!/usr/bin/perl -w

# $Id: petris-action.pl,v 1.8 1999/08/08 15:46:59 root Exp $

# Copyright (c) Mark Summerfield 1998/9. All Rights Reserved.
# May be used/distributed under the GPL.

use strict ;

package main ;


my $ClearingRows = 0 ;


sub action::game_over {

    $Global{STATE} = $NOTRUNNING ;

    $Buttons{START}->configure( -state => 'normal' ) ;
    $Buttons{PAUSE}->configure( -state => 'disabled' ) ;
    $Board{STATUS}->configure(  -text =>  'Ready' ) ;
    $Win->configure( -cursor => 'left_ptr' ) ; # The default cursor.

    return if shift ;

    my $result = "\nYou scored $Opt{SCORE}." ;
    if( $Opt{SCORE} > $Opt{HIGH_SCORE} ) {
        $result .= "\n\nAnd beat the high score of $Opt{HIGH_SCORE}!" ;
        $Opt{HIGH_SCORE}    = $Opt{SCORE} ;
        $Global{WROTE_OPTS} = 0 ;
    }
    else {
        $result .= "\n\nCurrent high score is $Opt{HIGH_SCORE}." ;
    }

    my $msg = $Win->MesgBox(
        -title => "Petris Game Over",
        -text  => $result,
        -icon  => 'INFO',
        ) ;
    $msg->Show ;

    unless( $Global{WROTE_OPTS} ) { # Make sure we write out new high score!
        &write_opts ;
        $Global{WROTE_OPTS} = 1 ;
    }
}


sub action::tick {
    return if $Global{STATE} != $RUNNING ;

    &action::advance( $DOWN ) ;
    $Win->after( $Global{INTERVAL}, \&action::tick ) ;
}


sub action::create_block {
    my $game_over = 0 ;

    my $colour = &get_colour ;
    print "B: $colour\n" if $DEBUG ;
    @{$Block{SQUARES}} = @{$Const{"BLOCK_" . int( rand $Global{BLOCK_MAX} ) }} ; 
    foreach my $coords ( @{$Block{SQUARES}} ) {
        my( $x, $y ) = @{$coords} ;
        # If we start on the heap or a block its over.
        $game_over = 1, last if $Board{SQUARES}[$x][$y]{TYPE} != $BOARD ;
        $Board{SQUARES}[$x][$y]{TYPE}   = $BLOCK ;
        $Board{SQUARES}[$x][$y]{COLOUR} = $colour ;
    }
    &action::game_over if $game_over ;
}


sub action::advance {
    return if $ClearingRows ; # Can't move while we're clearing.

    my $action = shift ;

    my( $coords, $x, $y ) ;

    my @block = @{$Block{SQUARES}} ;
    my $can_move = 1 ;
    
    if( $action == $ROTATE ) {
        my @pivot = &action::find_pivot( @block ) ;
        foreach $coords ( @block ) {
            ( $x, $y ) = &action::rotate_block_square( @pivot, @{$coords} ) ;
            # Ignore if we are at the side or if we'd hit the heap.
            $can_move = 0, last if $x < 0 ;
            $can_move = 0, last if $x >= $Opt{BOARD_SQUARES_X} ;
            $can_move = 0, last if $Board{SQUARES}[$x][$y]{TYPE} == $HEAP ;
        }
    }
    elsif( $action == $LEFT ) {
        foreach $coords ( @block ) {
            ( $x, $y ) = @{$coords} ;
            # Ignore if we are at the side or if we'd hit the heap.
            $can_move = 0, last if $x - 1 < 0 ;
            $can_move = 0, last if $Board{SQUARES}[$x - 1][$y]{TYPE} == $HEAP ;
        }
    }
    elsif( $action == $RIGHT ) {
        foreach $coords ( @block ) {
            ( $x, $y ) = @{$coords} ;
            # Ignore if we are at the side or if we'd hit the heap.
            $can_move = 0, last if $x + 1 >= $Opt{BOARD_SQUARES_X} ;
            $can_move = 0, last if $Board{SQUARES}[$x + 1][$y]{TYPE} == $HEAP ;
        }
    }
    else { # $action == $DOWN
        foreach $coords ( @block ) {
            ( $x, $y ) = @{$coords} ;
            # Ignore if we are at the bottom or if we'd hit the heap.
            $can_move = 0, last if $y + 1 >= $Opt{BOARD_SQUARES_Y} ; 
            $can_move = 0, last if $Board{SQUARES}[$x][$y + 1]{TYPE} == $HEAP ;
        }
    }

    # Its safe to move so do so.
    if( $can_move ) {
        @{$Block{SQUARES}} = &action::block( $action, @block ) ;
    }
    elsif( $action == $DOWN ) {
        # We've hit bottom or heap.
        foreach my $coords ( @block ) {
            my( $x, $y ) = @{$coords} ;
            $Board{SQUARES}[$x][$y]{TYPE} = $HEAP ;
            # No need to draw its already there.
        }        
        &action::create_block ;
    }
 
    &action::draw_block ; # This is either the moved block or the new block.

    # Clear any filled rows.
    &action::clear_row ;
    
    $can_move and not $ClearingRows ;
}


sub action::block {
    my( $action, @oldblock ) = @_ ;

    my @newblock = () ;
    my @pivot = &action::find_pivot( @oldblock ) if $action == $ROTATE ; 

    foreach my $coords ( @oldblock ) {
        my( $x, $y ) = @{$coords} ;

        # Remember the old square's colour.
        my $colour = $Board{SQUARES}[$x][$y]{COLOUR} ;

        # Blank out old.
        &action::draw_square( $x, $y, $BOARD ) ;

        # Perform the move.
        if( $action == $LEFT ) {
            $x-- ;
        }
        elsif( $action == $RIGHT ) {
            $x++ ;
        }
        elsif( $action == $DOWN ) {
            $y++ ;
        }
        elsif( $action == $ROTATE ) {
            ( $x, $y ) = &action::rotate_block_square( @pivot, $x, $y ) ;
        }
        unshift @newblock, [ $x, $y ] ;
        $Board{SQUARES}[$x][$y]{TYPE}   = $BLOCK ;
        $Board{SQUARES}[$x][$y]{COLOUR} = $colour ;
    }

    @newblock ;
}


# Pivot algorithm taken from Advanced Perl Programming.
sub action::find_pivot {
    my @block = shift ;

    my( $total_x, $total_y, $squares ) = ( 0, 0, 0 ) ;

    foreach my $coords ( @block ) {
        my( $x, $y ) = @{$coords} ;
        $total_x += $x ;
        $total_y += $y ;
        $squares++ ;
    }
    ( int( $total_x / $squares + 0.5 ) , int( $total_y / $squares + 0.5 ) ) ;
}


sub action::rotate_block_square {
    my( $pivot_x, $pivot_y, $x, $y ) = @_ ;

    my $new_x = $pivot_x + ( $y - $pivot_y ) ;
    my $new_y = $pivot_y - ( $x - $pivot_x ) ;

    ( $new_x, $new_y ) ;
}


sub action::clear_row {
    my $done_row = 0 ;

    $ClearingRows = 1 ;
    ROW :
    for( my $y = $Opt{BOARD_SQUARES_Y} - 1 ; $y > 0 ; $y-- ) {
        my $row_complete = 1 ;
        COLUMN :
        for( my $x = 0 ; $x < $Opt{BOARD_SQUARES_X} ; $x++ ) {
            $row_complete = 0, last COLUMN 
            if $Board{SQUARES}[$x][$y]{TYPE} != $HEAP ;
        }
        if( $row_complete ) {
            $done_row = 1 ;
            &action::move_rows_down( $y ) ; # Move all higher rows down.
            last ROW ; # We only need look once per action.
        }
    }
    $ClearingRows = 0 unless $done_row ;
}


sub action::move_rows_down {
    my $complete_row = shift ;
    my( $x, $y, $colour ) ;

    # Increment the score.
    $Opt{SCORE} += $Global{SCORE_INC} ;
    $Buttons{SCORE}->configure( -text => $Opt{SCORE} ) ;
    $Global{LINES}++ ;
    $Buttons{LINES}->configure( -text => $Global{LINES} ) ;
    $Global{INTERVAL} -= $Opt{SPEED_UP} if $Opt{SPEED_UP} ;
    if( $Opt{USE_SPECIAL_LAYOUTS} and 
      ( $Opt{SCORE} % $Global{NEW_BOARD_TRIGGER} == 0 ) ) {         
        &action::new_board ;
        $ClearingRows = 0 ;
        return ; # No point in drawing if we've got a new board.
    }

    # Special effect for deleting a row: colour the row to be deleted then
    # pause for interval millisec.
    $y = $complete_row ;
    for( $x = 0 ; $x < $Opt{BOARD_SQUARES_X} ; $x++ ) {
        $colour = $Board{SQUARES}[$x][$y]{COLOUR} ;
        $Board{SQUARES}[$x][$y]{COLOUR} = $Const{ROW_HIGHLIGHT_COLOUR} ;
        &action::draw_square( $x, $y, $HEAP ) ;
        $Board{SQUARES}[$x][$y]{COLOUR} = $colour ;
    }

    $Win->after( $Opt{INTERVAL}, sub {
        for( $y = $complete_row - 1 ; $y > 0 ; $y-- ) {
            for( $x = 0 ; $x < $Opt{BOARD_SQUARES_X} ; $x++ ) {
                $Board{SQUARES}[$x][$y + 1]{COLOUR} = 
                    $Board{SQUARES}[$x][$y]{COLOUR} ;
                &action::draw_square( $x, $y + 1, $Board{SQUARES}[$x][$y]{TYPE} ) ;
                &action::draw_square( $x, $y, $BOARD ) ;
            }
        }
        # MUST be in this timed block - otherwise user could keep dropping
        # during the pause and this screws things up because during the pause
        # there is still an uncleared row, so by keeping their finger on the
        # down key they can rack up the score. It also messes up the move
        # down, although I'm not clear why. $ClearingRows seems to have cured
        # the problem though.
        $ClearingRows = 0 ;
    }
    ) ;
}


sub action::new_board {
    my @layout = () ;

    # Layouts alternate between random and specified; the specified layouts
    # are displayed in order. Random occurs 50% of the time unless we don't
    # want random layouts.
    if( ( not $Opt{USE_RANDOM_LAYOUTS} ) or 
        ( int( rand( $Const{LAYOUT_MAX} * 2 ) ) <= $Const{LAYOUT_MAX} ) ) {
        @layout = @{$Const{"LAYOUT_" . $Const{LAYOUT}}};
        $Const{LAYOUT} = ++$Const{LAYOUT} % ( $Const{LAYOUT_MAX} + 1 ) ;
    }
    else {
        my $y_limit = int( $Opt{BOARD_SQUARES_Y} / 2 ) ;
        foreach my $i ( 0..( int( rand( $Opt{BOARD_SQUARES_X} * 
                                        $Opt{BOARD_SQUARES_Y} * 0.1 ) ) ) ) {
            my( $x, $y ) = (
                                int( rand( $Opt{BOARD_SQUARES_X} ) ),
                                int( rand( $y_limit ) + $y_limit )
                           ) ;

            unshift @layout, [ $x, $y ] ;
        }    
    }

    &action::clear_board ;

    my $colour = &get_colour ;
    print "L: $colour\n" if $DEBUG ;

    foreach my $coords ( @layout ) {
        my( $x, $y ) = @{$coords} ;
        next if $x < 0 or $x >= $Opt{BOARD_SQUARES_X} or 
                $y < 0 or $y >= $Opt{BOARD_SQUARES_Y} ;
        next if $Board{SQUARES}[$x][$y]{TYPE} == $BLOCK ; 
        $Board{SQUARES}[$x][$y]{TYPE}   = $HEAP ; 
        $Board{SQUARES}[$x][$y]{COLOUR} = $colour ;
        &action::draw_square( $x, $y, $HEAP ) ; 
    }
}


sub action::draw_block {
    foreach my $coords ( @{$Block{SQUARES}} ) {
        action::draw_square( @{$coords}, $BLOCK ) ;
    }
}


sub action::draw_square {
    my( $x, $y, $type ) = @_ ;

   if( $type == $BOARD ) {
        $Board{CANVAS}->itemconfigure( 
            $Board{SQUARES}[$x][$y]{SQUARE},
            -fill    => $Const{BOARD_BACKGROUND_COLOUR},
            ) ;
    }
    else { # ( $type == $BLOCK ) or ( $type == $HEAP ) 
        $Board{CANVAS}->itemconfigure( 
            $Board{SQUARES}[$x][$y]{SQUARE},
            -fill => $Board{SQUARES}[$x][$y]{COLOUR},
            ) ;
    }
    
    $Board{SQUARES}[$x][$y]{TYPE} = $type ;
}


sub action::clear_board {

    for( my $x = 0 ; $x < $Opt{BOARD_SQUARES_X} ; $x++ ) {
        for( my $y = 0 ; $y < $Opt{BOARD_SQUARES_Y} ; $y++ ) {
            &action::draw_square( $x, $y, $BOARD ) ; 
        }
    }
}


sub action::drop {
    return if $ClearingRows ;

    &button::pause if $Global{STATE} == $PAUSED ;
    &action::drop  if not $ClearingRows and &action::advance( $DOWN ) ;
}


sub action::rotate {

    &button::pause if $Global{STATE} == $PAUSED ;
    &action::advance( $ROTATE ) ;
}


sub action::move_left {

    &button::pause if $Global{STATE} == $PAUSED ;
    &action::advance( $LEFT ) ;
}


sub action::move_right {

    &button::pause if $Global{STATE} == $PAUSED ;
    &action::advance( $RIGHT ) ;
}


1 ;
