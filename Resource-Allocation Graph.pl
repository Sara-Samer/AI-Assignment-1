%------------------- Sample test Case -----------------
process(p1).
process(p2).
process(p3).
process(p4).


resource(r1).
resource(r2).

allocated(p1, r2).
allocated(p2, r1).
allocated(p3, r1).
allocated(p4, r2).

requested(p1, r1).
requested(p3, r2).

available_instances([[r1, 0], [r2, 0]]).
%available_instances([[r1, 6], [r2, 4], [r3, 1], [r4, 3]]).

:- dynamic available_instances/1.
:- dynamic original_instances/1.
:- dynamic finished/1.
:- dynamic safe_sequence/1.

set():- 
	available_instances(L), 
	assert(original_instances(L)).

reset():- 
	original_instances(L),
	update_available_instances(L).

% check_availabe(---) -> takes a list of resources & list in
% available_instances() and checks that all resources in list are availabe

safe_state(X):-
	set(),
	run(),
	reset(),
	get_finished_list(F),
	not(safe_sequence(F)),
	add_sequence(F),
	get_finished_list(X), 
	clear_finished().

run():-
	process(P),
	available_instances(Available),
	(
		not(finished(P)),
		can_run(P, Available), !
	);
	(
		check_if_done(),
		reset()
	).

% safe_state(X):-
% 	run(),
% 	safe_sequence(X),
% 	clear_finished().

% run():-
% 	process(P),
% 	available_instances(Available),
% 	(
% 		not(finished(P)),
% 		can_run(P, Available)
% 	);
% 	(
% 		check_if_done(),
% 		get_finished_list(F),
% 		not(safe_sequence(F)),
% 		add_sequence(F),
% 		clear_finished()

% 	).


can_run(P, Available):-
	get_request_list(P, Requested),
	check_availabe(Requested, Available),
	get_allocated_list(P, Allocated), 
	release(Allocated, Available, NewAvailable),
	update_available_instances(NewAvailable),
	add_finished(P),
	run().

release(_,[],[] ).
release(L,[[R,I]|T],E ):-
    member(R,L),
    findall(R, member(R,L), Bag), 
    length(Bag, NumOfInstances ),
    I2 is I + NumOfInstances ,
    E =[[R,I2]|T2],
    release(L,T,T2).

release(L,[[R,I]|T],E):-
	E =[[R,I]|T2],
	release(L,T,T2).

check_availabe([], _):-!.
check_availabe([H|T], A):-
	check_all(H, A, New_list),
	check_availabe(T, New_list).
	
check_all(H, [[R, N]|T], New_list):-
	H = R,
	N > 0,
	N1 is N - 1,
	append([[R, N1]], T, New_list),
	!.

check_all(H, [[R,N]|T], New_list):-
	New_list = [[R, N]|T2],
	check_all(H, T, T2).
	
update_available_instances(NewAvailable):-
	retract(available_instances(OldList)),
	assert(available_instances(NewAvailable)).

clear_finished():-
	get_finished_list(Finished),
	clear_finished(Finished).
clear_finished([]):-!.
clear_finished([H|T]):-
	retract(finished(H)),
	clear_finished(T).

% check_if_done():-
% 	get_process_list(PL),
% 	get_finished_list(FL),
% 	sort(PL, P),
%   sort(FL, F),
% 	F == P.

add_finished(P):- assert(finished(P)).
add_sequence(X):- assert(safe_sequence(X)).

check_if_done():-
	get_process_list(PL),
	get_finished_list(FL),
	check_member(PL, FL).

check_member([],_).
check_member([H|T],Y):-
    member(H,Y),
    check_member(T,Y).

get_request_list(P, L):- 
    findall(Y, (requested(Z, Y), Z = P), L).

get_allocated_list(P, L):- 
    findall(Y, (allocated(Z, Y), Z = P), L).

get_process_list(L):- 
    findall(P, process(P), L).

get_finished_list(L):- 
    findall(P, finished(P), L).