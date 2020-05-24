% Dobroslav Tokoš
% Chcel som si odskúšať funkcionálne programovať v Prologu a preto nie je celková dátová štruktúra najoptimálnejšia.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definície

% Dynamická definícia predikátu receptu
:- dynamic recipe/3.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main

% Hlavný cyklus programu
main :-
	repeat,
	menu,
	readAtom(Choice),
	execute(Choice),
	Choice == '0',
	writeln('Koniec'),
	!.

% Hlavné menu programu
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

% Spúšťa jednotlivé akcie
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





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Akcie

% Akcia ktorá načíta databázu zo súboru
readFromFile :-
	write('Zadajte nazov suboru: '),
	readAtom(Name),
	readRecipeFile(Name).

% Načíta recepty zo zvoleného súboru
readRecipeFile(Name) :-
	removeAllRecipesFromDB,
	see(Name),
	repeat,
	read(Term),
	(
		Term = end_of_file, !, seen
		;
		assertz(Term), fail
	).





% Akcia ktora zapíše databázu do súboru
writeToFile :-
	write('Zadajte nazov suboru: '),
	readAtom(Name),
	writeRecipeFile(Name).

% Zapíše recepty do zvoleného súboru
writeRecipeFile(Name) :-
	tell(Name),
	recipe(RecipeName, Ingredients, CookingTime),
	writeq(recipe(RecipeName, Ingredients, CookingTime)),
	writeln('.'),
	fail.
writeRecipeFile(_) :-
	told.





% Akcia ktorá vypíše všetky recepty
printRecipes :-
	findAllRecipes(Recipes),
	writeln('Vsetky dostupne recepty:'),
	printRecipeList(Recipes).

% Načíta všetky recepty do zoznamu
findAllRecipes(Recipes) :-
	findall(recipe(Name, Ingredients, CookingTime), recipe(Name, Ingredients, CookingTime), Recipes).

% Vypíše recepty zo zoznamu
printRecipeList(Recipes) :-
	forall(
		member(recipe(Name, Ingredients, time(Hours, Minutes)), Recipes),
		(
			format('Recept: ~w~nCas pripravy ~|~`0t~d~2+:~|~`0t~d~2+~nIngrediencie:~n', [Name, Hours, Minutes]),
			printIngredients(Ingredients),
			nl
		)
	).

% Vypíše zoznam ingrediencií
printIngredients(Ingredients) :-
	forall(
		member(ingredient(Name, Quantity, Price), Ingredients),
		format('~t~4|~w ~wx ~2f~n', [Name, Quantity, Price])
	).





% Akcia ktorá vyhľadá recepty podľa názvu a ingrediencií
findRecipes :-
	write('Zadajte nazov receptu: '),
	readAtom(Name),
	readIngredientsList(IngredientsList),
	findall(recipe(Name, Ingredients, CookingTime), recipe(Name, Ingredients, CookingTime), Recipes),
	include(filterByIngredients(IngredientsList), Recipes, FilteredRecipes),
	writeln('Recepty splnajuce kriteria:'),
	printRecipeList(FilteredRecipes).

% Načíta zoznam ingrediencií podľa ktorého sa bude filtrovať
readIngredientsList([Name|Rest]) :-
	write('Zadajte nazov ingrediencie: '),
	readAtom(Name),
	Name \= '',
	readIngredientsList(Rest).
readIngredientsList([]).

% Určí či recept obsahuje všetky potrebné ingrediencie
filterByIngredients(Names, recipe(_, Ingredients, _)) :-
	forall(member(Name, Names), member(ingredient(Name, _, _), Ingredients)).





% Akcia ktorá zoradí recepty
sortRecipes :-
	sortMenu,
	readAtom(Choice),
	sortRecipesChoice(Choice).

% Menu s možnosťami zoradenia
sortMenu :-
	writeln('1 - Zoradit podla mena'),
	writeln('2 - Zoradit podla ceny'),
	writeln('3 - Zoradit podla casu pripravy').

% Spúšťa jednotlivé akcie na zoradenie
sortRecipesChoice('1') :- 
	writeln('Recepty boli zoradene podla mena'),
	sortRecipesBy(sortByRecipeName).
sortRecipesChoice('2') :-
	writeln('Recepty boli zoradene podla ceny'),
	sortRecipesBy(sortByRecipePrice).
sortRecipesChoice('3') :-
	writeln('Recepty boli zoradene podla casu pripravy'),
	sortRecipesBy(sortByRecipeCookingTime).
sortRecipesChoice(_) :-
	writeln('Neznama zoradovacia akcia').

% Funkcie vracajúce atribúty podľa ktorých sa majú recepty zoradiť
sortByRecipeName(recipe(Name, _, _), Name).
sortByRecipePrice(recipe(_, Ingredients, _), Price) :-
	calculateRecipePrice(Ingredients, Price).
sortByRecipeCookingTime(recipe(_, _, time(Hours, Minutes)), Total) :-
	Total is Hours * 60 + Minutes.

