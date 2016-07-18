# __Neural Networks in OCaml__



This is an implementation of a backpropogation neural network that is 
demonstration code for Computer Science Club.  The objective is to
learn about neural networks, but also to learn about common numerical
libraries such as BLAS and LAPACK, and how they can be used with
OCaml ideally to make numerically performant code with the benefits of 
a functional programming feel.  This is not performant code so much as 
it is instructional.



## __Requirements__

Of course OCaml is required.  If you do not have it installed, it would
be good to have a look at the [installation](https://opam.ocaml.org/doc/Install.html)
and [usage](https://opam.ocaml.org/doc/Usage.html) of OPAM.  This project 
requires ocamlfind and ocamlopt for the normal build.

BLAS and LAPACK are required, including development headers.  There are a number 
of options here.  First, you could install from packages:

```
    yum install blas-devel lapack-devel
```

or

```
    apt-get install libblas-dev liblapack-dev
```

This is simple and probably preferred if you are just seeing how this works.
Another option is to use ATLAS, the automatically tuned variant of
BLAS. This is mainly useful for the BLAS 3 routines as they have 
O(n^3) performance on O(n^2) data, so not really all that relevant here
unless I add mini-batch processing.  Yet another option is to use
vendor-specific editions that are tuned to your processor.  This is not
likely relevant since this is not a performant application so much as a
demonstration of one way to implement algorithms.  

You will also need to install Lacaml.  You can do this with `opam`
by simply:

```
    opam install lacaml
```

Since we are using CSV as a means of specifying training and test 
data, we also will need the `opam` CSV package:

```
    opam install csv
```



## __Data__

In the /data folder there is training and test data, in CSV format,
for Iris and letter recognition data sets.  

The Iris data was obtained
from the [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/machine-learning-databases/iris/bezdekIris.data). Since 
this does not have training and testing data per se, I split a 
number of randomly selected data points into the testing data file.  The
purpose of this is to not test the training data.

The letter recognition data is not direct glyph data, but rather metrics computed from glyph data.
This has been a common technique to reduce the input dimensionality, 
particularly when computational cost is relatively high.  This data was
also obtained from the [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Letter+Recognition).  Again,
since this does not have training and testing data separated, I split a number of randomly selected data points into the testing
data file.



## __Building the Examples__

There are two examples, one each for the Iris and the letter recognition data sets.  
In the root of the project, simply invoke:

```
make iris
```

or

```
make letters
```

This will result in a `_build` folder being created in the root of the project, as well as the respective executables,
`iris` or `letters`, being located there as well.  All of the build products can be removed by:

```
make clean
```

The baseline build does not include optimizations such as inlining, dropping bound checks, exploiting the FPU and 
specialized instructions, etc.  Depending on your platform, you may be able to get better performance.  If you 
find a need to debug, the best option would be to compile bytecode and use the OCaml debugger.



## __Implementation Details__

This is just an implementation of multiple layer perceptrons using gradient descent 
backpropagation for updating weight and bias.  The emphasis is on functional implementation
of the basic functionality with the matrix arithmetic abstracted out and using BLAS / LAPACK
in most cases rather than more direct means of computation.  The idea is to have a pleasant
interface for the user to specify domain problems and fairly performant computation.

Weight and bias initialization are generated uniformly on the interval [-x,x] where x is the square 
root of the number of inputs of a particular layer.  This is based on the following considerations:

```
Glorot, Xavier, and Yoshua Bengio. (2010). "Understanding the difficulty of training deep feedforward neural networks."
```
```
LeCun, Y., Bottou, L., Orr, G. B., and Muller, K. (1998). "Efficient backprop."
```

Activation functions are standard sigmoid-type functions for hidden layers and of the soft-step variety for 
output layers.  Obviously they are all selected to be well-defined with well-defined derivatives that are easy 
and fast to implement.  The primary cost function demonstrated is quadratic, but the information-theoretic 
Kullback-Leibler is presented for fun as well.

Numerical computation is based around infix operators.  This is not a performant decision, as the BLAS / LAPACK
routines are generally more flexible (scaling by a constant, etc.), and this approach does not take advantage 
of these benefits.  The purpose of the exercise, however, is concise, elegant code, and using the infix operators
allows us to squash messy code with numerous arguments into pleasing infix expressions.  The nomenclature used is 
illustrated by this example: to perform the product of a scalar and a matrix, we would use the `<*>>>` infix 
operator.  The number of `<` and `>` dictate the type of argument: `<` for scalar, `<<` for vector and `<<<` for 
matrix.  The interior operator tells us what it is doing: `+` for addition, `-` for subtraction, `*` for traditional
multiplication, `.` for the Hadamard product.  Transpose operations are denoted with `*|`.  



## __Observations__

It is clear that there are some benefits to using BLAS / LAPACK for some of the operations required
in the computation of neural networks.  At least compared with operations on lists in the heap.
As well, the simplicity for matrix-vector operations is notable.  However, these gains are marginalized 
by the need to translate too and from lists, and by the fact that some operations, such as matrix subtraction,
are more difficult to perform with BLAS / LAPACK than with lists.  From a performance standpoint it is a wash.
Large input pattern problems have an advantage whilst smaller problems have higher relative time spend in
menial conversion operations.  

From the perspective of coding style, since the code was designed to be modular, the impact of using FORTRAN
libraries for much of the underlying computation in OCaml code is marginalized.  Any of these operations could
simply be transparently replaced by conventional applicative alternatives, much as the matrix subtraction was
done for simplicity.  The end result is code that is a bit heavier than necessary for the problem, perhaps lacking
some of the functional grace, but is quite flexible, boasting an interface that makes for simple domain problem design.

The `iris` example should have 100% acceptance with the test cases when trained as set.  It should run extremely fast.  The 
`letters` example is interesting in that the original authors of the data could only achieve 80% acceptance of test
cases.  It is also interesting as it is more complicated to optimize acceptance, requiring adjusting network depth and
attention to the learning constant more than other examples.  The provided example executes reasonably quickly but leaves 
ample room for improved acceptance. It is a very useful example since the data is a bit less direct, but possible 
to train in modest time on modest hardware.  Enhancements of this sort are left as an exercise to the reader.
