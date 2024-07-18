
/*
FILE:            boardout.p
AUTHOR:          Neil Massey
CREATION DATE:   5 Jan 2000
COURSE:          MSc CogSci
PURPOSE:         Output for the othello board - text only at the moment
LAST MODIFIED:   5 Jan 2000

RE-FORMATTED: 11 Oct 2011 (A.Sloman)

*/

/*
PROCEDURE: show_text_board()
INPUTS   : NONE
OUTPUTS  : NONE
USED IN  : othello.p
CREATED  : 29 Nov 1999
PURPOSE  : display the state of the board

TESTS:
    start();
    show_text_board();
*/

;;; no longer used
define show_text_board();

    ;;; Local loop variables
    lvars x,y;

    ;;; Draw the 8 x 8 board
    for y from 1 to 8 do

        ;;; Print the vertical dividing lines
        for x from 1 to 8 do
            pr('+---');
        endfor;
        ;;; Print the right most corner of the line
        npr('+');

        ;;; Print the horizontal lines and the symbols for the
        ;;; current state of the board
        for x from 1 to 8 do
            ;;; Print the bar
            pr('| ');
            ;;; Now print the symbol - if # then print a space
            if boardstate(y)(x) = "#" then
                pr('  ');
            else
                pr(boardstate(y)(x));
                pr(' ');
            endif;
        endfor;
        ;;; Print the right most bar of the line and the row number
        pr('|   ');
        npr(y);
    endfor;

    ;;; Put the bottom line in
    npr('+---+---+---+---+---+---+---+---+');

    ;;; Print the column letters
    npr('');
    npr('  A   B   C   D   E   F   G   H');

enddefine;

/*
PROCEDURE: show_X_board()
INPUTS   : NONE
OUTPUTS  : NONE
USED IN  : othello.p
CREATED  : 9 Jan 2000
PURPOSE  : show the X windows version of the board
*/

