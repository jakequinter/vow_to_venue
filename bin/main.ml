let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router
       [ Dream.get "/" (fun _ -> Dream.html "Hello, world!")
       ; Dream.post "/echo/:word" (fun request ->
           Dream.html (Dream.param request "word"))
       ]
;;
