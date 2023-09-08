;; extends

; Temple templates.
(member_expression
  (identifier) @_member (#eq? @_member "temple")
  (call_expression
    function: (identifier) @_function (#eq? @_function "compiled_inline")
    argument: (string (string_content) @injection.content (#set! injection.language "twig"))
  )
)
