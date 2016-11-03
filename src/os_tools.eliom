(* Ocsigen-start
 * http://www.ocsigen.org/ocsigen-start
 *
 * Copyright (C) Université Paris Diderot, CNRS, INRIA, Be Sport.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, with linking exception;
 * either version 2.1 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *)

[%%shared
   open Eliom_content.Html
   open Eliom_content.Html.F
]


let%shared bind_popup_button
    ?a
    ~button
    ~(popup_content : ((unit -> unit Lwt.t) -> [< Html_types.div_content ]
                         Eliom_content.Html.elt Lwt.t) Eliom_client_value.t)
    ()
  =
  ignore
    [%client
      (Lwt.async (fun () ->
         Lwt_js_events.clicks
           (Eliom_content.Html.To_dom.of_element ~%button)
           (fun _ _ ->
              let%lwt _ =
                Ot_popup.popup
                  ?a:~%a
                  ~close_button:[]
                  ~%popup_content
              in
              Lwt.return ()))
       : _)
    ]
