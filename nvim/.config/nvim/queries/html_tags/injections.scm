;; extends

; <template lang="twig"> treated as TWIG.
; TODO: doesn't work anymore for some reason (stack overflow).
; (element
;   (start_tag
;     (tag_name) @_tag (#eq? @_tag "template")
;     (attribute
;       (attribute_name) @_aname (#eq? @_aname "lang")
;       (quoted_attribute_value
;         (attribute_value) @_aval (#eq? @_aval "twig"))
;     )
;   )
; ) @twig

; ALPINEJS
(attribute
  (attribute_name) @_name
    (#match? @_name "^x-")
    (#not-match? @_name "^x-transition")
  (quoted_attribute_value
    (attribute_value) @javascript))

; @ is an event listener in most front-end templating languages
(attribute
  (attribute_name) @_name (#lua-match? @_name "^@")
  (quoted_attribute_value
    (attribute_value) @javascript))

; : is a bind in most front-end templating languages
(attribute
  (attribute_name) @_name (#lua-match? @_name "^:")
  (quoted_attribute_value
    (attribute_value) @javascript))


