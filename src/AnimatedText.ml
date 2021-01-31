open Revery
open Revery.UI

module Styles =
    struct
          open Style

        let text ~yOffset = [
            color(Color.hex(Theme.darkBlue));
            transform([Transform.TranslateY(yOffset)])
        ]
    end

  let%component make ~delay:(delay : Time.t)  ~text:(text : string)  () =

      let%hook (yOffset, _state, _reset) =
        Hooks.animation ~name:"yOffset animation"
          ( Animation.animate (Time.ms 500)
          |> Animation.delay delay
          |> Animation.ease Easing.ease
          |> Animation.tween 50. 0.) in
      let%hook (animatedOpacity, _state, _reset) =
        Hooks.animation ~name:"opacity animation"
          (Animation.animate (Time.ms 750)
          |> Animation.delay delay
          |> Animation.ease Easing.ease
          |> Animation.tween 50. 0.) in
              (
                Opacity.createElement
                  ~opacity:animatedOpacity
                  ~children: [
                (Padding.createElement
                  ~padding:6
                  ~children:[
                    (Text.createElement ~style:(Styles.text ~yOffset) ~text:text ~children:[] () [@JSX ])
                  ]
                  [@JSX ])
                  ()
                  ] () [@JSX ]
                )
