package AI;
use v5.12;
use strict;
use Moo;
use Data::Dumper;

sub encode {
    my $self = shift;
    my @ints = @_;
    my $string = "";

    for my $i ( 0 .. @ints -1 ) {
        vec( $string, $i, 4 ) = $ints[$i];
    }

    $string;
}

sub decode {
    my ( $self, $string, $length ) = @_;

    my @ints;

    for my $i ( 0 .. $length -1 ) {
        push @ints, vec( $string, $i, 4 );
    }

    @ints;
}

sub shift_row {
    my ( $self, @tiles ) = @_;

    my $free  = 0;
    my $score = 0;
    # Not null tiles, this moves all left
    @tiles = grep {$_} @tiles;
    # Complete void tiles
    $tiles[$_] = 0 for (@tiles..3);

    # Join pairs
    for my $p ( [0,1], [1,2], [2,3] ) {
        next unless $tiles[$p->[0]] && $tiles[$p->[1]];
        if ( $tiles[$p->[0]] == $tiles[$p->[1]] ) {
            $tiles[$p->[0]] += 1;
            $tiles[$p->[1]] = 0;
            $score += 2 ** $tiles[$p->[0]];
        }
    }

    # Move null tiles to right and count free cells
    @tiles = grep {$_} @tiles;
    $free  = 4 - @tiles;
    $tiles[$_] = 0 for (@tiles..3);

    return $score, $free, @tiles;
}

sub move_board {
    my ( $self, $direction, @board ) = @_;

    my $score = 0;
    my $free  = 0;
    my @new_board;
    my @pos = $self->transformation_array($direction);

    for (0..3) {
        my ($p0,$p1,$p2,$p3) = (shift @pos, shift @pos, shift @pos, shift @pos );
        my ( $row_score, $row_free, @row) = $self->shift_row( $board[$p0], $board[$p1], $board[$p2], $board[$p3] );

        $new_board[$p0] = $row[0];
        $new_board[$p1] = $row[1];
        $new_board[$p2] = $row[2];
        $new_board[$p3] = $row[3];

         $score += $row_score;
         $free  += $row_free;
    }

    return $score, $free, @new_board;
}

sub transformation_array {
    my ( $self, $direction ) = @_;

    if ( $direction eq 'left' ) {
        return ( 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 );
    }
    elsif ( $direction eq 'up' ) {
        return ( 0,4,8,12,1,5,9,13,2,6,10,14,3,7,11,15 );
    }
    elsif ( $direction eq 'right' ) {
        return ( 3,2,1,0,7,6,5,4,11,10,9,8,15,14,13,12 );
    }
    elsif ( $direction eq 'down' ) {
        return ( 12,8,4,0,13,9,5,1,14,10,6,2,15,11,7,3 );
    }
    else {
        die "Direction not allowed, try 'left', 'up', 'right' or 'down'.";
    }
}

1;
