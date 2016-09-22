package fr.tolc.jahia.intellij.plugin.cnd;

import com.intellij.lexer.FlexLexer;
import com.intellij.psi.tree.IElementType;
import fr.tolc.jahia.intellij.plugin.cnd.psi.CndTypes;
import com.intellij.psi.TokenType;

%%

%class CndLexer
%implements FlexLexer
%unicode
%function advance
%type IElementType
%eof{  return;
%eof}

CRLF= \n|\r|\r\n
WHITE_SPACE=[\ \t\f]
//FIRST_VALUE_CHARACTER=[^ \n\r\f\\] | "\\"{CRLF} | "\\".
//VALUE_CHARACTER=[^\n\r\f\\] | "\\"{CRLF} | "\\".
//END_OF_LINE_COMMENT=("#"|"!")[^\r\n]*
//SEPARATOR=[:=]
//KEY_CHARACTER=[^:=\ \n\r\t\f\\] | "\\ "

COMMENT="//"[^\r\n]*

NAMESPACE_CHARS=[:jletter:]+
NAMESPACE_START="<"
NAMESPACE_SEPARATOR="="{WHITE_SPACE}*"'"
NAMESPACE_URI="http"(s){0,1}":\/\/"[A-Za-z0-9.\/\-_]+
NAMESPACE_END="'"{WHITE_SPACE}*">"

NODE_TYPE_CHARS=[:jletter:][:jletterdigit:]*
NODE_TYPE_DECLARATION_START="["
NODE_TYPE_DECLARATION_SEPARATOR=":"
NODE_TYPE_DECLARATION_END="]"
NODE_TYPE_INHERITANCE_START=">"
NODE_TYPE_INHERITANCE_ANOTHER={WHITE_SPACE}*","
NODE_TYPE_INHERITANCE_MIXIN="mixin"
NODE_TYPE_INHERITANCE_ORDERABLE="orderable"
NODE_TYPE_INHERITANCE_ABSTRACT="abstract"

PROPERTY_MINUS_START="-"
PROPERTY_PLUS_START="+"
PROPERTY_NAME_CHARS=[:jletter:]([:jletterdigit:]|:)*
PROPERTY_PLUS_NAME_CHARS={PROPERTY_NAME_CHARS}|"*"
PROPERTY_TYPE_START={WHITE_SPACE}+"("
PROPERTY_TYPE_END=")"
PROPERTY_TYPE="string"(","{WHITE_SPACE}*("text"|"richtext"|"textarea"|"choicelist"("["("resourceBundle"|("country"(",flag"){0,1}))"]"){0,1})){0,1}|"long"|"double"|"boolean"|"date"|"binary"|"weakreference"(","{WHITE_SPACE}*"picker[type='"("image"|"file"|"page"|"category"|"folder"|"contentfolder")"'"(",mime='"[^\r\n]+"'"){0,1}"]"|","{WHITE_SPACE}*"category"("[autoSelectParent="("true"|"false")"]"){0,1}){0,1}
PROPERTY_DEFAULT={WHITE_SPACE}+"="{WHITE_SPACE}+
PROPERTY_DEFAULT_VALUE="'"[^\r\n]*"'"|[:digit:]+|"true"|"false"|"now()"|[:jletter:][:jletterdigit:]*
PROPERTY_PLUS_DEFAULT_VALUE={NAMESPACE_CHARS}{NODE_TYPE_DECLARATION_SEPARATOR}{NODE_TYPE_CHARS}
PROPERTY_ATTRIBUTE="mandatory"|"protected"|"primary"|"i18n"|"sortable"|"hidden"|"multiple"|"nofulltext"|"indexed="("no"|"'untokenized'")|"analyzer='keyword'"|"autocreated"|"boost="[:digit:]"."[:digit:]|"onconflict=sum"|"facetable"
PROPERTY_PLUS_ATTRIBUTE={WHITE_SPACE}+"autocreated"
PROPERTY_CONSTRAINT_START={WHITE_SPACE}+"<"{WHITE_SPACE}+
PROPERTY_CONSTRAINT=("'"[^\r\n]+"',"{WHITE_SPACE}*)*"'"[^\r\n]+"'"|([:jletterdigit:]+","{WHITE_SPACE}*)*[:jletterdigit:]+|{NAMESPACE_CHARS}{NODE_TYPE_DECLARATION_SEPARATOR}{NODE_TYPE_CHARS}

