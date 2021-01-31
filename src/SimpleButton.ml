open Revery
open Revery.UI
open Revery.UI.Components

module Constants =
    struct
        let boxShadowActiveTransparency = 0.
        let boxShadowHoverTransparency = 0.3
        let boxShadowNotHoveredTransparency = 0.15
    end

module Styles =
    struct
        open Style

        let button boxShadowTransparency = [
            backgroundColor(Color.hex(Theme.darkBlue));
            boxShadow
                ~yOffset:6.
                ~xOffset:0.
                ~blurRadius:16.
                ~color:(Color.rgba 0.  0.  0.  boxShadowTransparency) ~spreadRadius:12. ;
            paddingHorizontal(24);
            paddingVertical(12);
            borderRadius(10.)
        ]

        let buttonText = [color(Colors.white)]
    end

let%component make ~text ~onClick () =
    let%hook (boxShadowTransparency, setBoxShadowTransparency) =
        Hooks.state(Constants.boxShadowNotHoveredTransparency) in

    let%hook transitionnedBoxShadowTransparency =
        Hooks.transition
            ~name:"button box shadow transparency transition"
            ~duration:(Time.ms 150)
            boxShadowTransparency in

    let updateShadowTransparency _event ~newOpacity =
        setBoxShadowTransparency(fun _ -> newOpacity) in

    (
        View.createElement
            ~onMouseUp: (updateShadowTransparency ~newOpacity: Constants.boxShadowHoverTransparency)
            ~onMouseDown: (updateShadowTransparency ~newOpacity: Constants.boxShadowActiveTransparency)
            ~onMouseEnter: (updateShadowTransparency ~newOpacity: Constants.boxShadowHoverTransparency)
            ~onMouseLeave: (updateShadowTransparency ~newOpacity: Constants.boxShadowNotHoveredTransparency)
            ~children:[
                (Clickable.createElement
                    ~onClick:onClick
                    ~children:[
                        ( View.createElement
                            ~style:(Styles.button transitionnedBoxShadowTransparency)
                            ~children:[
                                (Text.createElement
                                    ~fontSize:16.
                                    ~style: (Styles.buttonText)
                                    ~children:[]
                                    ~text:text
                                    ()
                                    [@JSX ] )
                            ]
                            ()
                            [@JSX]
                        )
                    ]
                    ()
                [@JSX ])
            ]
            ()
        [@JSX ]
    )