% Zoradí recepty podľa zvolenej možnosti
sortRecipesBy(Lambda) :-
	findAllRecipes(Recipes),
	maplist(prefixAtomWithKey(Lambda), Recipes, KeyedRecipes),
	keysort(KeyedRecipes, SortedRecipes),
	removeAllRecipesFromDB,
	forall(member(_-Recipe, SortedRecipes), assertz(Recipe)).

% Pridá pred atom hodnotu podľa ktorej sa recepty zoradia
prefixAtomWithKey(Lambda, Input, Output) :-
	call(Lambda, Input, Key),
	Output = Key-Input.





% Akcia ktorá vypíše cenu receptu pre zvolený počet osôb
findPriceForPersons :-
	write('Zadajte nazov receptu: '),
	readAtom(Name),
	write('Zadajte pocet osob: '),
	readPersons(Persons),
	recipe(Name, Ingredients, _),
	calculateRecipePrice(Ingredients, Price),
	TotalPrice = Price * Persons,
	format('Cena receptu ~w pre ~d osob je ~2f~n', [Name, Persons, TotalPrice]).

% Načíta počet osôb
readPersons(Persons) :-
	readNumber(Input),
	integer(Input),
	Input > 0,
	Persons = Input.
readPersons(Time) :-
	write('Musite zadat cele cislo vacsie ako nula: '),
	readPersons(Time).





% Akcia ktorá nájde recepety podľa dostupných surovín
findRecipesByIngredients :-
	readIngredientsAndQuantities(Ingredients),
	findAllRecipes(Recipes),
	include(filterByIngredientsAndQuantities(Ingredients), Recipes, FilteredRecipes),
	writeln('Recepty podla dostupnych surovin:'),
	printRecipeList(FilteredRecipes).

% Načíta dostupné suroviny
readIngredientsAndQuantities([Ingredient|Rest]) :-
	write('Chcete pridat dalsiu ingredienciu (0 = nie): '),
	readAtom(Choice),
	Choice \= '0',
	readIngredientAndQuantity(Ingredient),
	readIngredientsAndQuantities(Rest).
readIngredientsAndQuantities([]).

% Načíta jednu dostupnú surovinu
readIngredientAndQuantity(Ingredient) :-
	write('Zadajte nazov ingrediencie: '),
	readAtom(Name),
	write('Zadajte pocet: '),
	readNumber(Quantity),
	Ingredient = [Name, Quantity].

% Určí či máme na recept všetky potrebné suroviny
filterByIngredientsAndQuantities(AvailableIngredients, recipe(_, Ingredients, _)) :-
	forall(member(ingredient(Name, Quantity, _), Ingredients), compareWithAvailableIngredients(Name, Quantity, AvailableIngredients)).

% Určí či máme konkrétnu surovinu
compareWithAvailableIngredients(Name, Quantity, [[Name, AvailableQuantity]|Rest]) :-
	(AvailableQuantity >= Quantity, !)
	;
	compareWithAvailableIngredients(Name, Quantity, Rest).
compareWithAvailableIngredients(_, _, []) :-
	fail.





% Akcia ktorá pridá recept
addRecipe :-
	write('Zadajte nazov receptu: '),
	readAtom(Name),
	write('Zadajte cas pripravy (HH:mm): '),
	readCookingTime(CookingTime),
	writeln('Vyplnte ingrediencie'),
	readIngredients(Ingredients),
	assertz(recipe(Name, Ingredients, CookingTime)).

% Načíta čas prípravy vo formáte HH:mm
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

% Načíta zoznam ingrediencií
readIngredients([Ingredient|Rest]) :-
	write('Chcete pridat dalsiu ingredienciu (0 = nie): '),
	readAtom(Choice),
	Choice \= '0',
	readIngredient(Ingredient),
	readIngredients(Rest).
readIngredients([]).

% Načíta jednu ingredienciu
readIngredient(Ingredient) :-
	write('Zadajte nazov ingrediencie: '),
	readAtom(Name),
	write('Zadajte pocet: '),
	readNumber(Quantity),
	write('Zadajte cenu: '),
	readNumber(Price),
	Ingredient = ingredient(Name, Quantity, Price).





% Akcia ktorá zmaže všetky recepty
removeAllRecipes :-
	writeln('Vsetky recepty boli zmazane'),
	removeAllRecipesFromDB.

% Zmaže všetky recepty
removeAllRecipesFromDB :-
	retractall(recipe(_, _, _)).





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pomocné funkcie

% Pomocná funkcia na výpočet ceny receptu
calculateRecipePrice(Ingredients, Price) :-
	foldl(calculateRecipePriceSum, Ingredients, 0, Price).
calculateRecipePriceSum(ingredient(_, _, Price), Acc, NextAcc) :-
	NextAcc is Acc + Price.

% Pomocná funkcia ktorá načíta vstup ako atóm
readAtom(Atom) :-
	readString(String),
	atom_string(Atom, String).

% Pomocná funkcia ktorá načíta vstup ako číslo
readNumber(Number) :-
	readString(Str),
	number_string(Number, Str),
	!.
readNumber(Number) :-
	write('Musite zadat cislo: '),
	readNumber(Number).

% Pomocná funkcia ktorá načíta vstup ako string
readString(String) :-
	current_input(Input),
	read_line_to_codes(Input, Codes),
	string_codes(String, Codes).
