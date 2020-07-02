%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prvá úloha

vysledky('Peter', 'Rýchly', 'Jednota', 5:15).
vysledky('Eugen', 'Ártvy', 'Humenné', 4:20).
vysledky('Ján', 'Šterchla', 'Humence', 4:37).
vysledky('Jana', 'Šterchlová', 'Búre', 5:10).
vysledky('Martin', 'Falaj', 'Devín', 7:03).

% Prvá verzia
%vypis(Min:Sek) :-
%    vysledky(Meno, Priezvisko, _, VMin:VSek),
%    (
%        (VMin < Min);
%        (VMin == Min, VSek < Sek)
%    ),
%    format('~w ~w~n', [Meno, Priezvisko]).

% Druhá verzia
vypis(Min:Sek) :-
    findall(Meno:Priezvisko, (
        vysledky(Meno, Priezvisko, _, VMin:VSek),
        (
            (VMin < Min);
            (VMin == Min, VSek < Sek)
        )
    ), List),
    forall(
        member(Meno:Priezvisko, List),
        format('~w ~w~n', [Meno, Priezvisko])
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Druhá úloha

zaporne([], []).
zaporne([H|T], [X|Y]) :-
    zaporne(H, X),
    zaporne(T, Y).
zaporne(X, X) :-
    number(X),
    X < 0.
%zaporne(X, X) :-
%    not(number(X)),

%zaporne([], []).
%zaporne([H|T], [H|NT]) :-
%    number(H),
%    H < 0,
%    !,
%    zaporne(T, NT).
%zaporne([_|T], NT) :-
%    zaporne(T, NT).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Štvrtá úloha
% [[a,1],[x,3],[f,0],[t,t],[b,2]] -> [[a,1],[x,3],[f,0]]

test([X,Y]) :-
    atom(X),
    number(Y).

take_while(_, [], []).
take_while(Fnc, [H|T], L2) :-
    (
        call(Fnc, H),
        take_while(Fnc, T, X),
        L2 = [H|X],
        !
    ) ; L2 = [].