define show_X_board();

    ;;; lvars for x and y coordinates and what is at the position in the board
    ;;; and the colour the chip should be
    lvars x, y, b, c;

    ;;; clear the window
    rc_start();

    ;;; draw the 9 vertical and 9 horizontal lines on the 600x600 window
    for y from -200 by 50 to 200 do
        rc_drawline(-200, y, 200, y);
    endfor;

    for x from -200 by 50 to 200 do
        rc_drawline(x, -200, x, 200);
    endfor;

    ;;; write the letters and numbers for the rows and columns out
    for x from 1 to 8 do
        rc_print_at(x*50 - 230, 240, ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H'](x) );
    endfor;

    for y from 1 to 8 do
        rc_print_at(240, y*50 - 230, ['8' '7' '6' '5' '4' '3' '2' '1'](y) );
    endfor;

    ;;; now use rc_draw_blob to draw the othello chips
    ;;; by looping through the board and drawing the counters etc.
    for y from 1 to 8 do
        for x from 1 to 8 do
            boardstate(y)(x) -> b;
            ;;; only draw something if there is not a space there
            unless b = "#" then
                ;;; determine which colour to draw the chip as
                if b = "O" then
                    'red' -> c;
                else
                    'blue' -> c;
                endif;
                ;;; now draw the chip at the center of each square
                rc_draw_blob( x * 50 - 225, 225 - y * 50, 20, c);
            endunless;
        endfor;
    endfor;
enddefine;


/*
PROCEDURE: show_board()
INPUTS   : NONE
OUTPUTS  : NONE
USED IN  : othello.p
CREATED  : 9 Jan 2000
PURPOSE  : show the required board for X windows or text only

*/

define show_board();
    ;;; if X is used show the graphical board, otherwise show the text board
    if useX then
        show_X_board();
    else
        show_text_board();
    endif;
enddefine;


/*
PROCEDURE: show_format()
INPUTS   : NONE
OUTPUTS  : NONE
USED IN  : othello.p
CREATED  : 6 Jan 2000
PURPOSE  : Show the format that moves must be entered in.
           Ask the user whether they want to see the rules or not
           and display them if they do

TESTS:
    show_format();

*/

define show_format();

    ;;; local variables for response
    lvars r;

    npr('Welcome to  Othello, the  game  that  takes a  minute to');
    npr('learn and a lifetime to master');
    npr('The rules are as standard  Othello and the moves must be');
    npr('entered in the format : column <space> row');
    npr('i.e.  type a  letter  between  A and H  for  the  column');
    npr('followed  by a space and then a  number  between 1 and 8');
    npr('for the row');
    npr('');
    npr('Would you like to see the rules ?');
    npr('Please enter y or n');
    readline()(1) -> r;
    if r = "y" then
        show_rules();
    endif;
enddefine;



/*
PROCEDURE: transform_symbol(symbol) -> new_symbol
INPUTS   : symbol is a one character word either "O" or "X"
OUTPUTS  : new_symbol is a word
USED IN  : othello.p
CREATED  : 9 Jan 2000
PURPOSE  : if X windows is to be used then the user will have to be asked
           questions in terms of red and blue.  If text mode is selected
           then they will be in terms of O and X.  The procedure transforms
           the internal representation to the one printed for the user

*/

define transform_symbol(symbol) -> new_symbol;

    if useX then
        if symbol = "O" then
            "red" -> new_symbol
        elseif symbol = "X" then
            "blue" -> new_symbol;
        else
            symbol -> new_symbol;
        endif;
    else
        symbol -> new_symbol;
    endif;
enddefine;

/*
PROCEDURE: get_X_win()-> boolean
INPUTS   : NONE
OUTPUTS  : boolean is a boolean
USED IN  : othello.p
CREATED  : 9 Jan 2000
PURPOSE  : ask the user whether X windows can be used or not

TESTS:
    get_X_win() =>;

*/

;;; No longer used
define get_X_win() -> boolean;

    ;;; lvar for temporary response;
    lvars r;

    npr(' '); npr(' ');
    npr(' Othello - Written by Neil Massey for MSc CogSci course');
    npr('========================================================');

    npr('Do you wish to use graphics? (you must have X windows and RClib)');
    npr('Please enter y (for graphics)');
    npr('             n (for text only)');

    readline()(1) -> r;
    if r = "y" then
        true -> boolean;
    else
        false -> boolean;
    endif;

enddefine;

/*
PROCEDURE: show_forfeit(symbol, computer)
INPUTS   : symbol, computer
  Where  :
    symbol is a one character word - either "O" or "X"
    computer is a boolean indicating whether this is the computer or not
OUTPUTS  : NONE
USED IN  : othello.p
CREATED  : 9 Jan 2000
PURPOSE  : Show forfeit messages

TESTS:
    show_forfeit("X", true);
    show_forfeit("O", false);
*/

define show_forfeit(symbol, computer);

    ;;; get the correct symbol for the mode
    transform_symbol(symbol) -> symbol;

    ;;; display a different message for the computer player
    if computer then
        pr('The computer, playing as '); pr(symbol);
        npr(', has no legal moves');
        npr('It gallantly forfeits its turn');
    else
        pr('Sorry, '); pr(symbol);
        npr(', there are no legal moves that you can perform');
        npr('You will have to forfeit your turn');
    endif;
enddefine;

/*
PROCEDURE: show_winner(winner)
INPUTS   : winner is a word
OUTPUTS  : NONE
USED IN  : othello.p
CREATED  : 9 Jan 2000
PURPOSE  : display the winner message

TESTS:
    show_winner("O");
    show_winner("draw");
*/

define show_winner(winner);

    ;;; get the correct symbol for the mode
    transform_symbol(winner) -> winner;

    npr('Game over');
    ;;; see if the game is a draw or not
    if winner = "draw" then
        npr('The game is a draw');
    else
        pr('The winner is '); npr(winner);
    endif;
enddefine;


/*
PROCEDURE: show_computer_move(move, symbol)
INPUTS   : move, symbol
  Where  :
    move is a list containing
    symbol is a one character word - either "O" or "X"
OUTPUTS  : NONE
USED IN  : othello.p
CREATED  : 9 Jan 2000
PURPOSE  : report the computers move

TESTS:
    show_computer_move([E 5], "O");
*/

define show_computer_move(move, symbol);

    ;;; get the correct symbol for the mode
    transform_symbol(symbol) -> symbol;

    ;;; print the message out informing the player of the computers move
    pr('The computer, playing as '); pr(symbol);
    pr(', has decided to play at : '); npr(move);
enddefine;
