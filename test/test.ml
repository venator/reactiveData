open ReactiveData
open RList

(* create a reactive list of int *)
let all,handle = make [0;1;2;3;4;5;6;7;8;9;]

(* get the successor *)
let ints = map succ all

(* convert to string *)
let strings : string RList.t = map string_of_int ints

(* convert to javascript string *)
let js_strings1 = map Js.string strings
let js_strings2, handle2 = make [Js.string "one";Js.string "two"]
let js_strings = concat js_strings1 js_strings2
(* dom text node *)
let texts : Dom.node Js.t RList.t = map (fun s -> (Dom_html.document##createTextNode(s) :> Dom.node Js.t)) js_strings

(* dom span element *)
let spans : Dom.node Js.t RList.t = map (fun textnode ->
    let s = Dom_html.createSpan Dom_html.document in
    s##style##width <- Js.string "50px;";
    s##style##display <- Js.string "block";
    ignore(s##appendChild(textnode));
    (s :> Dom.node Js.t)
  ) texts


let _ = Dom_html.window##onload <- Dom.handler (fun _ ->

    let content = Dom_html.document##getElementById(Js.string "main") in
    let content = Js.Opt.get content (fun _ -> assert false) in
    ReactiveDomList.update_children (content :> Dom.node Js.t) spans;
    Js._true)

let _ =
    Js.Unsafe.global##cons <- (fun s -> cons s handle);
    Js.Unsafe.global##remove <- (fun s -> remove s handle);
    Js.Unsafe.global##append <- (fun s -> append s handle);
    Js.Unsafe.global##insert <- (fun s i -> insert s i handle);
    Js.Unsafe.global##swap <- (fun i j -> swap i j handle);
    Js.Unsafe.global##update <- (fun s i -> update s i handle);
    Js.Unsafe.global##cons2 <- (fun s -> cons s handle2);
    Js.Unsafe.global##remove2 <- (fun s -> remove s handle2);
    Js.Unsafe.global##append2 <- (fun s -> append s handle2);
    Js.Unsafe.global##insert2 <- (fun s i -> insert s i handle2);
    Js.Unsafe.global##swap2 <- (fun i j -> swap i j handle2);
    Js.Unsafe.global##update2 <- (fun s i -> update s i handle2);

    Js.Unsafe.global##shuffle <- (fun () ->
        let len = List.length (value all) in
        let rec shuf () =
          let i = Random.int len in
          let j = Random.int len in
          if i <> j
          then
            swap i j handle
          else shuf () in
        shuf ()
      );

    Js.Unsafe.global##shuffle2 <- (fun () ->
        let len = List.length (value js_strings2) in
        let rec shuf () =
          let i = Random.int len in
          let j = Random.int len in
          if i <> j
          then
            swap i j handle2
          else shuf () in
        shuf ()
      )



(* let rl,lh = make [5;8;10] *)
(* let sl = map string_of_int rl *)
(* let eff = map print_endline sl *)


(* let _ = fold ;; *)

(* let () = cons 50 lh *)
(* let _ = value sl;; *)
