function! health#templ#check() abort
    call health#report_start('Configuration')

    let ok = v:true
    " g:Templ_extensions {{{
    let type = type(g:Templ_extensions)
    if type != v:t_list
        if type == v:t_string
            call health#report_error('g:Templ_extensions type error', [
                \ 'g:Templ_extensions is set to ' . string(g:Templ_extensions),
                \ "edit your configuration and set\n
                \    let g:Templ_extensions = ['" . g:Templ_extensions . "']"
                \ ])
        else
            call health#report_error('g:Templ_extensions type error',
                        \ 'edit your configuration to make sure g:Templ_extensions is a list of strings')
        endif
        let ok = v:false
    else
        for item in g:Templ_extensions
            if type(item) != v:t_string
                call health#report_error('g:Templ_extensions type error',
                            \ 'edit your configuration to make sure g:Templ_extensions is a list of strings')
                let ok = v:false
                break
            endif
        endfor
    endif
    " }}}

    " g:Templ_disable_on_startup
    if exists('g:Templ_disable_on_startup')
        let ok = s:check_truth('g:Templ_disable_on_startup') ? ok : v:false
    endif

    " g:Templ_Tagger
    let ok = s:check_truth('g:Templ_Tagger') ? ok : v:false

    if ok
        call health#report_ok('no issues found')
    endif
endfunction

function! s:check_truth(varname)
    let type = type(eval(a:varname))
    if type != v:t_number && type != v:t_bool && type == v:t_string
        call health#report_warn(a:varname . ' is of type string',
                    \ ['Make it 0 or 1 to be clear about its truth value'])
        return v:false
    endif
    return v:true
endfunction
