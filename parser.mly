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
|			ITERATE INT TIMES stmt
				{ (print_string "ITERATE ") }
|			WHILE test DO stmt
				{ (print_string "WHILE ") }
|			IF test THEN stmt
				{ (print_string "IF ") }
|			IF test THEN stmt_special ELSE stmt
				{ (print_string "IF ELSE ") }
;


stmt_special: simple_stmt
				{ () }
|			ITERATE INT TIMES stmt_special
				{ (print_string "ITERATE ") }
|			WHILE test DO stmt_special
				{ (print_string "WHILE ") }
|			IF test THEN stmt_special ELSE stmt_special
				{ (print_string "IF ELSE SPECIAL") }
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
|			ID
				{ ( if is_defined $1
						 then ()
						 else raise (SyntaxError "Ce sous prog n'existe pas ")
						 ) }
;

test: 	FRONT_IS_CLEAR
					{ let b = new_temp() in gen (INVOKE (is_clear,	1,	b)) ; b }
| 			FRONT_IS_BLOCKED
					{ let b = new_temp() in gen (INVOKE (is_blocked,	1,	0)) ; b }
| 			LEFT_IS_CLEAR
					{ let b = new_temp() in gen (INVOKE (is_clear,	2,	0)) ; b }
| 			LEFT_IS_BLOCKED
					{ let b = new_temp() in gen (INVOKE (is_blocked,	2,	0)) ; b }
| 			RIGHT_IS_CLEAR
					{ let b = new_temp() in gen (INVOKE (is_clear,	3,	0)) ; b }
| 			RIGHT_IS_BLOCKED
					{ let b = new_temp() in gen (INVOKE (is_blocked,	3,	0)) ; b }
| 			NEXT_TO_A_BEEPER
					{ let a = new_temp() in gen (INVOKE (next_beeper,	0,	0)) ; a }
| 			NOT_NEXT_TO_A_BEEPER
					{ let a = new_temp() in gen (INVOKE (no_next_beeper,	0,	0)) ; a }
|				FACING_NORTH
					{ let b = new_temp() in gen (INVOKE (facing,	1,	0)) ; b }
| 			NOT_FACING_NORTH
					{ let b = new_temp() in gen (INVOKE (not_facing,	1,	0)) ; b }
| 			FACING_EAST
					{ let b = new_temp() in gen (INVOKE (facing,	2,	0)) ; b }
| 			NOT_FACING_EAST
					{ let b = new_temp() in gen (INVOKE (not_facing,	2,	0)) ; b }
| 			FACING_SOUTH
					{ let b = new_temp() in gen (INVOKE (facing,	3,	0)) ; b }
|				NOT_FACING_SOUTH
					{ let b = new_temp() in gen (INVOKE (not_facing,	3,	0)) ; b }
| 			FACING_WEST
					{ let b = new_temp() in gen (INVOKE (facing,	4,	0)) ; b }
| 			NOT_FACING_WEST
					{ let b = new_temp() in gen (INVOKE (not_facing,	4,	0)) ; b }
|				ANY_BEEPERS_IN_BEEPER_BAG
					{ let a = new_temp() in gen (INVOKE (any_beeper,	0,	0)) ; a }
| 			NO_BEEPERS_IN_BEEPER_BAG
					{ let a = new_temp() in gen (INVOKE (no_beeper,	0,	0)) ; a }
;

