module Home = {
  [@react.component]
  let make = () => <a href="/users"> "View users"->React.string </a>;
};

type user = {
  id: int,
  name: string,
};

module Decode = {
  let user = json =>
    Json.Decode.{
      id: json |> field("id", int),
      name: json |> field("name", string),
    };

  let users = json => json |> Json.Decode.array(user);
};

module Users = {
  [@react.component]
  let make = () => {
    let (users, setUsers) = React.useState(() => [||]);

    React.useEffect0(() => {
      let _ =
        Js.Promise.(
          Fetch.fetch("http://localhost:8080/users")
          |> then_(Fetch.Response.json)
          |> then_(json => {
               let fetched = Decode.users(json);
               setUsers(_ => fetched);
               Js.Promise.resolve();
             })
        );
      Some(() => ());
    });

    <>
      <h1> {React.string("Users fetched from local DB")} </h1>
      <ul>
        {users
         ->Belt.Array.map(user =>
             <li key={string_of_int(user.id)}>
               {React.string(user.name)}
             </li>
           )
         ->React.array}
      </ul>
    </>;
  };
};

module App = {
  type route =
    | Home
    | About;

  [@react.component]
  let make = () => {
    let url = ReasonReactRouter.useUrl();

    <div>
      {switch (url.path) {
       | [] => <Home />
       | ["users"] => <Users />
       | _ => <Home />
       }}
    </div>;
  };
};

ReactDOM.querySelector("#root")
->(
    fun
    | Some(root) => ReactDOM.render(<App />, root)
    | None =>
      Js.Console.error(
        "Failed to start React: couldn't find the #root element",
      )
  );
