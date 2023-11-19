open Lwt.Syntax

(* GET: /users *)
let get_users_request pool _request =
  let get_users =
    [%rapper
      get_many
        {sql| SELECT @int{id}, @string{bride_first_name}, @string{bride_last_name}, @string{groom_first_name}, @string{groom_last_name} FROM users |sql}]
  in
  let* users_result = Caqti_lwt.Pool.use (get_users ()) pool in
  match users_result with
  | Error e -> failwith (Caqti_error.show e)
  | Ok users ->
      let json =
        `List
          (List.map
             (fun ( id,
                    bride_first_name,
                    bride_last_name,
                    groom_first_name,
                    groom_last_name ) ->
               `Assoc
                 [
                   ("id", `Int id);
                   ("bride_first_name", `String bride_first_name);
                   ("bride_last_name", `String bride_last_name);
                   ("groom_first_name", `String groom_first_name);
                   ("groom_last_name", `String groom_last_name);
                 ])
             users)
      in
      Dream.json (Yojson.Safe.to_string json)

(* POST: /users *)
let post_users_request pool request =
  let* body = Dream.body request in
  let data = Yojson.Safe.from_string body in
  let open Yojson.Safe.Util in
  let bride_first_name = data |> member "bride_first_name" |> to_string in
  let bride_last_name = data |> member "bride_last_name" |> to_string in
  let groom_first_name = data |> member "groom_first_name" |> to_string in
  let groom_last_name = data |> member "groom_last_name" |> to_string in

  (* Define the function to insert a user *)
  let insert_user =
    [%rapper
      execute
        {sql|
           INSERT INTO users (bride_first_name, bride_last_name, groom_first_name, groom_last_name)
           VALUES (%string{bride_first_name}, %string{bride_last_name}, %string{groom_first_name}, %string{groom_last_name})
        |sql}]
  in

  let* result =
    Caqti_lwt.Pool.use
      (fun db ->
        insert_user ~bride_first_name ~bride_last_name ~groom_first_name
          ~groom_last_name db)
      pool
  in

  match result with
  | Ok () -> Dream.json ~status:`Created ""
  | Error e -> Dream.json ~status:`Internal_Server_Error (Caqti_error.show e)

let cors_middleware inner_handler req =
  let new_headers =
    [
      ("Allow", "OPTIONS, GET, HEAD, POST");
      ("Access-Control-Allow-Origin", "http://localhost:5173");
      ("Access-Control-Allow-Headers", "*");
      ("Access-Control-Allow-Methods", "OPTIONS, GET, HEAD, POST");
    ]
  in
  let+ response = inner_handler req in

  new_headers
  |> List.map (fun (key, value) -> Dream.add_header response key value)
  |> ignore;

  response

let users_routes pool =
  [
    Dream.options "/users" (fun req ->
        cors_middleware (fun _ -> Dream.empty `OK) req);
    Dream.get "/users" (get_users_request pool);
    Dream.post "/users" (post_users_request pool);
  ]
