[@react.component]
let make = () => {
  let (brideFirstName, setBrideFirstName) = React.useState(_ => "");
  let (brideLastName, setBrideLastName) = React.useState(_ => "");
  let (groomFirstName, setGroomFirstName) = React.useState(_ => "");
  let (groomLastName, setGroomLastName) = React.useState(_ => "");

let createUser = event => {
  ReactEvent.Form.preventDefault(event);

  let payload = Js.Dict.empty();
  Js.Dict.set(payload, "bride_first_name", Js.Json.string(brideFirstName));
  Js.Dict.set(payload, "bride_last_name", Js.Json.string(brideLastName));
  Js.Dict.set(payload, "groom_first_name", Js.Json.string(groomFirstName));
  Js.Dict.set(payload, "groom_last_name", Js.Json.string(groomLastName));

  Js.Promise.(
    Fetch.fetchWithInit("http://localhost:8080/users", 
      Fetch.RequestInit.make(
        ~method_=Post,
        ~body=Fetch.BodyInit.make(Js.Json.stringify(Js.Json.object_(payload))),
        ~headers=Fetch.HeadersInit.make({"Content-Type": "application/json"}),
        (),
      ),
    )
    |> then_(_ => {
      Js.Console.log("User created");
      Js.Promise.resolve();
    })
    |> catch(err => {
      Js.Console.error("Error creating user");
      Js.Console.error(err);
      Js.Promise.resolve();
    })
  )
  |> ignore;
};


  <form
    onSubmit={createUser}
    className="flex items-center justify-center flex-col space-y-4 mt-20"> 
    <div>
      <label htmlFor="brideFirstName" className="block text-sm font-medium leading-6 text-gray-900">
        {React.string("Bride first name")}
      </label>
      <div className="mt-2">
        <input 
          id="brideFirstName" 
          value={brideFirstName}
          className="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
          onChange={event =>{
            let newVal = ReactEvent.Form.target(event)##value;
            setBrideFirstName(_ => newVal)
          }}
        />
      </div>
    </div>

    <div>
      <label htmlFor="brideFirstName" className="block text-sm font-medium leading-6 text-gray-900">
        {React.string("Bride last name")}
      </label>
      <div className="mt-2">
        <input 
          id="brideLastName" 
          value={brideLastName}
          className="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
          onChange={event =>{
            let newVal = ReactEvent.Form.target(event)##value;
            setBrideLastName(_ => newVal)
          }}
        />
      </div>
    </div>

    <div>
      <label htmlFor="groomFirstName" className="block text-sm font-medium leading-6 text-gray-900">
        {React.string("groom first name")}
      </label>
      <div className="mt-2">
        <input 
          id="groomFirstName" 
          value={groomFirstName}
          className="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
          onChange={event =>{
            let newVal = ReactEvent.Form.target(event)##value;
            setGroomFirstName(_ => newVal)
          }}
        />
      </div>
    </div>

    <div>
      <label htmlFor="groomLastName" className="block text-sm font-medium leading-6 text-gray-900">
        {React.string("Groom last name")}
      </label>
      <div className="mt-2">
        <input 
          id="groomLastName" 
          value={groomLastName}
          className="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
          onChange={event =>{
            let newVal = ReactEvent.Form.target(event)##value;
            setGroomLastName(_ => newVal)
          }}
        />
      </div>
    </div>

    <button
      type_="submit"
      className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none">
      {React.string("Create")}
    </button>
  </form>;
};
