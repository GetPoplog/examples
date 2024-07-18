
/*
FILE:            othello.p
AUTHOR:          Neil Massey
CREATION DATE:   29 Nov 1999
COURSE:          MSc CogSci
PURPOSE:         Play Othello against the computer - main program
LAST MODIFIED:   7 Dec 1999 (by Neil Massey)
RE-FORMATTED: 11 Oct 2011 (A.Sloman)

Changed by A.Sloman (13 Aug 2000) to allow interactions via
the mouse.

Changed by A.Sloman (11 Oct 2011) to slow down display drawing: computers
have speeded up too much!
Introduced slow_X_board;

*/

;;; Added A.S. 11 Oct 2011
global vars slow_X_board;
	;;; Change this to speed up board drawing
	;;; If false the board is drawn quickly. Otherwise it is a number
	;;; of hundredths of a second for delay between displays.

;;; Pause for two seconds
200 -> slow_X_board;

;;; A global variable to store the state of play
vars boardstate = [];

;;; A global variable to store the direction and limits of the eight lines
;;; format is [yinc xinc ylim xlim]
vars direction = [[-1 0 0 -1] [-1 1 0 9] [0 1 -1 9]  [1 1 9 9]
                  [1 0 9 -1]  [1 -1 9 0] [0 -1 -1 0] [-1 -1 0 0]];

;;; A global variable to store whether X windows can be used
vars useX;

;;; A global variable to store the window pointer
vars win_ptr;

;;; Load the other parts of the program

load boardops.p
load rules.p

load boardout.p

load gameops.p
load airoutines.p
lib rclib
uses rc_window_object;

/*
PROCEDURE: player_move(symbol)
INPUTS   : symbol is a one character word
OUTPUTS  : forfeit is a boolean
USED IN  : othello.p
CREATED  : 19 Dec 1999
PURPOSE  : read a players move and process it

TESTS:
    start();
    random_setup();
    show_board();
    player_move("O");

*/

define player_move(symbol) -> forfeit;

    ;;; lvar for symbol to printout
    lvars print_symbol;

    ;;; transform print_symbol if Xwin is used
    transform_symbol(symbol) -> print_symbol;

    ;;; lvar for list of legal moves and the players move
    lvars legal_moves, move;

    ;;; lvar to test whether the player has entered a legal move
    lvars moveCorrect = false;

    ;;; 1. Build a list of possible legal moves
    get_legal_moves(symbol) -> legal_moves;

    ;;; 2. Check for empty list - this means the player will have to forfeit
    ;;; their move
    if legal_moves = [] then
        true -> forfeit;
        return();
    endif;

    ;;; 3. Ask the user for a move until they enter a legal one
    pr('It is your turn, '); pr(print_symbol); pr('.');
	lconstant columns = [A B C D E F G H];
    until moveCorrect do
        npr(' Please enter a move.');
		rc_flush_everything();
		lvars x, y;
		rc_get_coords(win_ptr,identfn,1) -> (x,y);
		
		((x+250) div 50) -> x;
		(250 - y) div 50 -> y;
		if x > 0 and x <= 8 and y > 0 and y <= 8 then
			columns(x) -> x;
			[^x ^y] -> move;
			[MOVE ^move] =>
        	;;; readline() -> move;
        	;;; Check whether it is in the list of legal moves
        	if member(move, legal_moves) then
            	true -> moveCorrect;
        	else
            	pr('Sorry, that is not a legal move, ');
            	pr(print_symbol);
        	endif;
		else
			pr('Please click on the board.');
		endif
    enduntil;

    ;;; process the move and return that no forfeit was needed
    process_move(move, symbol);
    false -> forfeit;
enddefine;



/*
PROCEDURE: get_player_symbol() -> symbol
INPUTS   : NONE
OUTPUTS  : symbol is a one character word
USED IN  : othello.p
CREATED  : 6 Jan 2000
PURPOSE  : get the symbol the player wishes to play as, either "O" or "X"

TESTS:

*/

