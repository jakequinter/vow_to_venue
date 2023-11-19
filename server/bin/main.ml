open Routes.Users

let init_pool () =
  let uri = Uri.make ~scheme:"sqlite3" ~path:"../vow.db" () in
  match Caqti_lwt.connect_pool ~max_size:10 uri with
  | Ok pool -> pool
  | Error err -> failwith (Caqti_error.show err)

let pool = init_pool ()

let () =
  Dream.run @@ Dream.logger
  @@ Dream.router
       ([ Dream.get "/" (fun _ -> Dream.html "Hello, world!") ]
       @ users_routes pool)
