open Types
open Math.Compute
open List
open File

module Forward =
    struct      
        let layer l i =
            map l.activation.f ((l.weight <<<*>> i) <<+>> l.bias)

        let network n i =
            let rec network_aux l v r = 
                match l with
                    | h::t -> let fs = layer h v 
                              in 
                              network_aux t fs (fs::r)
                    | _    -> r
            in
            network_aux n.layers i []

        let eval n m i =
            m (hd (network n i))
    end

module Backpropagate = 
    struct 
        let layer l1 l2 e2 i1 =
            (l2.weight <<<*|>> e2) <<.>> (map l1.activation.f' i1)

        let network n f e =
            let rec network_aux f l e r =
                match (f, l) with
                    | (hf1::hf2::tf, hl1::hl2::tl) ->
                        let b = layer hl2 hl1 e hf2
                        in
                        network_aux (hf2::tf) (hl2::tl) b (b::r)
                    | _ -> r       
            in
            let r = network_aux f (rev n.layers) e []
            in
            rev (e::(rev r))
    end

module Update =
    struct
        let scale x = float_of_int (length x)

        let new_weight e f b l =
            l.weight <<<->>> ((e /. (scale b)) <*>>> (f <<*|>> b))
    
        let new_bias e b l =
            l.bias <<->> ((e /. (scale b)) <*>> b)

        let single n i o =
            let f = Forward.network n i
            in
            let c = n.cost.grad_f (hd f) o 
            in
            let b = Backpropagate.network n f c
            in
            let rec single_aux f b l r =
                match (f, b, l) with
                    | (hf::tf, hb::tb, hl::tl) ->
                        let layer =
                            {
                                weight     = new_weight n.eta hf hb hl;
                                bias       = new_bias n.eta hb hl;
                                activation = hl.activation
                            }
                        in
                        single_aux tf tb tl (layer::r)
                    | _ -> r
            in
            let add_input f i = i::(rev (tl (rev f)))
            in
            let layers = single_aux (add_input (rev f) i) b n.layers []
            in 
            {
                eta    = n.eta;
                cost   = n.cost;
                layers = rev layers
            }
    end

    module Train =
        struct
            let csv_file n m t f =
                let data = load f
                and network = ref n
                in
                let g = (fun x -> let (o,i) = x 
                                  in 
                                  network := Update.single !network i (m o))
                in
                for i = 1 to t do
                    iter g data;   
                done;
                !network
        end

    module Test =
        struct
            let csv_file n om f =
                let data = load f
                in
                let total = length data
                and count = ref 0
                in
                let g = (fun x -> let (o,i) = x 
                                  in 
                                  let out = Forward.eval n om i
                                  in 
                                  if   out = o 
                                  then count := !count + 1;)
                in
                let _ = iter g data
                in
                (float_of_int !count) /. (float_of_int total)
        end
