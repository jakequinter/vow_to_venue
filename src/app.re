open ReasonReactRouter;

module Home = {
  [@react.component]
  let make = () => <a href="/about">{"About"->React.string}</a>;
}

module About = {

  [@react.component]
  let make = () => <h1>{React.string("Yoooo we have routing sir!")}</h1>;
}

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
     | ["about"] => <About />
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