EXTEND_START="extends"{WHITE_SPACE}*"="
EXTEND_ITEM_TYPE_START="itemtype"{WHITE_SPACE}*"="
EXTEND_ITEM_TYPE_VALUE="default"|"options"|"layout"

%state NAMESPACE_BEGIN
%state NAMESPACE_NAME_DONE
%state NAMESPACE_EQUAL_DONE
%state NAMESPACE_URI_DONE
%state NAMESPACES_OVER
%state NODE_TYPE_DECLARATION_BEGIN
%state NODE_TYPE_DECLARATION_NAMESPACE_DONE
%state NODE_TYPE_DECLARATION_COLON_DONE
%state NODE_TYPE_DECLARATION_TYPE_DONE
%state NODE_TYPE_INHERITANCE
%state NODE_TYPE_INHERITANCE_BEGIN
%state NODE_TYPE_INHERITANCE_NAMESPACE_DONE
%state NODE_TYPE_INHERITANCE_COLON_DONE
%state NODE_TYPE_INHERITANCE_TYPE_DONE
%state PROPERTY_MINUS_BEGIN
%state PROPERTY_NAME_DONE
%state PROPERTY_TYPE_BEGIN
%state PROPERTY_TYPE_DONE
%state PROPERTY_ADDENDUM
%state PROPERTY_ADDENDUM_ATTR
%state PROPERTY_DEFAULT_BEGIN
%state PROPERTY_CONSTRAINT_BEGIN
%state PROPERTY_PLUS_BEGIN
%state PROPERTY_PLUS_NAME_DONE
%state PROPERTY_PLUS_TYPE_BEGIN
%state PROPERTY_PLUS_NAMESPACE_DONE
%state PROPERTY_PLUS_COLON_DONE
%state PROPERTY_PLUS_TYPE_DONE
%state PROPERTY_PLUS_ADDENDUM
%state PROPERTY_PLUS_DEFAULT_BEGIN
%state EXTEND_BEGIN
%state EXTEND_NAMESPACE_DONE
%state EXTEND_COLON_DONE
%state EXTEND_ITEM_BEGIN



%%
//Comment
<YYINITIAL> {COMMENT}               { yybegin(YYINITIAL); return CndTypes.COMMENT; }

//Namespaces "<snt = 'http://www.thomas-coquel.fr/jahia/nt/1.0'>"
<YYINITIAL> {NAMESPACE_START}                   { yybegin(NAMESPACE_BEGIN); return CndTypes.NAMESPACE_OPENING; }
<NAMESPACE_BEGIN> {NAMESPACE_CHARS}             { yybegin(NAMESPACE_NAME_DONE); return CndTypes.NAMESPACE_NAME; }
<NAMESPACE_NAME_DONE> {NAMESPACE_SEPARATOR}     { yybegin(NAMESPACE_EQUAL_DONE); return CndTypes.NAMESPACE_EQUAL; }
<NAMESPACE_EQUAL_DONE> {NAMESPACE_URI}          { yybegin(NAMESPACE_URI_DONE); return CndTypes.NAMESPACE_URI; }
<NAMESPACE_URI_DONE> {NAMESPACE_END}            { yybegin(YYINITIAL); return CndTypes.NAMESPACE_CLOSING; }


//Node type declaration "[snt:test]"
<YYINITIAL> {NODE_TYPE_DECLARATION_START}                                   { yybegin(NODE_TYPE_DECLARATION_BEGIN); return CndTypes.NODE_TYPE_DECLARATION_OPENING; }
<NODE_TYPE_DECLARATION_BEGIN> {NAMESPACE_CHARS}                             { yybegin(NODE_TYPE_DECLARATION_NAMESPACE_DONE); return CndTypes.NODE_TYPE_NAMESPACE; }
<NODE_TYPE_DECLARATION_NAMESPACE_DONE> {NODE_TYPE_DECLARATION_SEPARATOR}    { yybegin(NODE_TYPE_DECLARATION_COLON_DONE); return CndTypes.NODE_TYPE_DECLARATION_COLON; }
<NODE_TYPE_DECLARATION_COLON_DONE> {NODE_TYPE_CHARS}                        { yybegin(NODE_TYPE_DECLARATION_TYPE_DONE); return CndTypes.NODE_TYPE_NAME; }
<NODE_TYPE_DECLARATION_TYPE_DONE> {NODE_TYPE_DECLARATION_END}               { yybegin(NODE_TYPE_INHERITANCE); return CndTypes.NODE_TYPE_DECLARATION_CLOSING; }

