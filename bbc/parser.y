/*  Bare Bones Parser
    File : parser.y
*/


%{
#include <stdbool.h> //thu vien dung cho kieu du lieu bool
#include <stdint.h> //thu vien dung cho kieu so nguyen khac nhau

#include "barebones.h"

%}
//khai bao cau truc cho ngon ngu
//trong ngon ngu ta se su dung 4 kieu chinh gom co kieu so nguyen (integer), kieu ky tu (char), kieu do ngon ngu ngam dinh (var), va statement
%union {
  int integer; //so nguyen
  char *string;//chuoi
  var_t *var;//kieu ngam dinh
  stmt_t *stmt; //statement
}

%token CLEAR COPY DECR DO END INCR INIT NOT TO WHILE //cac cau lenh duoc su dung trong ngon ngu lap trinh barebones

%token <string> IDENT
%token <integer> INTEGER
//kieu cua ky hieu chua ket thuc 
%type <var> var
%type <stmt> stmt clear_stmt incr_stmt decr_stmt while_stmt copy_stmt 
%type <stmt> stmt_list
%%
//$$: gia tri cua ky hieu chua ket thuc ben ve trai
//$i: i=1,2,4,6,7: gia tri cua ky hieu thu i ben ve phai

program:	stmt_list { main_prog = $1; }
		| init_list stmt_list { main_prog = $2; };

init_list:	init
		| init_list init;

init:		INIT var '=' INTEGER ';' //dinh nghia khai bao bien cho ngon ngu init <ten bien> = <gia tri> ket thuc bang dau ;
		{
		  set_var($2, $4); //set_var('name'=$2,'value'=$4) 
		};

stmt_list:	stmt { $$ = $1; }
		| stmt_list stmt
			{
			  add_stmt_to_list($1, $2);
			  $$ = $1;
			};

stmt:		clear_stmt | incr_stmt | decr_stmt | while_stmt | copy_stmt; //cac statement xoa, tang, giam, lap, sao chep

var:		IDENT
		{
		  $$ = find_var($1);
		};

clear_stmt:	CLEAR var ';' //cu phap lenh clear: clear <ten bien> ;
		{
		  $$ = new_stmt(CLEAR_STMT, $2); //xoa gia tri cua $2
		};

incr_stmt:	INCR var ';' //lenh incr: incr <gia tri> ;
		{
		  $$ = new_stmt(INCR_STMT, $2); //tang $2 len 1 don vi
		};

decr_stmt:	DECR var ';'  //lenh decr: decr <gia tri> ;
		{
		  $$ = new_stmt(DECR_STMT, $2); //giam $2 len 1 don vi
		};

while_stmt:	WHILE var NOT INTEGER DO ';' stmt_list END ';' //vong lap while: cu phap cua vong lap while la: while <ten bien> not <gia tri> do va ket thuc vong lap while la END
		{
		  if ($4 != 0)
		    error_report("literal in while statement must be zero");
		  $$ = new_stmt(WHILE_STMT, $2);
		  $$->stmt_list = $7;
		};

copy_stmt:	COPY var TO var ';'
		{
		  $$ = new_stmt(COPY_STMT, $2);
		  $$->dest = $4;
		};