(* This file was generated by Ocsigen Start.
   Feel free to use it, modify it, and redistribute it as you wish. *)

(** carousel demo ************************************************************)

[%%shared
  open Eliom_content.Html
  open Eliom_content.Html.D
]

let%server service =
  Eliom_service.create
    ~path:(Eliom_service.Path ["demo-carousel"])
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    ()

let%client service = ~%service

let%shared name = "Carousel"

let%shared page () =
  let make_page name =
    div ~a:[a_class ["demo-carousel1-page" ;
                     "demo-carousel1-page-"^name]] [pcdata "Page " ;
                                                    pcdata name]
  in
  let carousel_change_signal = [%client (React.E.create () : 'a * 'b) ] in
  let update = [%client fst ~%carousel_change_signal] in
  let change = [%client fun a -> (snd ~%carousel_change_signal ?step:None a) ]
  in
  let carousel_pages = ["1"; "2"; "3"; "4"] in
  let length = List.length carousel_pages in
  let carousel_content = List.map make_page carousel_pages in
  let bullets_content =
    List.map (fun n -> [div [p [pcdata n]]]) carousel_pages
  in
  let carousel, pos, size, _swipe_pos =
    Ot_carousel.make ~update carousel_content
  in
  let bullets = Ot_carousel.bullets ~change ~pos ~length ~size () in
  let prev = Ot_carousel.previous ~change ~pos [] in
  let next = Ot_carousel.next ~change ~pos ~size ~length [] in
  Lwt.return
    [
      p [pcdata "The carousel displays a number of blocks side-by-side (or \
                 vertically stacked)."];
      p [pcdata "To switch to a different block, either use the buttons \
                 above or below the carousel."];
      p [pcdata "On touch screens you can also swipe the screen."];
      div ~a:[a_class ["demo-carousel1"]]
        [ div ~a:[a_class ["demo-carousel1-box"]]
            [ carousel ; prev ; next ; bullets ] ]
    ]
