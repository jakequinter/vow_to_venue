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

let cors_middleware inner_handler req =
  let new_headers =
    [
      ("Allow", "OPTIONS, GET, HEAD, POST");
      ("Access-Control-Allow-Origin", "http://localhost:5173");
      ("Access-Control-Allow-Headers", "*");
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
         Dream.options "/users" (fun _req ->
             Dream.respond ~headers:[ ("Allow", "OPTIONS, GET, HEAD, POST") ] "");
         Dream.get "/" (fun _ -> Dream.html "Hello, world!");
         Dream.get "/users" (fun request ->
             cors_middleware get_users_request request);
       ]
