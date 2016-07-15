open Types

let linear =
    {
        f  = (fun x -> x);
        f' = (fun x -> 1.)
    }

let tanh = 
    {
        f  = (fun x -> tanh x);
        f' = (fun x -> 1. -. (tanh x) ** 2.)
    }

let softsign = 
    {
        f  = (fun x -> 1. /. (1. +. abs_float x));
        f' = (fun x -> 1. /. ((1. +. abs_float x ) ** 2.))
    }

let relu =
    {
        f  = (fun x -> if x < 0. then 0. else x);
        f' = (fun x -> if x < 0. then 0. else 1.)
    }

let softplus =
    {
        f  = (fun x -> log (1. +. (exp x))); 
        f' = (fun x -> 1. /. (1. +. exp (-1. *. x)))
    }

let softstep =
    {
        f  = (fun x -> 1. /. (1. +. (exp (-1. *. x))));
        f' = let g x = 1. /. (1. +. (exp (-1. *. x))) 
             in
             (fun x -> (g x) *. (1. -. (g x)))
    }
