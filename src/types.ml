open Math.Type

type activation = 
    {
        f:  scalar -> scalar;
        f': scalar -> scalar
    }

type cost =
    {
        f:      vector -> vector -> scalar;
        grad_f: vector -> vector -> vector
    }

type layer = 
    {
        weight:     matrix;
        bias:       vector;
        activation: activation
    }

type network =  
    {
        eta:    scalar;
        cost:   cost;
        layers: layer list
    }
