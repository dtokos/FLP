:- dynamic recipe/3.

main :-
	repeat,
	menu,
	readAtom(Choice),
	execute(Choice),
	Choice == '9',
	writeln('Koniec'),
	!.

menu :-
	nl,
	writeln('1 - Nacitaj zo suboru'),
	writeln('2 - Zapis do suboru'),
	writeln('3 - Vypis receptov'),
	writeln('4 - Vyhladat recepty'),
	writeln('5 - Zoradit recepty'),
	writeln('6 - Zistit cenu pre osoby'),
	writeln('7 - Recepty podla surovin'),
	writeln('8 - Pridat recept'),
	writeln('9 - Vymazat vsetky recepty'),
	writeln('0 - Koniec'),
	writeln('----------------------------'),
	nl.

execute('1') :- readFromFile, !.
execute('2') :- writeToFile, !.
execute('3') :- printRecipes, !.
execute('4') :- findRecipes, !.
execute('5') :- sortRecipes, !.
execute('6') :- findPriceForPersons, !.
execute('7') :- findRecipesByIngredients, !.
execute('8') :- addRecipe, !.
execute('9') :- removeAllRecipes, !.
execute('0') :- !.
execute(_) :- writeln('Neznama akcia').






readFromFile :-
	write('Zadajte nazov suboru: '),
	readAtom(Name),
	readRecipeFile(Name).

readRecipeFile(Name) :-
	removeAllRecipes,
	see(Name),
	repeat,
	read(Term),
	(
		Term = end_of_file, !, seen
		;
		assertz(Term), fail
	).






writeToFile :-
	write('Zadajte nazov suboru: '),
	readAtom(Name),
	writeRecipeFile(Name).

writeRecipeFile(Name) :-
	tell(Name),
	recipe(RecipeName, Ingredients, CookingTime),
	writeq(recipe(RecipeName, Ingredients, CookingTime)),
	write('.'),
	nl,
	fail.
writeRecipeFile(_) :-
	told.






printRecipes :-
	findAllRecipes(Recipes),
	printRecipeList(Recipes),
	%recipe(Name, Ingredients, time(Hours, Minutes)), % TODO: Implement
	%format('Recept: ~w~nCas pripravy ~|~`0t~d~2+:~|~`0t~d~2+~nIngrediencie:~n', [Name, Hours, Minutes]),
	%%writeln('Ingrediencie: '),
	%printIngredients(Ingredients),
	%%format('Cas pripravy: ~w~n~n', [CookingTime]),
	%nl,
	fail.
printRecipes.

findAllRecipes(Recipes) :-
	findall(recipe(Name, Ingredients, CookingTime), recipe(Name, Ingredients, CookingTime), Recipes).

printRecipeList(Recipes) :-
	forall(
		member(recipe(Name, Ingredients, time(Hours, Minutes)), Recipes),
		(
			format('Recept: ~w~nCas pripravy ~|~`0t~d~2+:~|~`0t~d~2+~nIngrediencie:~n', [Name, Hours, Minutes]),
			printIngredients(Ingredients),
			nl
		)
	).

printIngredients(Ingredients) :-
	forall(
		member(ingredient(Name, Quantity, Price), Ingredients),
		format('~t~4|~w ~wx ~2f~n', [Name, Quantity, Price])
	).
%printIngredients([Ingredient|Rest]) :-
%	printIngredient(Ingredient),
%	printIngredients(Rest).
%printIngredients([]).
%
%printIngredient(ingredient(Name, Quantity, Price)) :-
%	format('~t~4|~w ~wx ~2f~n', [Name, Quantity, Price]).




findRecipes :-
	write('Zadajte nazov receptu: '),
	readAtom(Name),
	readIngredientsList(IngredientsList),
	findall(recipe(Name, Ingredients, CookingTime), recipe(Name, Ingredients, CookingTime), Recipes),
	%findAllRecipes(Recipes),
	include(filterByIngredients(IngredientsList), Recipes, FilteredRecipes),
	printRecipeList(FilteredRecipes).
%filterByIngredients([], _).
%filterByIngredients(_, recipe(_, [], _)).
%filterByIngredients(Names, recipe(_, [ingredient(Name, _, _)|Rest], _)) :-
%	member(Name, Names),
%	filterByIngredients(Names, Rest).
readIngredientsList([Name|Rest]) :-
	write('Zadajte nazov ingrediencie: '),
	readAtom(Name),
	Name \= '',
	readIngredientsList(Rest).
readIngredientsList([]).

filterByIngredients(Names, recipe(_, Ingredients, _)) :-
	forall(member(Name, Names), member(ingredient(Name, _, _), Ingredients)).




sortRecipes :-
	sortMenu,
	readAtom(Choice),
	sortRecipesChoice(Choice).

sortMenu :-
	writeln('1 - Zoradit podla mena'),
	writeln('2 - Zoradit podla ceny'),
	writeln('3 - Zoradit podla casu pripravy').

