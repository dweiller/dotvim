
"-" @comment
"/" @punctuation.delimiter

(gap) @number
((piece) @FENBlack (#match? @FENBlack "[pnbrkq]"))
((piece) @FENWhite (#match? @FENWhite "[PNBRKQ]"))

(active) @FENActive
(castling) @FENCastling
(en_passant) @FENEnPassant
(halfmove_clock) @number
(fullmove) @number

(comment) @comment
