/*

FILE:            boardops.p
AUTHOR:          Neil Massey
CREATION DATE:   5 Jan 2000
COURSE:          MSc CogSci
PURPOSE:         Input / output operations on the Othello board
LAST MODIFIED:   5 Jan 2000

RE-FORMATTED: 11 Oct 2011 (A.Sloman)
*/

/*
PROCEDURE: column_to_int(column) -> number
INPUTS   : column is a word
OUTPUTS  : number is an integer
USED IN  : othello.p
CREATED  : 29 Nov 1999
PURPOSE  : convert a column character (A..H) to a number (1..8) so it
           can be used to reference the boardstate list

TESTS:
    column_to_int("A") =>
    column_to_int("G") =>
*/

define column_to_int(column) -> number;
    ;;; Uses word_string to convert the word to a string
    ;;; then takes the first character which coerces it to its ASCII
    ;;; integer and then the ASCII integer for A (64) is subtracted
    ;;; to derive the column number

    word_string(column)(1) - 64 -> number;
enddefine;

/*
PROCEDURE: random_setup()
INPUTS   : NONE
OUTPUTS  : NONE
USED IN  : othello.p
CREATED  : 29 Nov 1999
PURPOSE  : generate a random (possibly ILLEGAL) board setup

TESTS:
    start();
    random_setup();
    show_board();

*/

define random_setup();

    ;;; Initialize board to a random state
    ;;; NB this may not be a LEGAL board representation
    ;;; but is useful for testing

    lvars x,y,r;

    for y from 1 to 8 do
        for x from 1 to 8 do
            ;;; Get a random number between 1 and 3
            random(3) -> r;
            if r = 1 then
                "O" -> boardstate(y)(x);
            elseif r = 2 then
                "X" -> boardstate(y)(x);
            else
                "#" -> boardstate(y)(x);
            endif;
        endfor;
    endfor;

enddefine;


/*
PROCEDURE: read_symbol(move) -> line
INPUTS   : move is a list of column then row
OUTPUTS  : line is a word, either O, X or #
USED IN  : othello.p
CREATED  : 13 Dec 1999
PURPOSE  : read in the symbol at the square indicated by move

TESTS:
    start();
    random_setup();
    show_board();
    read_symbol([C 5]) =>

*/

define read_symbol(move) -> symbol;
    ;;; use column to int to read what is in the square indicated
    ;;; by move

    boardstate(move(2))(column_to_int(move(1))) -> symbol;

enddefine;


/*
PROCEDURE: write_symbol(move, symbol)
INPUTS   : move, symbol
  Where  :
    move is a list containing [column, row]
    symbol is a one character word
OUTPUTS  : NONE
USED IN  : othello.p
CREATED  : 15 Dec 1999
PURPOSE  : write a symbol in the space intended

TESTS:
    start();
    write_symbol([E 6], "O");
    show_board();

*/

define write_symbol(move, symbol);
    ;;; use column to int to write in the square the symbol
    symbol -> boardstate(move(2))(column_to_int(move(1)));
enddefine;

/*
PROCEDURE: read_line(move, dir) -> line
INPUTS   : move, dir
  Where  :
    move is a list containing row then column
    dir is a number 1..8 representing the direction the line is to be read
        from the move position
OUTPUTS  : line is a list containing the symbols of the game(O, X, #)
USED IN  : othello.p
CREATED  : 7 Dec 1999
PURPOSE  : read a line from the board

TESTS:
    read_line([F 8], 1) =>

*/

define read_line(move, dir) -> line;

    /* dir is the direction you want to read the line in according to :
         8 1 2
         7 * 3
         6 5 4  */

    ;;; local variables to store the details from the direction list
    lvars yinc, xinc, ylim, xlim;

    ;;; local variables to store the current position when reading the line
    lvars x, y;

    ;;; get the values of the incrementers and limits
    direction(dir) --> ! [?yinc ?xinc ?ylim ?xlim];

    ;;; initialize line variable
    [] -> line;
    ;;; initialize current position variables
    column_to_int(move(1)) -> x;
    move(2) -> y;

    ;;; now build the string in a loop until either the xlimit or ylimit
    ;;; has been reached
    while not(y = ylim or x = xlim) do
        [^^line ^(boardstate(y)(x))] -> line;
        y + yinc -> y;
        x + xinc -> x;
    endwhile;
enddefine;


/*
PROCEDURE: write_line(move, symbol, dir, len)
INPUTS   : move, symbol, dir, len
  Where  :
    move is a list containing column then row
    dir is an integer
    symbol is a word either "O" or "X"
    len is an integer
OUTPUTS  : list is a list containing the moves the procedure has written
           symbols into
USED IN  : othello.p
CREATED  : 7 Dec 1999
PURPOSE  : write a line of symbols in the direction specified for the length
           specified

TESTS:
    start();
    random_setup();
    show_board();
    write_line([A 8], "O", 2, 8) =>;
    show_board();

*/

define write_line(move, symbol, dir, len) -> list;

    /* dir is the direction you want to write the line according to :
         8 1 2
         7 * 3
         6 5 4  */

    ;;; local variables to store the details from the direction list
    lvars yinc, xinc, ylim, xlim;

    ;;; local variables to store the current position when writing the line
    lvars x, y;

    ;;; local loop variable
    lvars l;

    ;;; get the values of the incrementers and limits
    direction(dir) --> ! [?yinc ?xinc ?ylim ?xlim];

    ;;; initialize current position variables
    column_to_int(move(1)) -> x;
    move(2) -> y;

    ;;; intialize the list of moves written into
    [] -> list;

    ;;; it is len + 2 so as to add a symbol at the beginning
    ;;; and end of the line
    for l from 1 to len + 2 do
        ;;; Write a symbol in the space at y,x
        symbol -> boardstate(y)(x);
        ;;; Append the list with the move space just written into
        [^^list [^([A B C D E F G H](x)) ^y] ] -> list;
        ;;; Increment the coordinates
        x + xinc -> x;
        y + yinc -> y;
    endfor;
    ;;; trim the hd and tail of the list to avoid erroneous flipping
    allbutfirst(1, list) -> list;
    allbutlast(1, list) -> list;

enddefine;
