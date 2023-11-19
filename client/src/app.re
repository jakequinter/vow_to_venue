open Pages

module Home = {
  [@react.component]
  let make = () => <a href="/get-started"> "Get started"->React.string </a>;
};


module App = {
  type route =
    | Home
    | GetStarted;

  [@react.component]
  let make = () => {
    let url = ReasonReactRouter.useUrl();

    {switch (url.path) {
     | [] => <Home />
     | ["get-started"] => <GetStarted />
     | _ => <FourOhFour />
     }}
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
