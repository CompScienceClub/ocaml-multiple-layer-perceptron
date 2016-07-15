open Lacaml.S
open Lacaml.Io
open Printf
open Array
open List

module Type = 
    struct
        type scalar = float
        type vector = float list
        type matrix = float list list
    end


module Convert =
    struct
        let vector_of_list = Vec.of_list 
        let vector_to_list = Vec.to_list 
        let matrix_of_list = Mat.of_list 
        let matrix_to_list = Mat.to_list 
        let matrix_of_array = Mat.of_array
    end


module Random =
    struct
        open Convert

        let vector l c w = 
            vector_to_list (Vec.random l ~from:(c -. w) ~range:(2. *. w))

        let matrix l m c w = 
            matrix_to_list (Mat.random l m ~from:(c -. w) ~range:(2. *. w))
    end


module Print =
    struct 
        let matrix m =
            let m = Mat.of_list m
            in
            let r = Mat.dim1 m
            and c = Mat.dim2 m
            in
            let _ = Format.printf "%a%!" (pp_lfmat
                ~row_labels:(init r (fun i -> sprintf "Row %d" (i + 1)))
                ~col_labels:(init c (fun i -> sprintf "Col %d" (i + 1)))
                ~vertical_context:(Some (Context.create 2))
                ~horizontal_context:(Some (Context.create 3))
                ~ellipsis:"*"
                ~print_right:false
                ~print_foot:false ()) m
            in 
            printf "\n\n"

        let vector v = matrix [v]
    end


module Misc =
    struct
        open Convert

        let make_array r c = make r (make c 0.) 
        let two_norm v = nrm2 (vector_of_list v)
    end


module Compute =
    struct
        open Convert
        open Misc

        let (<*>>) s v      = map  (fun x -> s *. x) v
        let (<<+>>) v1 v2   = map2 (fun x y -> x +. y) v1 v2
        let (<<->>) v1 v2   = map2 (fun x y -> x -. y) v1 v2
        let (<<.>>) v1 v2   = map2 (fun x y -> x *. y) v1 v2
        let (<*>>>) s m     = map  (fun x -> map (fun i -> s *. i) x) m
        let (<<<->>>) m1 m2 = map2 (fun x y -> map2 (fun i j -> i -. j) x y) m1 m2

        let (<<<*>>) m v = 
            let m = matrix_of_list m
            and v = vector_of_list v
            in
            vector_to_list (gemv m v)

        let (<<<*|>>) m v = 
            let m = matrix_of_list m
            and v = vector_of_list v
            in
            vector_to_list (gemv m v ~trans:`T)

        let (<<*|>>) v1 v2 =
            let r = length v2 
            and c = length v1
            in
            let v1 = vector_of_list v1
            and v2 = vector_of_list v2
            in
            let m = matrix_of_array (make_array r c)
            in
            matrix_to_list (ger v2 v1 m ~alpha:1.)
    end