//Node type inheritence "> jnt:content, smix:lmcuComponent"
<NODE_TYPE_INHERITANCE> {NODE_TYPE_INHERITANCE_START}                       { yybegin(NODE_TYPE_INHERITANCE_BEGIN); return CndTypes.NODE_TYPE_INHERITANCE_OPENING; }
<NODE_TYPE_INHERITANCE_BEGIN> {NAMESPACE_CHARS}                             { yybegin(NODE_TYPE_INHERITANCE_NAMESPACE_DONE); return CndTypes.NODE_TYPE_INHERITANCE_NAMESPACE; }
<NODE_TYPE_INHERITANCE_NAMESPACE_DONE> {NODE_TYPE_DECLARATION_SEPARATOR}    { yybegin(NODE_TYPE_INHERITANCE_COLON_DONE); return CndTypes.NODE_TYPE_INHERITANCE_COLON; }
<NODE_TYPE_INHERITANCE_COLON_DONE> {NODE_TYPE_CHARS}                        { yybegin(NODE_TYPE_INHERITANCE_TYPE_DONE); return CndTypes.NODE_TYPE_INHERITANCE_TYPE_NAME; }
<NODE_TYPE_INHERITANCE_TYPE_DONE> {NODE_TYPE_INHERITANCE_ANOTHER}           { yybegin(NODE_TYPE_INHERITANCE_BEGIN); return CndTypes.NODE_TYPE_INHERITANCE_TYPE_COMMA; }
<NODE_TYPE_INHERITANCE_TYPE_DONE> .                                         { yybegin(NODE_TYPE_INHERITANCE); }

//Node type inheritance "mixin", "orderable" or "abstract" at the end of line
<NODE_TYPE_INHERITANCE> {NODE_TYPE_INHERITANCE_MIXIN}                       { yybegin(NODE_TYPE_INHERITANCE); return CndTypes.NODE_TYPE_MIXIN; }
<NODE_TYPE_INHERITANCE> {NODE_TYPE_INHERITANCE_ORDERABLE}                   { yybegin(NODE_TYPE_INHERITANCE); return CndTypes.NODE_TYPE_ORDERABLE; }
<NODE_TYPE_INHERITANCE> {NODE_TYPE_INHERITANCE_ABSTRACT}                    { yybegin(NODE_TYPE_INHERITANCE); return CndTypes.NODE_TYPE_ABSTRACT; }



//Node type properties
<YYINITIAL> {PROPERTY_MINUS_START}                         { yybegin(PROPERTY_MINUS_BEGIN); return CndTypes.PROPERTY_MINUS_OPENING; }
<PROPERTY_MINUS_BEGIN> {PROPERTY_NAME_CHARS}               { yybegin(PROPERTY_NAME_DONE); return CndTypes.PROPERTY_NAME; }
<PROPERTY_NAME_DONE> {PROPERTY_TYPE_START}                 { yybegin(PROPERTY_TYPE_BEGIN); return CndTypes.PROPERTY_TYPE_OPENING; }
<PROPERTY_TYPE_BEGIN> {PROPERTY_TYPE}                      { yybegin(PROPERTY_TYPE_DONE); return CndTypes.PROPERTY_TYPE; }
<PROPERTY_TYPE_DONE> {PROPERTY_TYPE_END}                   { yybegin(PROPERTY_ADDENDUM); return CndTypes.PROPERTY_TYPE_CLOSING; }
<PROPERTY_ADDENDUM> {PROPERTY_DEFAULT}                     { yybegin(PROPERTY_DEFAULT_BEGIN); return CndTypes.PROPERTY_DEFAULT_OPENING; }
<PROPERTY_DEFAULT_BEGIN> {PROPERTY_DEFAULT_VALUE}          { yybegin(PROPERTY_ADDENDUM); return CndTypes.PROPERTY_DEFAULT_VALUE; }
<PROPERTY_ADDENDUM> {PROPERTY_ATTRIBUTE}                   { yybegin(PROPERTY_ADDENDUM); return CndTypes.PROPERTY_ATTRIBUTE; }
<PROPERTY_ADDENDUM> {PROPERTY_CONSTRAINT_START}            { yybegin(PROPERTY_CONSTRAINT_BEGIN); return CndTypes.PROPERTY_CONSTRAINT_OPENING; }
<PROPERTY_CONSTRAINT_BEGIN> {PROPERTY_CONSTRAINT}          { yybegin(YYINITIAL); return CndTypes.PROPERTY_CONSTRAINT; }

