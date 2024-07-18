/*
FILE:            airoutines.p
AUTHOR:          Neil Massey
CREATION DATE:   6 Jan 2000
COURSE:          MSc CogSci
PURPOSE:         The artificial intelligence routines for the computer
                 player in othello
LAST MODIFIED:   6 Jan 2000

RE-FORMATTED: 11 Oct 2011 (A.Sloman)
*/


/*
PROCEDURE: computer_move(symbol) -> forfeit
INPUTS   : symbol is a one character word - either "O" or "X"
OUTPUTS  : forfeit is a boolean
USED IN  : othello.p
CREATED  : 6 Jan 2000
PURPOSE  : random computer move generator

TESTS:

*/

define computer_move(symbol) -> forfeit;

    ;;; lvars for list of legal moves and the computers move
    lvars legal_moves, move;

    ;;; get all the moves the computer can legally perform
    get_legal_moves(symbol) -> legal_moves;

    ;;; check for empty list-this means computer will have to forfeit its turn
    if legal_moves = [] then
        true -> forfeit;
        return();
    endif;

    ;;; otherwise pick one of the moves from the list at random
    oneof(legal_moves) -> move;

    ;;; process the move and return that no forfeit was needed
    show_computer_move(move, symbol);
    process_move(move, symbol);
    false -> forfeit

enddefine;


/*
PROCEDURE: evaluate_board(symbol) -> value
INPUTS   : symbol is a one character word, either "O" or "X"
OUTPUTS  : value is an integer
USED IN  : othello.p
CREATED  : 7 Jan 2000
PURPOSE  : static evaluation function for the supplied symbol
           rules are :  4 points for a symbol in a corner
                        2 points for a symbol along an edge
                        1 point for a symbol in any other position

TESTS:

    [ [O # # # # # # #]
      [# # # # # O # O]
      [# X # # # # # #]
      [# # # O X # # O]
      [# # # X O # # #]
      [# O # # # # # #]
      [# # # # # # # O]
      [O # # O # O # #] ] -> boardstate;

    evaluate_board("O") =>
*/

define evaluate_board(symbol) -> value;

    ;;; local loop variables
    lvars x, y;

    ;;; initialize value to 0
    0 -> value;

    ;;; first check the corners
    if read_symbol([A 1]) = symbol then value + 4 -> value;  endif;
    if read_symbol([A 8]) = symbol then value + 4 -> value;  endif;
    if read_symbol([H 1]) = symbol then value + 4 -> value;  endif;
    if read_symbol([H 8]) = symbol then value + 4 -> value;  endif;

    ;;; now check the edges
    for x from 2 to 7 do
        if boardstate(1)(x) = symbol then value + 2 -> value;  endif;
        if boardstate(8)(x) = symbol then value + 2 -> value;  endif;
    endfor;

    for y from 2 to 7 do
        if boardstate(y)(1) = symbol then value + 2 -> value;  endif;
        if boardstate(y)(8) = symbol then value + 2 -> value;  endif;
    endfor;

    ;;; now check the rest of the board
    for y from 2 to 7 do
        for x from 2 to 7 do
            if boardstate(y)(x) = symbol then value + 1 -> value; endif;
        endfor;
    endfor;
enddefine;



/*
PROCEDURE: aicomputermove(symbol) -> forfeit
INPUTS   : symbol is a one character word - either "O" or "X"
OUTPUTS  : forfeit is a boolean
USED IN  : othello.p
CREATED  : 8 Jan 2000
PURPOSE  : uses MiniMax principles to determine a move for the computer

TESTS:

*/

define aicomputer_move(symbol) -> forfeit;

    lvars node1, node2;

    ;;; lvar for opponents symbol
    lvars opp_symbol;
    opponents_symbol(symbol) -> opp_symbol;

    ;;; lvars for list of legal moves, the computers move and the recommended
    ;;; move
    lvars legal_moves, move, rec_move;

    ;;; lvars for list of opponents moves and their choosen move
    lvars opponents_moves, opp_move;

    ;;; lvar for the boardstate tree
    lvars boardtree = [];

    ;;; lvar for the overall maximum, the nodes maximum, the evaluation
    ;;; value of the node for the opponent and the value of the board for
    ;;; the computer
    lvars maxi, node_maxi, node, comp_node;

    ;;; get all the moves the computer can legally perform
    get_legal_moves(symbol) -> legal_moves;

    ;;; check for empty list-this means computer will have to forfeit its turn
    if legal_moves = [] then
        true -> forfeit;
        return();
    endif;

    ;;; set the opponent maximum to one less than -(theoretical maximum)
    -101 -> maxi;
    ;;; preserve the current boardstate by inserting it into the tree
    [ ^(copytree(boardstate) ) ] -> boardtree;

    ;;; now loop through all of the moves in legal_moves
    for move in legal_moves do
        ;;; perform the move and insert it at the end of the boardtree
        process_move(move, symbol);
        ;;; evaluate the board for the computer
        evaluate_board(symbol) -> comp_node;
        [ ^^boardtree ^(copytree(boardstate) ) ] -> boardtree;
        ;;; now get a list of legal moves for the opposition
        get_legal_moves(opp_symbol) -> opponents_moves;

        ;;; set the nodes maximum to the minimum = 0
        0 -> node_maxi;
        ;;; loop through all of these moves
        for opp_move in opponents_moves do
            ;;; perform the move for the opposition
            process_move(opp_move, opp_symbol);
            ;;; evaluate the board for the opponent
            evaluate_board(opp_symbol) -> node;
            ;;; check if this is greater than the nodes max
            if node > node_maxi then
                node -> node_maxi;
            endif;
            ;;; restore the boardstate to the second node
            copytree(boardtree(2) ) -> boardstate;
        endfor;

        ;;; check if theis is a better move than the previous
        if (comp_node - node_maxi) > maxi then
            move -> rec_move;
            (comp_node - node_maxi) -> maxi;
        endif;
        ;;; restore the boardstate to the first node in the tree and delete
        ;;; the second node
        copytree( boardtree(1) ) -> boardstate;
        allbutlast(1, boardtree) -> boardtree;
    endfor;

    ;;; tell the user of the move, process the move
    ;;; and return that no forfeit was needed
    show_computer_move(rec_move, symbol);
    process_move(rec_move, symbol);
    false -> forfeit

enddefine;
