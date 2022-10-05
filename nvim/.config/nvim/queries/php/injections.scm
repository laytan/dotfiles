(heredoc
  (heredoc_start) @_start (#eq? @_start "TWIG")
  (heredoc_body) @html) ; Should be '@twig' but twig treesitter parser is not great.

(heredoc
  (heredoc_start) @_start (#eq? @_start "HTML")
  (heredoc_body) @html)
