%------------------- Sample test Case -----------------
process(p1).
process(p2).
process(p3).
process(p4).


resource(r1).
resource(r2).
resource(r3).
resource(r4).

allocated(p1, r2).
allocated(p2, r1).
allocated(p3, r1).
allocated(p4, r3).

requested(p4, r1).
requested(p2, r3).
requested(p2, r2).
requested(p4, r4).

available_instances([[r1, 5], [r2, 3], [r3, 0]]).
% available_instances(Available).
% process(P).
% can_run(P, Available).


%------------------

:- dynamic finished/1.
safe_state(X):-
	available_instances(Available),
	run(Available),
	findall(P, finished(P), X).

run(Available):-
	process(P),
	not(finished(P)),
	can_run(P, Available).

can_run(P, Available):- 
	not(requested(P, _)), 
	get_allocated_list(P, Allocated), 
	release(Allocated, Available, NewAvailable),
	add_finished(P),
	run(NewAvailable).

can_run(P, Available, NewAvailable):-
	requested(P, _),
	get_request_list(P, Requested),
	check_availabe(Requested, Available),
	get_allocated_list(P, Allocated), 
	release(Allocated, Available, NewAvailable),
	add_finished(P),
	run(NewAvailable).

add_finished(P):- assert(finished(P)).



%------------------------------------

% Rules Needed

% check_availabe(---) -> takes a list of resources & list in
% available_instances() and checks that all resources in list are availabe
%check_availabe(L1,L2):-
%check_availabe(L1,L2,L2).


get_request_list(P, L):- 
    findall(Y, (requested(Z, Y), Z = P), L).
get_allocated_list(P, L):- 
    findall(Y, (allocated(Z, Y), Z = P), L).