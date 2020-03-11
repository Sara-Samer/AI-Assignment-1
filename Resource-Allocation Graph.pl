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

:- dynamic available_instances/1.
:- dynamic finished/1.

% check_availabe(---) -> takes a list of resources & list in
% available_instances() and checks that all resources in list are availabe

check_availabe([], _):-!.

check_availabe([H|T], A):-
	check_all(H, A, New_list),
	check_availabe(T, New_list).
	
check_all(H, [[R, N]|T], New_list):-
	H = R,
	N > 0,
	N1 is N - 1,
	New_list = [[R,N1]]|T],
	!.

check_all(H, [[R,N]|T], New_list):-
	New_list = [[R, N]|T2],
	check_all(H, T, T2).
	
safe_state(X):-
	run(),
	findall(P, finished(P), X).

run():-
	process(P),
	available_instances(Available),
	not(finished(P)),
	can_run(P, Available).

can_run(P, Available):- 
	not(requested(P, _)), 
	get_allocated_list(P, Allocated), 
	release(Allocated, Available, NewAvailable),
	update_available_instances(NewAvailable),
	add_finished(P),
	run().

can_run(P, Available, NewAvailable):-
	requested(P, _),
	get_request_list(P, Requested),
	check_availabe(Requested, Available),
	get_allocated_list(P, Allocated), 
	release(Allocated, Available, NewAvailable),
	update_available_instances(NewAvailable),
	add_finished(P),
	run().

add_finished(P):- assert(finished(P)).

update_available_instances(NewAvailable):-
	retract(available_instances(OldList)),
	assert(available_instances(NewAvailable)).
	
get_request_list(P, L):- 
    findall(Y, (requested(Z, Y), Z = P), L).

get_allocated_list(P, L):- 
    findall(Y, (allocated(Z, Y), Z = P), L).