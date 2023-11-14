(lang dune 3.11)

(using melange 0.1)

(using directory-targets 0.1)

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
 (allow_empty)
(depends
  (ocaml
   (>= 5.1.0))
  (dune
   (>= 3.11))
  (melange
   (>= 2.1.0))
  opam-check-npm-deps
  (reason
   (>= 3.10.0))
  (reason-react
   (>= 0.13.0))
  reason-react-ppx)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
