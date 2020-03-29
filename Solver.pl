dim(4,4).
start([1,0]).
end([2,2]).
bomb([0,1]).
bomb([1,2]).
bomb([2,0]).
bomb([3,0]).
star([2,1]).
star([2,3]).
star([3,2]).
% Input is -> play(Moves, Stars).
% Output -> Moves = [right, down, down, right, right, up, left],
%           Stars = 3 ;

% Proposed Prdict -> move([CurrX, CurrY], [NewX, NewY], Move)
%                    Where move is either [left, right, up, down].

% Proposed Prdict -> has_star([CurrX, CurrY], NumStar, NewStar)

% Move Left
% Move Right
% Move Up
% Move Down

play(Moves, Stars):-
    start(S).
    start_game(S, [S], Moves, Stars).

start_game(Place, _, _, 0):- end(Place).
start_game(CurrentPlace, TotalMoves, Sequence, Stars):-
    move(CurrentPlace, NextPlace, Movment),
    not(bomb(NextPlace)),
    has_star(NextPlace, Stars, NewStars),
    not(member(NextPlace, TotalMoves)),
    start_game(NextPlace, [NextPlace|TotalMoves], [Movment|Sequence], NewStars).

