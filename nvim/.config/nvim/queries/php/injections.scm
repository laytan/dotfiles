;; extends

(heredoc
  (heredoc_start) @_start (#eq? @_start "TWIG")
  (heredoc_body) @twig)

(heredoc
  (heredoc_start) @_start (#eq? @_start "HTML")
  (heredoc_body) @html)

