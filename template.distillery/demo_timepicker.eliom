(* This file was generated by Ocsigen Start.
   Feel free to use it, modify it, and redistribute it as you wish. *)

[%%shared
[@@@ocaml.warning "-33"]
  open Eliom_content.Html
  open Eliom_content.Html.D
[@@@ocaml.warning "+33"]
]


(* Timepicker demo *)

(* Service for this demo *)
let%server service =
  Eliom_service.create
    ~path:(Eliom_service.Path ["demo-timepicker"])
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    ()

(* Make service available on the client *)
let%client service = ~%service

let%server s, f = Eliom_shared.React.S.create None

let%client action (h, m) = ~%f (Some (h, m)); Lwt.return ()

let%shared string_of_time = function
  | Some (h, m) ->
    [%i18n S.you_click_on ~y:(string_of_int h) ~m:(string_of_int m)]
  | None ->
    ""

let%server time_as_string () : string Eliom_shared.React.S.t =
  Eliom_shared.React.S.map [%shared string_of_time] s

let%server time_reactive () = Lwt.return @@ time_as_string ()

let%client time_reactive =
  ~%(Eliom_client.server_function [%derive.json: unit]
       (Os_session.connected_wrapper time_reactive))

(* Name for demo menu *)
let%shared name () = "TimePicker"

(* Class for the page containing this demo (for internal use) *)
let%shared page_class = "os-page-demo-timepicker"

(* Page for this demo *)
let%shared page () =
  let time_picker, _, back_f = Ot_time_picker.make
      ~h24:true
      ~action:[%client action]
      ()
  in
  let button = Eliom_content.Html.D.button [%i18n demo_timepicker_back_to_hours] in
  ignore
    [%client
      (Lwt.async (fun () ->
         Lwt_js_events.clicks
           (Eliom_content.Html.To_dom.of_element ~%button)
           (fun _ _ ->
              ~%back_f ();
              Lwt.return ()))
       : _)
    ];
  let%lwt tr = time_reactive () in
  Lwt.return
    [
      p [%i18n demo_timepicker_description];
      div [time_picker];
      p [Eliom_content.Html.R.pcdata tr];
      div [button]
    ]
