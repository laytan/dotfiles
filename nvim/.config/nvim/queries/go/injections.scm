;; extends

(
  (raw_string_literal) @injection.content
  (#lua-match? @injection.content "<%?php")
  (#set! injection.language "php"))
