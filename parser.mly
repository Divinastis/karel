%{

open Quad
open Common
open Comp
open Karel


%}

%token BEGIN_PROG
%token BEGIN_EXEC
%token END_EXEC
%token END_PROG

%token MOVE
%token TURN_LEFT
%token TURN_OFF

%token SEMI
%token BEGIN
%token END

%token PICK_BEEPER
%token PUT_BEEPER
%token NEXT_TO_A_BEEPER
%token <int> INT 

%token FRONT_IS_CLEAR
%token FRONT_IS_BLOCKED
%token LEFT_IS_CLEAR
%token LEFT_IS_BLOCKED
%token RIGHT_IS_CLEAR
%token RIGHT_IS_BLOCKED
%token NOT_NEXT_TO_A_BEEPER
%token FACING_NORTH
%token NOT_FACING_NORTH
%token FACING_EAST
%token NOT_FACING_EAST
%token FACING_SOUTH
%token NOT_FACING_SOUTH
%token FACING_WEST
%token NOT_FACING_WEST
%token ANY_BEEPERS_IN_BEEPER_BAG
%token NO_BEEPERS_IN_BEEPER_BAG

%token ITERATE
%token TIMES
%token WHILE
%token DO
%token IF
%token THEN
%token DEFINE_NEW_INSTRUCTION
%token AS 
%token <string> ID
%token ELSE

%type <unit> prog
%start prog


%left THEN
%left ELSE

%%

prog:	BEGIN_PROG liste_sous_prog BEGIN_EXEC  stmts_opt END_EXEC END_PROG
			{ () }
;

liste_sous_prog: /* empty */	{ () }
|			define_new  liste_sous_prog	{ () }
;

define_new: 
			DEFINE_NEW_INSTRUCTION ID AS stmt SEMI
				{ 
					if is_defined $2 then 
					raise (SyntaxError "Le sous prog est deja definie ")
					else 
					define $2 0
				 }
;

stmts_opt:	/* empty */		{ () }
|			stmts			{ () }
;

stmts:		stmt			{ () }
|			stmts SEMI stmt	{ () }
|			stmts SEMI		{ () }
;

stmt:		simple_stmt
				{ () }
;


simple_stmt: TURN_LEFT
				{ gen (INVOKE (turn_left, 0, 0)); print_string "turnleft " }
|			TURN_OFF
				{ gen STOP ; print_string "turnoff " }
|			MOVE
				{ gen (INVOKE (move, 0, 0)) ; print_string "move " }
|			PICK_BEEPER
				{ gen (INVOKE (pick_beeper, 0, 0)); print_string "pickbeeper " }
|			PUT_BEEPER
				{ gen (INVOKE (put_beeper, 0, 0)); print_string "putbeepper " }
|			BEGIN stmts END
				{ (print_string "BEGIN END ") }
|			ITERATE INT TIMES stmt
				{ (print_string "ITERATE ") }
|			WHILE test DO stmt
				{ (print_string "WHILE ") }
|			IF test THEN stmt
				{ (print_string "IF ") }
|			ID
				{ ( if is_defined $1
						 then ()
						 else raise (SyntaxError "Ce sous prog n'existe pas ")
						 ) }
|			IF test THEN stmt ELSE stmt
				{ (print_string "IF ELSE ") }
;

test: 	FRONT_IS_CLEAR
					{ () }
| 			FRONT_IS_BLOCKED
					{ () }
| 			LEFT_IS_CLEAR
					{ () }
| 			LEFT_IS_BLOCKED
					{ () }
| 			RIGHT_IS_CLEAR
					{ () }
| 			RIGHT_IS_BLOCKED
					{ () }
| 			NEXT_TO_A_BEEPER
					{ (print_string "next to a beeper") }
| 			NOT_NEXT_TO_A_BEEPER
					{ () }
|				FACING_NORTH
					{ () }
| 			NOT_FACING_NORTH
					{ () }
| 			FACING_EAST
					{ () }
| 			NOT_FACING_EAST
					{ () }
| 			FACING_SOUTH
					{ () }
|				NOT_FACING_SOUTH
					{ () }
| 			FACING_WEST
					{ () }
| 			NOT_FACING_WEST
					{ () }
|				ANY_BEEPERS_IN_BEEPER_BAG
					{ () }
| 			NO_BEEPERS_IN_BEEPER_BAG
					{ () }
;

