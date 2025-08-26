ordered_remove_by_index_and_return_test :: ()
{
    arr: [] int = .[1, 2, 3, 4];

    result := Array_Helpers.ordered_remove_by_index_and_return(*arr, 0);
    Verifai.are_equal(result, 1);
} @Test

#scope_file
Array_Helpers :: #import "Array_Helpers";
Verifai :: #import "Verifai";
