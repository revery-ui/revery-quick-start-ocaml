open Revery
open Revery.UI
open Revery.UI.Components
module AnimatedText =
  struct
    module Styles =
      struct
        open Style
        let text ~yOffset  =
          [color Colors.white;
          fontFamily "Roboto-Regular.ttf";
          fontSize 24.;
          transform [((Transform.TranslateY (yOffset))[@explicit_arity ])]]
      end
    [%%component
      let make ~delay:(delay : Time.t)  ~text:(text : string)  () =
        [%hook
          let (yOffset, _state, _reset) =
            Hooks.animation
              ((((Animation.animate (Time.ms 500)) |> (Animation.delay delay))
                  |> (Animation.ease Easing.easeOut))
                 |> (Animation.tween 50. 0.)) in
          [%hook
            let (animatedOpacity, _state, _reset) =
              Hooks.animation
                ((((Animation.animate (Time.seconds 1)) |>
                     (Animation.delay delay))
                    |> (Animation.ease Easing.easeOut))
                   |> (Animation.tween 0. 1.)) in
            ((Opacity.createElement ~opacity:animatedOpacity
                ~children:[((Padding.createElement ~padding:8
                               ~children:[((Text.createElement
                                              ~style:(Styles.text ~yOffset)
                                              ~text ~children:[] ())
                                         [@JSX ])] ())
                          [@JSX ])] ())
              [@JSX ])]]]
  end
module SimpleButton =
  struct
    module Styles =
      struct
        open Style
        let button =
          [backgroundColor (Color.rgba 1. 1. 1. 0.1);
          border ~width:2 ~color:Colors.white;
          margin 16]
        let text =
          [color Colors.white; fontFamily "Roboto-Regular.ttf"; fontSize 20.]
      end
    [%%component
      let make () =
        [%hook
          let (count, setCount) = React.Hooks.state 0 in
          let increment () = setCount (fun count -> count + 1) in
          let text = "Click me: " ^ (string_of_int count) in
          ((Clickable.createElement ~onClick:increment
              ~children:[((View.createElement ~style:Styles.button
                             ~children:[((Padding.createElement ~padding:4
                                            ~children:[((Text.createElement
                                                           ~style:Styles.text
                                                           ~text ~children:[]
                                                           ())
                                                      [@JSX ])] ())
                                       [@JSX ])] ())
                        [@JSX ])] ())
            [@JSX ])]]
  end
let main () =
  let module Styles =
    struct
      open Style
      let container =
        [position `Absolute;
        justifyContent `Center;
        alignItems `Center;
        bottom 0;
        top 0;
        left 0;
        right 0]
      let inner = [flexDirection `Row; alignItems `FlexEnd]
    end in
    ((View.createElement ~style:Styles.container
        ~children:[((View.createElement ~style:Styles.inner
                       ~children:[((AnimatedText.createElement
                                      ~delay:(Time.ms 0) ~text:"Welcome"
                                      ~children:[] ())
                                 [@JSX ]);
                                 ((AnimatedText.createElement
                                     ~delay:(Time.ms 500) ~text:"to"
                                     ~children:[] ())
                                 [@JSX ]);
                                 ((AnimatedText.createElement
                                     ~delay:(Time.ms 1000) ~text:"Revery"
                                     ~children:[] ())
                                 [@JSX ])] ())
                  [@JSX ]);
                  ((SimpleButton.createElement ~children:[] ())
                  [@JSX ])] ())[@JSX ])
let init app =
  Revery.App.initConsole ();
  Timber.App.enable ();
  Timber.App.setLevel Timber.Level.perf;
  (let win = App.createWindow app "Welcome to Revery!" in
   let (_ : Revery.UI.renderFunction) =
     UI.start win ((main ~children:[] ())[@JSX ]) in
   ())
;;App.start init