define get_player_symbol() -> symbol;

    ;;; local variable to store whether O or X has been entered
    lvars valid_response = false, line, r;

    ;;; if using X windows then ask for a colour otherwise a symbol
    npr(' ');
    if useX then
        npr('Do you wish to play as red (r) or blue (b)');
        npr('Red plays first');
        until valid_response do
            npr('Please enter either r or b');
            readline()   -> line;
			if line matches [ = ] then
            	line(1)   -> r;
            	;;; check for valid response and remap symbols
            	if r = "r" then
                	"O" -> symbol;
                	true -> valid_response;
            	elseif r = "b" then
                	"X" -> symbol;
                	true -> valid_response;
            	endif;
            endif;
        enduntil;
    else
        npr('Do you wish to play as noughts ("O") or crosses ("X")');
        npr('Noughts ("O") play first');
        until valid_response do
            npr('Please enter either O or X');
            readline ()(1)   -> symbol;
            if (symbol = "O" or symbol = "X") then
                true -> valid_response;
            endif;
        enduntil;
    endif;


enddefine;

/*

PROCEDURE: main_loop()
INPUTS   : NONE
OUTPUTS  : NONE
USED IN  : othello.p
CREATED  : 19 Dec 1999
PURPOSE  : main loop to play the othello game

TESTS:
    start();
*/

define main_loop();

    ;;; lvars for storing whether the last turn was forfeited or not
    lvars player_forfeit = false, computer_forfeit = false, dummy;

    ;;; lvar for storing the players symbol and computer symbol
    lvars player_symbol, computer_symbol;

    ;;; get the players symbol and derive the computers symbol
    get_player_symbol() -> player_symbol;
    opponents_symbol(player_symbol) -> computer_symbol;

	
    ;;; if X windows is to be used then create the window
    if useX then
        rc_new_window_object(10, 10, 600, 600, true, 'Othello by Neil Massey')
         -> win_ptr;
        win_ptr -> rc_current_window_object;
    endif;
    show_board();
	;;; Added A.S. 11 Oct 2011
	if slow_X_board then syssleep(slow_X_board) endif;

    ;;; if the computer is O then force it to have the first go
    if computer_symbol = "O" then
        aicomputer_move(computer_symbol) -> computer_forfeit;
    endif;

    ;;; if X windows is to be used then create the window
    if useX then
        rc_new_window_object(10, 10, 600, 600, true, 'Othello by Neil Massey')
         -> win_ptr;
        win_ptr -> rc_current_window_object;
    endif;

    show_board();
	;;; Added A.S. 11 Oct 2011
	if slow_X_board then syssleep(slow_X_board) endif;

    ;;; Loop until game over
    until(player_forfeit and computer_forfeit) do

        ;;; get the players move
        player_move(player_symbol) -> player_forfeit;

        ;;; only show the board if the player has made a move
        if player_forfeit then
            show_forfeit(player_symbol, false);
        else
            show_board();
			;;; Added A.S. 11 Oct 2011
			if slow_X_board then syssleep(slow_X_board) endif;
        endif;

        ;;; get the computers move
        aicomputer_move(computer_symbol) -> computer_forfeit;

        ;;; show the board for the computer's move unless it has
        ;;; forfeited its turn or it's game over
        if computer_forfeit then
            show_forfeit(computer_symbol, true);
        else
            show_board();
			;;; Added A.S. 11 Oct 2011
			if slow_X_board then syssleep(slow_X_board) endif;
        endif;
    enduntil;

    ;;; Find out who has won
    show_winner( find_winner() );

    ;;; show the board until the user presses a key
    npr('Press the return key to finish');
    readline() -> dummy;

    ;;; kill the window
    rc_kill_window_object(win_ptr);
enddefine;

/*
PROCEDURE: start()
INPUTS   : NONE
OUTPUTS  : NONE
USED IN  : othello.p
CREATED  : 29 Nov 1999
PURPOSE  : set the board up as othello is played and call all the intialisation
           procedures before calling the main loop

TESTS:
    start();
    boardstate ==>
*/

define start();

    ;;; Initialize the boardstate to that of othello

    [ [# # # # # # # #]
      [# # # # # # # #]
      [# # # # # # # #]
      [# # # O X # # #]
      [# # # X O # # #]
      [# # # # # # # #]
      [# # # # # # # #]
      [# # # # # # # #] ] -> boardstate;

	;;; Remove this option, A.S. 11 Oct 2011
    ;;; get whether X windows should be used
    ;;; get_X_win() -> useX;
    true -> useX;

    ;;; show the rules and start the game
    show_format();
    main_loop();

enddefine;

start();
