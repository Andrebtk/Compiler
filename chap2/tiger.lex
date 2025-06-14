%{
	#include <string.h>
	#include "util.h"
	#include "tokens.h"
	#include "errormsg.h"

	int charPos=1;

	int yywrap(void) {
		charPos=1;
		return 1;
	}


	void adjust(void) {
		EM_tokPos=charPos;
		charPos+=yyleng;
	}

%}

%%

"let" {
	adjust();
	return LET;
}

"in" {
	adjust();
	return IN;
}

"end" {
	adjust();
	return END;
}

" "	 {
	adjust();
	continue;
}

\n	 {
	adjust(); 
	EM_newline(); 
	continue;
}

","	 {
	adjust(); 
	return COMMA;
}

"=" {
	adjust();
	return EQ;
}

":=" {
	adjust();
	return ASSIGN;
}

"{" {
	adjust();
	return LBRACE;
}

"}" {
	adjust();
	return RBRACE;
}

"[" {
	adjust(); 
	return LBRACK; 
}

"]" {
	adjust(); 
	return RBRACK; 
}


for  	 {
	adjust();
	return FOR;
}

[0-9]+	 {
	adjust(); 
	yylval.ival=atoi(yytext);
	 return INT;
}

[a-zA-Z][a-zA-Z0-9_]* {
    adjust();
    if (strcmp(yytext, "let") == 0) return LET;
    else if (strcmp(yytext, "in") == 0) return IN;
    else if (strcmp(yytext, "end") == 0) return END;
    else if (strcmp(yytext, "type") == 0) return TYPE;
    else if (strcmp(yytext, "array") == 0) return ARRAY;
    else if (strcmp(yytext, "of") == 0) return OF;
    else if (strcmp(yytext, "var") == 0) return VAR;
    else if (strcmp(yytext, "int") == 0) return INT; // if int is a keyword in your parser
    else if (strcmp(yytext, "for") == 0) return FOR;
    else {
        yylval.sval = String(yytext); // ID
        return ID;
    }
}

.	 {
	adjust();
	EM_error(EM_tokPos,"illegal token");
}


