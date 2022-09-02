-- TODO: convert to lua
-- Provides completion for the Git bd command.
vim.cmd(
  [[
    fu! StartsWith(longer, shorter) abort
        if a:shorter == ''
            return 1
        endif

        return a:longer[0:len(a:shorter)-1] ==# a:shorter
    endfunction

    fu! BdComplete(arglead, cmdline, cursorpos) abort
        let b:list = systemlist('git branch')
        let b:out = []
        for b:branch in b:list
            let b:processed = trim(substitute(b:branch, '*', '', ''))
            if StartsWith(b:processed, a:arglead) && !StartsWith(b:processed, 'env') && b:processed != 'main' && b:processed != 'master'
                call add(b:out, b:processed)
            endif
        endfor

        return b:out
    endfunction

    " git bd is defined in ~/.gitconfig.
    exe 'command! -nargs=? -complete=customlist,BdComplete Gbd Git -p bd <args>'
]]
)
