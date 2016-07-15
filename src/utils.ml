open Array

let max =
    let rec lm_aux l m i j =
        match l with
            | h::t -> if   h > m 
                      then lm_aux t h (i + 1) i
                      else lm_aux t m (i + 1) j 
            | _    -> j
    in
    (fun x -> let l = x 
              in
              lm_aux l min_float 0 0)

let normal n i =
    let a = make n 0.
    in
    a.(i) <- 1.;
    to_list a
