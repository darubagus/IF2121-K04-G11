:- use_module(library(random)).

random_test :-
    random(1,4,Test),
    write(Test),!.

random_test.


    