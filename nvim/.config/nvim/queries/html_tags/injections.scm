;; extends

; <template lang="twig"> treated as TWIG.
(element
  (start_tag
    (tag_name) @_tag (#eq? @_tag "template")
    (attribute
      (attribute_name) @_aname (#eq? @_aname "lang")
      (quoted_attribute_value
        (attribute_value) @_aval (#eq? @_aval "twig"))
    )
  )
  (text) @injection.content (#set! injection.language "twig"))

; ALPINEJS
(attribute
  (attribute_name) @_name
    (#match? @_name "^x-")
    (#not-match? @_name "^x-transition")
  (quoted_attribute_value
    (attribute_value) @injection.content (#set! injection.language "javascript")))

; VueJS
(attribute
  (attribute_name) @_name
    (#match? @_name "^v-")
  (quoted_attribute_value
    (attribute_value) @injection.content (#set! injection.language "javascript")))

; @ is an event listener in most front-end templating languages
(attribute
  (attribute_name) @_name (#lua-match? @_name "^@")
  (quoted_attribute_value
    (attribute_value) @injection.content (#set! injection.language "javascript")))

; : is a bind in most front-end templating languages
(attribute
  (attribute_name) @_name (#lua-match? @_name "^:")
  (quoted_attribute_value
    (attribute_value) @injection.content (#set! injection.language "javascript")))

; HTMX
(attribute
  (attribute_name) @_name
    (#match? @_name "^hx-on")
  (quoted_attribute_value
    (attribute_value) @injection.content (#set! injection.language "javascript")))
