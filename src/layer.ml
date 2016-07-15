open Types
open Math.Random

let randomize l m a = 
    let size = sqrt (float_of_int l)
    in
    {
        weight     = matrix m l 0. size;
        bias       = vector m 0. size;
        activation = a
    }
