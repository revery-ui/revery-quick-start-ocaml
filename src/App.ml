open Revery
open Revery.UI
open Revery.UI.Components

module Styles =
  struct
    open Style
    let text = [marginTop 24; color (Color.hex Theme.darkBlue)]
  end

let%component main () =
    let%hook (count, setCount) = React.Hooks.state 0 in
    let increment () = setCount(fun count -> count + 1) in

    ((Center.createElement
        ~children:[((Padding.createElement ~padding:24
                        ~children:[
                          (
                            (Row.createElement
                              ~children:[
                                ((AnimatedText.createElement
                                  ~delay: (Time.ms 0)
                                  ~text:"Welcome"
                                  ~children:[] ())
                                  [@JSX ]);
                                  ((AnimatedText.createElement
                                    ~delay: (Time.ms 500)
                                    ~text:"to" ~children:[]
                                    ())
                                  [@JSX ]);
                                  ((AnimatedText.createElement
                                      ~delay: (Time.ms 1000)
                                      ~text:"Revery"
                                      ~children:[] ())
                              [@JSX ])] ())
                            [@JSX ]
                          )
                      ] ())
                    [@JSX ]);
                    (SimpleButton.createElement ~text:"Increment" ~onClick:increment ~children:[] () [@JSX ]);
                    (Text.createElement
                      ~fontSize:16.
                      ~style:Styles.text
                      ~text:("Times clicked: " ^ string_of_int(count))
                      ~children:[]
                      ()
                    [@JSX ])
                  ] ())
      [@JSX ])

let init app =
  Revery.App.initConsole ();

  let consoleReporter = Timber.Reporter.console ~enableColors:true () in

  Timber.App.enable(consoleReporter);
  Timber.App.setLevel(Timber.Level.perf);

  (let win =
     App.createWindow app "Hello Revery!"
       ~createOptions:(WindowCreateOptions.create
                         ~backgroundColor:(Color.hex Theme.lightBlue)
                         ~width:512 ~height:384 ()) in
   let _update =
     (UI.start win ((main ~children:[] ())[@JSX ]) : Revery.UI.renderFunction) in
   ())
;;App.start init