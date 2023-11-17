module App = {
  [@react.component]
  let make = () => <h1>{React.string("Hello, world!!")}</h1>;
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
