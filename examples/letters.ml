open Types
open Activation
open Cost
open Layer
open Network
open Utils
open Printf

let network = 
    {
        eta    = 0.5;
        cost   = quadratic;
        layers = [randomize 16 26 tanh;
                  randomize 26 26 relu]
    }

let input_map x =
    match x with
        | "A" -> normal 26 0
        | "B" -> normal 26 1
        | "C" -> normal 26 2
        | "D" -> normal 26 3
        | "E" -> normal 26 4
        | "F" -> normal 26 5
        | "G" -> normal 26 6
        | "H" -> normal 26 7
        | "I" -> normal 26 8
        | "J" -> normal 26 9
        | "K" -> normal 26 10
        | "L" -> normal 26 11
        | "M" -> normal 26 12
        | "N" -> normal 26 13
        | "O" -> normal 26 14
        | "P" -> normal 26 15
        | "Q" -> normal 26 16
        | "R" -> normal 26 17
        | "S" -> normal 26 18
        | "T" -> normal 26 19
        | "U" -> normal 26 20
        | "V" -> normal 26 21
        | "W" -> normal 26 22
        | "X" -> normal 26 23
        | "Y" -> normal 26 24
        | "Z" -> normal 26 25
        | _ -> failwith "Bad data"

let output_map x =
    match max x with
        |  0 -> "A"
        |  1 -> "B"
        |  2 -> "C"
        |  3 -> "D"
        |  4 -> "E"
        |  5 -> "F"
        |  6 -> "G"
        |  7 -> "H"
        |  8 -> "I"
        |  9 -> "J"
        | 10 -> "K"
        | 11 -> "L"
        | 12 -> "C"
        | 13 -> "D"
        | 14 -> "E"
        | 15 -> "F"
        | 16 -> "G"
        | 17 -> "H"
        | 18 -> "I"
        | 19 -> "J"
        | 20 -> "A"
        | 21 -> "B"
        | 22 -> "C"
        | 23 -> "D"
        | 24 -> "E"
        | 25 -> "F"
        | _ -> failwith "Bad data"

let start   = Time.start
let network = Train.csv_file network input_map 10 "data/letters/train.csv"
let elapsed = Time.stop start
let success = Test.csv_file network output_map "data/letters/test.csv"

let () =
    printf "\nTIME TO TRAIN: %.3f seconds\n" elapsed;
    printf "\nTEST SUCCESS RATE: %.3f\n\n" success
