/*
FILE:            rules.p
AUTHOR:          Neil R Massey
CREATION DATE:   19 Jan 2000
COURSE:          MSc CogSci
PURPOSE:         hole and display the rules for othello
LAST MODIFIED:   19 Jan 2000

RE-FORMATTED: 11 Oct 2011 (A.Sloman)

*/


/*
PROCEDURE: show_rules()
INPUTS   : NONE
OUTPUTS  : NONE
USED IN  : othello.p
CREATED  : 19 Jan 2000
PURPOSE  : show the rules of othello to the user

TESTS:

    show_rules();

*/

define show_rules();

    ;;; lvar for dummy input
    lvars dummy;

    npr(' ======================== The Rules Of Othello =============================');
    npr('');
    npr('Othello is played on an 8x8 board.  There are 64 chips in the game.  Each');
    npr('chip consists of a red side and a blue side.  The game is for two players.');
    npr('Each player chooses to play as a colour, either red or blue.  In the text');
    npr('version of the game, O indicates a red piece, X a blue piece. ');
    npr('During the game the chips are placed on the board and may be flipped as');
    npr('the players perform moves.');
    npr('');
    npr('1.  The starting position consists of the chips being set in the pattern:');
    npr('  |   |   |  ');
    npr('--+---+---+--');
    npr('  | O | X |  ');
    npr('--+---+---+--');
    npr('  | X | O |  ');
    npr('--+---+---+-- ');
    npr('  |   |   |  ');
    npr('');
    npr('in the centre of the board.');
    npr('');
    npr('2.  Players choose colours to play as.  Red plays first. ');
    npr('');

    npr(' ----- Press return for the next page -----');
    readline() -> dummy;
    npr('');

    npr('3.  Players take it in turns to move.  A legal move consists of the player');
    npr('placing a chip next to his opponents chip.  Moves are performed in lines,');
    npr('either horizontal, vertical or diagonal starting from the chip the player');
    npr('has placed.  There must be a corresponding players chip in the line for');
    npr('the move to be legal.  For example, these moves are legal for X (blue) : ');
    npr('');
    npr('   |   |   |       X |   |   |   |   ');
    npr('---+---+---+---   ---+---+---+---+---');
    npr('   | X |   |         | O | O |   |   ');
    npr('---+---+---+---   ---+---+---+---+---');
    npr('   | O | X |         |   | O |   |   ');
    npr('---+---+---+---   ---+---+---+---+---');
    npr('   | X | O |         |   |   | O |   ');
    npr('---+---+---+---   ---+---+---+---+---');
    npr('   |   |   |         |   |   |   | X ');
    npr('');
    npr('4.  When a legal move is played all of the chips in the line are flipped');
    npr('so that they are now the same colour as the players chip.');
    npr('');
    npr('5.  If this causes any of the opponents chips to lie in a line, either');
    npr('horizontally, vertically or diagonally, between two of the players chips');
    npr('then these chips are also flipped.');
    npr('');

    npr(' ----- Press return for the next page -----');
    readline () -> dummy;
    npr('');

    npr('6.  If the player cannot perform a legal move in his turn then they must');
    npr('forfeit that turn.');
    npr('');
    npr('7.  The game ends when there are no legal moves left for either player.');
    npr('This may be when the board is full, or not.');

enddefine;
