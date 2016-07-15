open Csv
open List

let load f =
    let g = fun r -> (hd r, 
                     (map float_of_string (tl r)))
    in
    map g (load f)
