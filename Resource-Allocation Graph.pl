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
%------------------------------------

% Rules Needed

% check_availabe(---) -> takes a list of resources & list in
% available_instances() and checks that all resources in list are availabe

% release(---) -> takes a list of resources & list in
% available_instances() and returns a new list after the resources are updated


can_run(X):- get_list(X, L, LL).

% get_list(---) -> takes a process and returns a list of it's requested resources
get_list(X, L):- 
    findall(Y, (requested(Z, Y), Z = X), L).