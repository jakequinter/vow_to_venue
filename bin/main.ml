let elt_to_string elt = Fmt.str "%a" (Tyxml.Html.pp_elt ()) elt

let index_body _ =
  let open Tyxml in
  Html.(div [ h1 [ txt "Vow to Venue" ] ])
;;

let index _request =
  let open Tyxml.Html in
  let page =
    html (head (title (txt "Vow to Venue")) []) (body [ index_body () ])
  in
  Dream.html (elt_to_string page)
;;

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router
       [ Dream.get "/" (fun _ -> index ())
       ; Dream.post "/echo/:word" (fun request ->
           Dream.html (Dream.param request "word"))
       ]
;;
