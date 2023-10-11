(lang dune 3.11)

(name vow_to_venue)

(generate_opam_files true)

(source
 (github jakequinter/vow_to_venue))

(authors "Jake Quinter")

(maintainers "Jake Quinter")

(license MIT)

(documentation https://url/to/documentation)

(package
 (name vow_to_venue)
 (synopsis "Let's build our own theknot.com")
 (description "vow_to_venue is a web application that allows users recieve and review RSVPs for their wedding")
 (depends
   (ocaml (>= "5.1.0"))
   (dune (>= "3.11.0"))
   dream
   )
 (tags
  (topics "to describe" your project)))
; 