sortRecipesChoice('1') :- sortRecipesBy(sortByRecipeName).
sortRecipesChoice('2') :- sortRecipesBy(sortByRecipePrice).
sortRecipesChoice('3') :- sortRecipesBy(sortByRecipeCookingTime).
sortRecipesChoice(_) :- writeln('Neznama akcia').

sortByRecipeName(recipe(Name, _, _), Name).
sortByRecipePrice(recipe(_, Ingredients, _), Price) :-
	calculateRecipePrice(Ingredients, Price).
sortByRecipeCookingTime(recipe(_, _, time(Hours, Minutes)), Total) :-
	Total is Hours * 60 + Minutes.

sortRecipesBy(Lambda) :-
	findAllRecipes(Recipes),
	maplist(prefixAtomWithKey(Lambda), Recipes, KeyedRecipes),
	keysort(KeyedRecipes, SortedRecipes),
	removeAllRecipes,
	forall(member(_-Recipe, SortedRecipes), assertz(Recipe)).

prefixAtomWithKey(Lambda, Input, Output) :-
	call(Lambda, Input, Key),
	Output = Key-Input.



findPriceForPersons :-
	write('Zadajte nazov receptu: '),
	readAtom(Name),
	write('Zadajte pocet osob: '),
	readNumber(Persons),
	recipe(Name, Ingredients, _),
	calculateRecipePrice(Ingredients, Price),
	TotalPrice = Price * Persons,
	format('Cena receptu ~w pre ~d osob je ~2f~n', [Name, Persons, TotalPrice]).





findRecipesByIngredients :-
	readIngredientsAndQuantities(Ingredients),
	findAllRecipes(Recipes),
	include(filterByIngredientsAndQuantities(Ingredients), Recipes, FilteredRecipes),
	printRecipeList(FilteredRecipes).

readIngredientsAndQuantities([Ingredient|Rest]) :-
	write('Chcete pridat dalsiu ingredienciu (0 = nie): '),
	readAtom(Choice),
	Choice \= '0',
	readIngredientAndQuantity(Ingredient),
	readIngredientsAndQuantities(Rest).
readIngredientsAndQuantities([]).

readIngredientAndQuantity(Ingredient) :-
	write('Zadajte nazov ingrediencie: '),
	readAtom(Name),
	write('Zadajte pocet: '),
	readNumber(Quantity),
	Ingredient = [Name, Quantity].

filterByIngredientsAndQuantities(AvailableIngredients, recipe(_, Ingredients, _)) :-
	forall(member(ingredient(Name, Quantity, _), Ingredients), compareWithAvailableIngredients(Name, Quantity, AvailableIngredients)).

compareWithAvailableIngredients(Name, Quantity, [[Name, AvailableQuantity]|Rest]) :-
	(AvailableQuantity >= Quantity, !)
	;
	compareWithAvailableIngredients(Name, Quantity, Rest).

compareWithAvailableIngredients(_, _, []) :-
	fail.




addRecipe :-
	write('Zadajte nazov receptu: '),
	readAtom(Name),
	write('Zadajte cas pripravy (HH:mm): '),
	readCookingTime(CookingTime),
	writeln('Vyplnte ingrediencie'),
	readIngredients(Ingredients),
	assertz(recipe(Name, Ingredients, CookingTime)).

readCookingTime(Time) :-
	readString(TimeAtom),
	term_string(Hours:Minutes, TimeAtom),
	integer(Hours),
	integer(Minutes),
	Hours >= 0,
	between(0, 60, Minutes),
	Time = time(Hours, Minutes).
readCookingTime(Time) :-
	write('Musite zadat cas vo formate HH:mm: '),
	readCookingTime(Time).

readIngredients([Ingredient|Rest]) :-
	write('Chcete pridat dalsiu ingredienciu (0 = nie): '),
	readAtom(Choice),
	Choice \= '0',
	readIngredient(Ingredient),
	readIngredients(Rest).
readIngredients([]).

readIngredient(Ingredient) :-
	write('Zadajte nazov ingrediencie: '),
	readAtom(Name),
	write('Zadajte pocet: '),
	readNumber(Quantity),
	write('Zadajte cenu: '),
	readNumber(Price),
	Ingredient = ingredient(Name, Quantity, Price).





removeAllRecipes :-
	retractall(recipe(_, _, _)).



calculateRecipePrice(Ingredients, Price) :-
	foldl(calculateRecipePriceSum, Ingredients, 0, Price).
calculateRecipePriceSum(ingredient(_, _, Price), Acc, NextAcc) :-
	NextAcc is Acc + Price.


readAtom(Atom) :-
	readString(String),
	atom_string(Atom, String).

readNumber(Number) :-
	readString(Str),
	number_string(Number, Str),
	!.
readNumber(Number) :-
	write('Musite zadat cislo: '),
	readNumber(Number).

%readString(String) :-
%	read_line(String).
%readString(String) :-
%	read_string(Temp),
%	string_term(Temp, String).
%readString(String) :-
%	current_input(Input),
%	read_string(Input, '\n', '\r\t ', ' ', String).
readString(String) :-
	current_input(Input),
	read_line_to_codes(Input, Codes),
	string_codes(String, Codes).