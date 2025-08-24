default_comparator_int_contains_tests :: ()
{
    a := int.[1, 2, 3, 4];
    t := 2;

    Verifai.is_true(Array_Helpers.contains(a, t));

    t = 5;
    Verifai.is_false(Array_Helpers.contains(a, t));
} @Test

#scope_file
Verifai :: #import "Verifai";
Array_Helpers :: #import "Array_Helpers";
