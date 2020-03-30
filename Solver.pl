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
move([CurrX, CurrY], [NewX, NewY], left):-
    NewX is CurrX + 0,
    NewY is CurrY - 1,
    check_boundaries([NewX, NewY]).
    
% Move Right
move([CurrX, CurrY], [NewX, NewY], right):-
    NewX is CurrX + 0,
    NewY is CurrY + 1,
    check_boundaries([NewX, NewY]).
% Move Up
move([CurrX, CurrY], [NewX, NewY], up):-
    NewX is CurrX - 1,
    NewY is CurrY + 0,
    check_boundaries([NewX, NewY]).
% Move Down
move([CurrX, CurrY], [NewX, NewY], down):-
    NewX is CurrX + 1,
    NewY is CurrY + 0,
    check_boundaries([NewX, NewY]).
% Check if off limits
check_boundaries([NewX, NewY]):-
    dim(X,Y),
    -1 < NewX, NewX < X,
    -1 < NewY, NewY < Y.

play(Moves, Stars):-
    start(S),
    start_game(S, [S], [], 0, Moves, Stars).

start_game(Place, _, Moves, Stars, Moves, Stars):- end(Place).

start_game(CurrentPlace, TotalMoves, Sequence, Stars, Moves, TotalStars):-
    move(CurrentPlace, NextPlace, Movment),
    has_star(NextPlace, Stars, NewStars),
    not(bomb(NextPlace)),
    not(member(NextPlace, TotalMoves)),
    append(Sequence, [Movment], NewSequence),
    start_game(NextPlace, [NextPlace|TotalMoves], NewSequence, NewStars, Moves, TotalStars).

has_star(Place, Stars, NewStars):-
    star(Place),
    NewStars is Stars + 1,!.
has_star(_, Stars, NewStars):-
    NewStars is Stars.