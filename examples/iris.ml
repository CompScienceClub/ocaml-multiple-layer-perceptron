open Types
open Activation
open Cost
open Layer
open Network
open Utils
open Printf

let network = 
    {
        eta    = 0.25;
        cost   = quadratic;
        layers = [randomize 4 3 tanh;
                  randomize 3 3 relu]
    }

let input_map x =
    match x with
        | "Iris-setosa"     -> normal 3 0
        | "Iris-versicolor" -> normal 3 1
        | "Iris-virginica"  -> normal 3 2
        | _ -> failwith "Bad data"

let output_map x =
    match max x with
        | 0 -> "Iris-setosa"
        | 1 -> "Iris-versicolor"
        | 2 -> "Iris-virginica"
        | _ -> failwith "Bad data"

let start   = Time.start
let network = Train.csv_file network input_map 50 "data/iris/train.csv"
let elapsed = Time.stop start
let success = Test.csv_file network output_map "data/iris/test.csv"

let () = 
    printf "\nTIME TO TRAIN: %.3f seconds\n" elapsed;
    printf "\nTEST SUCCESS RATE: %.3f\n\n" success
