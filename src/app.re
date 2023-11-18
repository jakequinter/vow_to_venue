module Home = {
  [@react.component]
  let make = () => <a href="/todos">{"View todos"->React.string}</a>;
}

type todo = {
  userId: int,
  id: int,
  title: string,
  completed: bool,
}

module Decode = {
  let todo = json =>
    Json.Decode.{
      userId:    json |> field("userId", int),
      id:        json |> field("id", int),
      title:     json |> field("title", string),
      completed: json |> field("completed", bool),
    };

  let todos = json => json |> Json.Decode.array(todo);
};

module About = {
  [@react.component]
  let make = () => {
    let (todos, setTodos) = React.useState(() => [||]);

    React.useEffect0(() => {
      let _ = Js.Promise.(
        Fetch.fetch("https://jsonplaceholder.typicode.com/todos")
        |> then_(Fetch.Response.json)
        |> then_(json => {
            let fetched = Decode.todos(json);
            setTodos(_ => fetched);
            Js.Promise.resolve();
        })
      );
      Some(() => ())
    });

    <>
      <h1>{React.string("Todos")}</h1>
      <ul>
        {
          todos
          ->Belt.Array.map(item =>
              <li key={string_of_int(item.id)}> {React.string(item.title)} </li>
            )
          ->React.array
        }
      </ul>
    </>
  }
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
     | ["todos"] => <About />
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



