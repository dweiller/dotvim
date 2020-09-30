" Forsyth-Edwards notation syntax file
" Maintainer:   Dominic Weiller
" Version:      1
" License:      :LICENSE:
if version < 600
    syntax clear
elseif exists('b:current_syntax')
    finish
endif
syntax case match

syntax match FENError ".\+"

syntax match FENWhite "[BKNPQR]" contained
syntax match FENBlack "[bknpqr]" contained
syntax match FENBlank "[1-8]" contained
syntax match FENPieceError "[^bBkKnNpPqQrR1-8]\|[1-8]\{2,}\| " contained
syntax match FENRankSeparator "/" contained
syntax cluster FENPieces contains=FENWhite,FENBlack,FENBlank,FENPieceError,FENRankSeparator

syntax match FENRank8 "^[^/]\+" nextgroup=FENRank7 contains=@FENPieces
syntax match FENRank7 "/[^/]\+" nextgroup=FENRank6 contains=@FENPieces contained
syntax match FENRank6 "/[^/]\+" nextgroup=FENRank5 contains=@FENPieces contained
syntax match FENRank5 "/[^/]\+" nextgroup=FENRank4 contains=@FENPieces contained
syntax match FENRank4 "/[^/]\+" nextgroup=FENRank3 contains=@FENPieces contained
syntax match FENRank3 "/[^/]\+" nextgroup=FENRank2 contains=@FENPieces contained
syntax match FENRank2 "/[^/]\+" nextgroup=FENRank1 contains=@FENPieces contained
syntax match FENRank1 "/[^/ ]\+" nextgroup=FENActive contains=@FENPieces contained

syntax match FENActive " \+[wb]" nextgroup=FENCastling contains=FENSpaceError contained
syntax match FENCastling " \+[kKqQ]\+\| \+-" nextgroup=ChessSquare contains=FENSpaceError contained
syntax match ChessSquare " \+[a-h][1-8]\| \+-" nextgroup=FENHalfmove contains=FENSpaceError contained
syntax match FENHalfmove " \+\d\+" nextgroup=FENFullmove contains=FENSpaceError contained
syntax match FENFullmove " \+\d\+" contains=FENSpaceError contained

syntax match FENSpace " \+" contains=FENSpaceError contained
syntax match FENSpaceError " \zs \+" contained
syntax match FENComment "^;.*$"


highlight default link FENWhite Function
highlight default link FENBlack Character
highlight default link FENBlank Number
highlight default link FENRankSeparator Delimiter
highlight default link FENActive Todo
highlight default link FENHalfmove Number
highlight default link FENFullmove Number
highlight default link FENComment Comment
highlight default link FENPieceError FENError
highlight default link FENSpaceError FENError
highlight default link FENError Error
