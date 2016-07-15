open Types
open Math.Compute
open Math.Misc
open List

let quadratic =
    {
        f      = (fun x y -> 0.5 *. two_norm (x <<->> y));
        grad_f = (fun x y -> x <<->> y)
    }

let kullback_leibler =
    {
        f      = (fun x y -> let f = (fun a e1 e2 -> a +. e2 *. log (e2 /. e1))
                             in
                             fold_left2 f 0. x y);
        grad_f = (fun x y -> map2 (fun e1 e2 -> e2 /. e1) x y)
    }
