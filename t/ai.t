use Test::More;
use v5.10;

BEGIN { use_ok( 'AI' ); }
require_ok( 'AI' );
ok ( my $ai = AI->new, "new object" );

subtest 'Encode and decode' => sub {
    ok ( my $str = $ai->encode(1,0,4,0), 'Encode row' );
    ok ( my @ints = $ai->decode($str,4), 'Decode row' );
    is ( $ints[0], 1, "First cell ok" );
    is ( $ints[1], 0, "Second cell ok" );
    is ( $ints[2], 4, "Tird cell ok" );
    is ( $ints[3], 0, "Fourth cell ok" );
};

subtest 'Shift row' => sub {
    my ($s, $f, @r);
    ok ( ($s, $f, @r) = $ai->shift_row(1,2,3,4), "Shift row" );
    is ( $s, 0, "score OK");
    is ( $f, 0, "free_cells OK");
    is ( $ai->encode(@r), $ai->encode(1,2,3,4), "Resulting row is OK");

    ok ( ($s, $f, @r) = $ai->shift_row(0,0,0,1), "Shift row" );
    is ( $s, 0, "score OK");
    is ( $f, 3, "free_cells OK");
    is ( $ai->encode(@r), $ai->encode(1,0,0,0), "Resulting row is OK");

    ok ( ($s, $f, @r) = $ai->shift_row(0,2,3,0), "Shift row" );
    is ( $s, 0, "score OK");
    is ( $f, 2, "free_cells OK");
    is ( $ai->encode(@r), $ai->encode(2,3,0,0), "Resulting row is OK");

    ok ( ($s, $f, @r) = $ai->shift_row(1,1,3,0), "Shift row" );
    is ( $s, 4, "score OK");
    is ( $f, 2, "free_cells OK");
    is ( $ai->encode(@r), $ai->encode(2,3,0,0), "Resulting row is OK");

    ok ( ($s, $f, @r) = $ai->shift_row(1,3,3,0), "Shift row" );
    is ( $s, 16, "score OK");
    is ( $f, 2, "free_cells OK");
    is ( $ai->encode(@r), $ai->encode(1,4,0,0), "Resulting row is OK");

    ok ( ($s, $f, @r) = $ai->shift_row(14,14,8,2), "Shift row" );
    is ( $s, 32768, "score OK");
    is ( $f, 1, "free_cells OK");
    is ( $ai->encode(@r), $ai->encode(15,8,2,0), "Resulting row is OK");
};

subtest 'Simple board moving' => sub {
    my (@b, $s, $f);
    my @board = (
        0, 0, 0, 0,
        0, 0, 0, 1,
        0, 0, 1, 0,
        0, 1, 0, 0,
    );

    ok ( ($s, $f, @b) = $ai->move_board( 'left', @board ), "move board" );
    my @left = (
        0, 0, 0, 0,
        1, 0, 0, 0,
        1, 0, 0, 0,
        1, 0, 0, 0,
    );
    is ( $ai->encode(@b), $ai->encode(@left), "Resulting board is OK");
    is ( $s, 0, "score OK");
    is ( $f, 13, "free_cells OK");

    ok ( ($s, $f, @b) = $ai->move_board( 'up', @board ), "move board" );
    my @up = (
        0, 1, 1, 1,
        0, 0, 0, 0,
        0, 0, 0, 0,
        0, 0, 0, 0,
    );
    is ( $ai->encode(@b), $ai->encode(@up), "Resulting board is OK");
    is ( $s, 0, "score OK");
    is ( $f, 13, "free_cells OK");

    ok ( ($s, $f, @b) = $ai->move_board( 'right', @board ), "move board" );
    my @right = (
        0, 0, 0, 0,
        0, 0, 0, 1,
        0, 0, 0, 1,
        0, 0, 0, 1,
    );
    is ( $ai->encode(@b), $ai->encode(@right), "Resulting board is OK");
    is ( $s, 0, "score OK");
    is ( $f, 13, "free_cells OK");

    ok ( ($s, $f, @b) = $ai->move_board( 'down', @board ), "move board" );
    my @down = (
        0, 0, 0, 0,
        0, 0, 0, 0,
        0, 0, 0, 0,
        0, 1, 1, 1,
    );
    is ( $ai->encode(@b), $ai->encode(@down), "Resulting board is OK");
    is ( $s, 0, "score OK");
    is ( $f, 13, "free_cells OK");
};

subtest 'Sophisticated move' => sub {
    my (@b, $s, $f);
    my @board = (
        0, 0, 2, 1,
        1, 8, 0, 2,
        0, 8, 0, 3,
        1, 1, 2, 4,
    );

    ok ( ($s, $f, @b) = $ai->move_board( 'up', @board ), "move board" );
    my @up = (
        2, 9, 3, 1,
        0, 1, 0, 2,
        0, 0, 0, 3,
        0, 0, 0, 4,
    );
    is ( $ai->encode(@b), $ai->encode(@up), "Resulting board is OK");
    is ( $s, 2**2 + 2**9 + 2**3, "score OK");
    is ( $f, 8, "free_cells OK");
};

done_testing()