<YYINITIAL> {PROPERTY_PLUS_START}                                   { yybegin(PROPERTY_PLUS_BEGIN); return CndTypes.PROPERTY_PLUS_OPENING; }
<PROPERTY_PLUS_BEGIN> {PROPERTY_PLUS_NAME_CHARS}                    { yybegin(PROPERTY_PLUS_NAME_DONE); return CndTypes.PROPERTY_PLUS_NAME; }
<PROPERTY_PLUS_NAME_DONE> {PROPERTY_TYPE_START}                     { yybegin(PROPERTY_PLUS_TYPE_BEGIN); return CndTypes.PROPERTY_TYPE_OPENING; }
<PROPERTY_PLUS_TYPE_BEGIN> {NAMESPACE_CHARS}                        { yybegin(PROPERTY_PLUS_NAMESPACE_DONE); return CndTypes.NODE_TYPE_NAMESPACE; }
<PROPERTY_PLUS_NAMESPACE_DONE> {NODE_TYPE_DECLARATION_SEPARATOR}    { yybegin(PROPERTY_PLUS_COLON_DONE); return CndTypes.NODE_TYPE_DECLARATION_COLON; }
<PROPERTY_PLUS_COLON_DONE> {NODE_TYPE_CHARS}                        { yybegin(PROPERTY_PLUS_TYPE_DONE); return CndTypes.NODE_TYPE_NAME; }
<PROPERTY_PLUS_TYPE_DONE> {PROPERTY_TYPE_END}                       { yybegin(PROPERTY_PLUS_ADDENDUM); return CndTypes.PROPERTY_TYPE_CLOSING; }
<PROPERTY_PLUS_ADDENDUM> {PROPERTY_DEFAULT}                         { yybegin(PROPERTY_PLUS_DEFAULT_BEGIN); return CndTypes.PROPERTY_DEFAULT_OPENING; }
<PROPERTY_PLUS_DEFAULT_BEGIN> {PROPERTY_PLUS_DEFAULT_VALUE}         { yybegin(PROPERTY_PLUS_ADDENDUM); return CndTypes.PROPERTY_DEFAULT_VALUE; }
<PROPERTY_PLUS_ADDENDUM> {PROPERTY_PLUS_ATTRIBUTE}                  { yybegin(PROPERTY_PLUS_ADDENDUM); return CndTypes.PROPERTY_PLUS_ATTRIBUTE; }


//Node type extends
<YYINITIAL> {EXTEND_START}                                      { yybegin(EXTEND_BEGIN); return CndTypes.EXTEND_OPENING; }
<EXTEND_BEGIN> {NAMESPACE_CHARS}                                { yybegin(EXTEND_NAMESPACE_DONE); return CndTypes.NODE_TYPE_NAMESPACE; }
<EXTEND_NAMESPACE_DONE> {NODE_TYPE_DECLARATION_SEPARATOR}       { yybegin(EXTEND_COLON_DONE); return CndTypes.NODE_TYPE_DECLARATION_COLON; }
<EXTEND_COLON_DONE> {NODE_TYPE_CHARS}                           { yybegin(YYINITIAL); return CndTypes.NODE_TYPE_NAME; }
<YYINITIAL> {EXTEND_ITEM_TYPE_START}                            { yybegin(EXTEND_ITEM_BEGIN); return CndTypes.EXTEND_ITEM_START; }
<EXTEND_ITEM_BEGIN> {EXTEND_ITEM_TYPE_VALUE}                    { yybegin(YYINITIAL); return CndTypes.EXTEND_ITEM_TYPE; }

{WHITE_SPACE}+                  { return TokenType.WHITE_SPACE; }

{CRLF}+                         { yybegin(YYINITIAL); return TokenType.WHITE_SPACE; }

.                               { return TokenType.BAD_CHARACTER; }
