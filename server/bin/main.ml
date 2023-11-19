open Lwt.Syntax

let get_users connection =
  let users = ref [] in
  let query = "SELECT * FROM users;" in
  let cb row _ = users := Array.to_list row :: !users in
  match Sqlite3.exec_not_null ~cb connection query with
  | Sqlite3.Rc.OK -> !users
  | rc -> failwith (Sqlite3.Rc.to_string rc)

let users_to_json users =
  `List
    (List.map
       (fun user_fields ->
         `Assoc
           [
             ("id", `Int (int_of_string (List.nth user_fields 0)));
             ("name", `String (List.nth user_fields 1));
           ])
       users)

let get_users_request _request =
  let db = Sqlite3.db_open "../vow.db" in
  let users = get_users db in
  let json = users_to_json users in
  Dream.json (Yojson.Safe.to_string json)

let post_users_request request =
  let* body = Dream.body request in

  (* Convert body into a JSON object *)
  let json = Yojson.Safe.from_string body in

  (* Extract values safely using Option monad *)
  let safe_extract key =
    match Yojson.Safe.Util.(json |> member key |> to_string_option) with
    | Some value -> value
    | None ->
        let err_message = Printf.sprintf "Key %s not found in JSON" key in
        Dream.log "%s\n" err_message;
        failwith err_message (* This will terminate the function *)
  in

  (* Use safe_extract function to extract the needed values *)
  let bride_first_name = safe_extract "bride_first_name" in
  let bride_last_name = safe_extract "bride_last_name" in
  let groom_first_name = safe_extract "groom_first_name" in
  let groom_last_name = safe_extract "groom_last_name" in

  let db = Sqlite3.db_open "../vow.db" in
  let insert_query =
    Printf.sprintf
      "INSERT INTO users (bride_first_name, bride_last_name, groom_first_name, \
       groom_last_name) VALUES ('%s', '%s', '%s', '%s')"
      bride_first_name bride_last_name groom_first_name groom_last_name
  in

  match Sqlite3.exec db insert_query with
  | Sqlite3.Rc.OK ->
      Dream.log "Insert successful\n";
      Dream.json ~status:`OK
        (Yojson.Safe.to_string
           (`Assoc [ ("message", `String "Insert successful") ]))
  | rc ->
      let error_msg = Sqlite3.Rc.to_string rc in
      Dream.log "Insert failed with error %s\n" error_msg;
      Dream.json ~status:`Internal_Server_Error
        (Yojson.Safe.to_string (`Assoc [ ("message", `String error_msg) ]))

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

let () =
  Dream.run @@ Dream.logger
  @@ Dream.router
       [
         Dream.options "/users" (fun req ->
             cors_middleware (fun _ -> Dream.empty `OK) req);
         Dream.get "/" (fun _ -> Dream.html "Hello, world!");
         Dream.get "/users" (fun request ->
             cors_middleware get_users_request request);
         Dream.post "/users" (fun request ->
             cors_middleware post_users_request request);
       ]
