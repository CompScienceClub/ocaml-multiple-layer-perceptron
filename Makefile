iris: 
	rm -rf _build
	mkdir _build
	cp src/*.ml _build
	cp examples/iris.ml _build
	cd _build && ocamlfind ocamlopt -o iris -linkpkg -package lacaml,csv file.ml math.ml types.ml activation.ml cost.ml layer.ml network.ml utils.ml time.ml iris.ml
	cp _build/iris .

letters: 
	rm -rf _build
	mkdir _build
	cp src/*.ml _build
	cp examples/letters.ml _build
	cd _build && ocamlfind ocamlopt -o letters -linkpkg -package lacaml,csv file.ml math.ml types.ml activation.ml cost.ml layer.ml network.ml utils.ml time.ml letters.ml
	cp _build/letters .

clean:
	rm -rf _build
	rm -f iris letters 
