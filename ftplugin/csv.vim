" Just sum a row in a csv record

function CSVLineTotal(line)
    let nums = split(a:line, ",")
    return s:sum(nums)
endfunction

function s:sum(nums)
    let total = 0
    for x in a:nums
        let total += x
    endfor
    return total
endfunction

if !hasmapto('<Plug>CSV_LineTotal')
    map <buffer> <unique> <LocalLeader>s <Plug>CSV_LineTotal
    imap <buffer> <unique> <LocalLeader>s <Plug>CSV_LineTotal
endif

map <Plug>CSV_LineTotal :execute 'normal! A,' . CSVLineTotal(getline("."))<CR>
imap <Plug>CSV_LineTotal <C-O>:execute 'normal! A,' . CSVLineTotal(getline("."))<CR>
