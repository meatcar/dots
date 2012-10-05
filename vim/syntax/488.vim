" Vim syntax file
" Language: CSC488 Project Language
" Maintainer: Petro Podrezo
" Latest Revision: 18 January 2012

if exists("b:current_syntax")
  finish
endif

" ################### Define Keywords ####################

syn keyword statementKeywords if then else while do repeat until exit when return with write read
syn keyword declarationKeywords var function function procedure procedure
syn keyword expressionKeywords not and or
syn keyword f88OutputConstants newline
syn keyword f88Types Integer Boolean
syn keyword f88BooleanConstant true false

syn case ignore
syn keyword f88todo contained fixme todo note xxx
syn case match

" ################## Define Structure #####################

syn match f88Comment "%.*$" contains=f88todo
syn region f88Scope start="{" end="}" fold transparent contains=f88Scope,statementKeywords,declarationKeywords,f88Identifier,f88StringLiteral,f88OutputConstants,f88Types,expressionKeywords,f88BooleanConstant,f88Comment,f88NumericalConstant,f88Operator

syn match f88NumericalConstant contained "\d\+"
syn match f88Operator contained "-\|+\|*\|/\|<\|>\|=\|?\|:\|(\|)"
syn match f88Identifier contained "[A-Za-z][A-Za-z0-9_]*"
syn match f88StringLiteral contained "\".\{-\}\""

" #################### Set up colors ######################

" Statements
hi def link statementKeywords Statement
hi def link declarationKeywords Statement
hi def link f88OutputConstants Statement

" Types
hi def link f88Types Type

" Operators
hi def link expressionKeywords Operator
hi def link f88Operator Operator

" Constants
hi def link f88Operator Constant
hi def link f88NumericalConstant Constant
hi def link f88BooleanConstant Constant
hi def link f88StringLiteral String

" Comments
hi def link f88Comment Comment
hi def link f88todo Todo

let b:current_syntax = "488"
