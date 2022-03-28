"Safe Guard:"
if exists("g:loaded_pythonindentfold")
    finish
endif

let g:loaded_pythonindentfold = 1

"augroup fold_python
"  autocmd!
"  autocmd FileType python
"    setlocal foldmethod=expr
"    setlocal foldexpr=GetPythonIndentFold(v:lnum)
"                  \ setlocal foldtext=VimFoldText() |
"                  \ set foldcolumn=2 foldminlines=2
"augroup END

setlocal foldmethod=expr
setlocal foldexpr=GetPythonIndentFold(v:lnum)

function! IndentLevel(lnum)
    return indent(a:lnum) / &shiftwidth
endfunction

function! NextNonBlankLine(lnum)
    let numlines = line('$')
    let current = a:lnum + 1

    while current <= numlines
        if getline(current) =~? '\v\S'
            return current
        endif

        let current += 1
    endwhile

    return -2
endfunction

function! GetPythonIndentFold(lnum)
    if getline(a:lnum) =~? '\v^\s*$'
        return '-1'
    endif

    let thisindent = IndentLevel(a:lnum)
    let nextindent = IndentLevel( NextNonBlankLine(a:lnum) )
    "let nextindent = IndentLevel( nextnonblankline(a:lnum) )

    if nextindent == thisindent
        return thisindent
    elseif nextindent < thisindent
        return thisindent
    elseif nextindent > thisindent
        return '>' . nextindent
    endif
endfunction
