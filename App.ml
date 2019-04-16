open Revery
open Revery.Math
open Revery.UI
open Revery.UI.Components
module AnimatedText =
  struct
    let component = React.component "AnimatedText"
    let createElement ~children:_  ~delay  ~textContent  () =
      component
        (fun hooks ->
           let (translate, hooks) =
             Hooks.animation (Animated.floatValue 50.)
               {
                 toValue = 0.;
                 duration = (Seconds 0.5);
                 delay = (Seconds delay);
                 repeat = false;
                 easing = Animated.linear
               } hooks in
           let ((opacityVal : float), hooks) =
             Hooks.animation (Animated.floatValue 0.)
               {
                 toValue = 1.0;
                 duration = (Seconds 1.);
                 delay = (Seconds delay);
                 repeat = false;
                 easing = Animated.linear
               } hooks in
           let textHeaderStyle =
             let open Style in
               [color Colors.white;
               fontFamily "Roboto-Regular.ttf";
               fontSize 24;
               marginHorizontal 8;
               opacity opacityVal;
               transform [Transform.TranslateY translate]] in
           (hooks,
             (Text.createElement ~style:textHeaderStyle ~text:textContent
                ~children:[] ())))
  end
module SimpleButton =
  struct
    let component = React.component "SimpleButton"
    let createElement ~children:_  () =
      component
        (fun hooks ->
           let (count, setCount, hooks) = React.Hooks.state 0 hooks in
           let increment () = setCount (count + 1) in
           let wrapperStyle =
             let open Style in
               [backgroundColor (Color.rgba 1. 1. 1. 0.1);
               border ~width:2 ~color:Colors.white;
               margin 16] in
           let textHeaderStyle =
             let open Style in
               [color Colors.white;
               fontFamily "Roboto-Regular.ttf";
               fontSize 20;
               margin 4] in
           let textContent = "Click me: " ^ (string_of_int count) in
           (hooks,
             (Clickable.createElement ~onClick:increment
                ~children:[View.createElement ~style:wrapperStyle
                             ~children:[Text.createElement
                                          ~style:textHeaderStyle
                                          ~text:textContent ~children:[] ()]
                             ()] ())))
  end
let init app =
  let win = App.createWindow app "Welcome to Revery!" in
  let containerStyle =
    let open Style in
      [position `Absolute;
      justifyContent `Center;
      alignItems `Center;
      bottom 0;
      top 0;
      left 0;
      right 0] in
  let innerStyle =
    let open Style in [flexDirection `Row; alignItems `FlexEnd] in
  let render () =
    View.createElement ~style:containerStyle
      ~children:[View.createElement ~style:innerStyle
                   ~children:[AnimatedText.createElement ~delay:0.0
                                ~textContent:"Welcome" ~children:[] ();
                             AnimatedText.createElement ~delay:0.5
                               ~textContent:"to" ~children:[] ();
                             AnimatedText.createElement ~delay:1.
                               ~textContent:"Revery" ~children:[] ()] ();
                SimpleButton.createElement ~children:[] ()] () in
  UI.start win render
;;App.start init
