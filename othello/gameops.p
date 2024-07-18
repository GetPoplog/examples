/*
FILE:            gameops.p
AUTHOR:          Neil Massey
CREATION DATE:   6 Jan 2000
COURSE:          MSc CogSci
PURPOSE:         Contains all the operations that make playing the game
                 possible
LAST MODIFIED:   6 Jan 2000

RE-FORMATTED: 11 Oct 2011 (A.Sloman)

*/


/*
PROCEDURE: opponents_symbol(symbol) -> result
INPUTS   : symbol is a one character word
OUTPUTS  : result is a one character word
USED IN  : othello.p
CREATED  : 14 Dec 1999
PURPOSE  : return the opponents symbol if symbol is the players symbol
           If neither "O" or "X" are passed then return false
TESTS:
    opponents_symbol("O") =>
    opponents_symbol("#") =>
    opponents_symbol([darth vader]) =>
*/

define opponents_symbol(symbol) -> result;
    ;;; return the opposite symbol to that passed in by the parameter
    if symbol = "O" then
        "X" -> result;
    elseif symbol = "X" then
        "O" -> result;
    else
        false -> result;
    endif;
enddefine;


/*
PROCEDURE: line_is_move(line, symbol, proces) -> boolean
INPUTS   : line, symbol, proces
  Where  :
    line is a list of symbols
    symbol is a one character word
    proces is a boolean to indicate whether the program is in the
        processing move stage (i.e. called from the process_move procedure)
OUTPUTS  : len is either the length of the line that should be written if the
           move is taken or false if this is not a legal move
USED IN  : othello.p
CREATED  : 14 Dec 1999
PURPOSE  : determine whether the line is a legal move

TESTS:
    line_is_move([# O # O O X # # O X], "X", true) =>
    line_is_move([# X X X O # O X], "O", false) =>

*/

define line_is_move(line, symbol, proces) -> len;
    ;;; determines whether placing the symbol at the beginning of the line
    ;;; would make a legal move

    ;;; local variable for the pattern matcher
    lvars o, item;

    ;;; local variable for incrementing and for holding items
    lvars i = 0;

    ;;; use the pattern matcher to get the string between the current
    ;;; square and any players symbol
    ;;; also check for a match between two of the players symbols
    if (line matches ! [# ??o ^symbol ==]
      or (line matches ! [^symbol ??o ^symbol ==] and proces)) then
        for item in o do
            ;;; If this is an opponents symbol then add one to i
            if item = opponents_symbol(symbol) then
                i + 1 -> i;
            endif;
        endfor;
        ;;; for this to be a legal move i should equal length(o) and not 0
        ;;; this means that all symbols is o are opponents symbols
        if (i = length(o) and i > 0) then
            ;;; write the length of opponents symbols to i
            i -> len;
            return();
        endif;
    endif;
    false -> len;
enddefine;

/*
PROCEDURE: get_legal_moves(symbol) -> list
INPUTS   : symbol is a one character word - either "O" or "X"
OUTPUTS  : list is a list of moves
USED IN  : othello.p
CREATED  : 14 Dec 1999
PURPOSE  : generate a list of legal moves for the symbol

TESTS:
    start();
    show_board();
    get_legal_moves("X") ==>
    write_line([E 6], "X", 1, 3) =>

*/

define get_legal_moves(symbol) -> list;
    ;;; Use the above defined procedures to build a list of all legal moves
    ;;; store the list as : [move]

    ;;; lvars for storing a line and its length
    lvars line, len;

    ;;; lvars for storing loop variables (there are to be three nested loops!)
    lvars i, j, k;

    ;;; initialize the list
    [] -> list;

    ;;; loop through all columns (8)
    for i in [A B C D E F G H] do
        ;;; loop through all rows (8)
        for j from 1 to 8 do
            ;;; loop through all possible lines (8)
            for k from 1 to 8 do
                ;;; read the line
                read_line( [^i ^j], k) -> line;
                ;;; check if is a move and get its length if it is
                line_is_move(line, symbol, false) -> len;
                unless (len=false or member( [^i ^j], list) ) then
                    ;;; if the line is a move then write it into the list
                    [ ^^list [^i ^j]  ] -> list;
                endunless;
            endfor;
        endfor;
    endfor;
enddefine;


/*
PROCEDURE: process_move(move, symbol)
INPUTS   : move, symbol
  Where  :
    move is a list containing the column and row the player has played in
    symbol is a one character word containing "O" or "X"
OUTPUTS  : NONE
USED IN  : othello.p
CREATED  : 5 Jan 2000
PURPOSE  : Process the players move.  Flip the chips in all directions
           that a legal move occurs and also for any moves that are formed
           from flipping those chips.

TESTS:

*/

define process_move(move, symbol);

    ;;; local variables to store the list of moves and the line derived
    ;;; from the move plus the currentmove from the list and the new
    ;;; moves returned from the write_line procedure
    lvars movelist, line, currentmove, newmoves;

    ;;; local variables for looping and storing the length of the line
    lvars k, len;

    ;;; insert the move into the move list
    [ ^move ] -> movelist;

    ;;; repeat until all moves and all moves chaining from this move have
    ;;; been made
    until movelist = [] do
        ;;; get the first move from the list and delete it from the list
        movelist(1) -> currentmove;
        allbutfirst(1, movelist) -> movelist;

        ;;; loop through all possible moves
        for k from 1 to 8 do
            ;;; read the line from the board
            read_line(currentmove, k) -> line;
            ;;; check if it is a legal line and get its length if it is
            line_is_move(line, symbol, true) -> len;
            unless len=false then
                ;;; if the line is a move then write it to the board
                ;;; and update the move list
                write_line(currentmove, symbol, k, len) -> newmoves;
                [ ^^newmoves ^^movelist ] -> movelist;
            endunless;
        endfor;
    enduntil;

enddefine;


/*
PROCEDURE: find_winner()
INPUTS   : NONE
OUTPUTS  : symbol is a one character word denoting the winner - either
           "O", "X" or "draw"
USED IN  : othello.p
CREATED  : 6 Jan 2000
PURPOSE  : find the winner of a game by counting all chips that belong to
           X or O
TESTS:

*/

define find_winner() -> symbol;

    ;;; local variables for loops and temporary symbol
    lvars x, y, s;

    ;;; local variables for incrementing number of O's or X's
    lvars O = 0, X = 0;

    ;;; loop through the rows
    for y from 1 to 8 do
        ;;; loop through the columns
        for x from 1 to 8 do
            ;;; get the symbol off the board
            boardstate(y)(x) -> s;
            if s = "O" then
                O + 1 -> O
            elseif s="X" then
                X + 1 -> X
            endif;
         endfor;
    endfor;

    ;;; Find out who had the most chips on the board
    if O = X then
        "draw" -> symbol;
    elseif O > X then
        "O" -> symbol;
    else
        "X" -> symbol;
    endif;
enddefine;
