Reverse_In_Place_Int_Test_Case :: struct
{
    arr: [] int;
    expected_arr: [] int;
}

reverse_in_place_int_test_cases: [] Reverse_In_Place_Int_Test_Case = .[
    Reverse_In_Place_Int_Test_Case.{arr = .[1, 2, 3, 4], expected_arr = .[4, 3, 2, 1]},
    Reverse_In_Place_Int_Test_Case.{arr = .[1, 2, 3, 4, 5], expected_arr = .[5, 4, 3, 2, 1]},
];

reverse_in_place_test :: (c: Reverse_In_Place_Int_Test_Case)
{
    comparator := #procedure_of_call Array_Helpers.arrays_are_equal(int.[], int.[]);

    Array_Helpers.reverse_in_place(*c.arr);
    Verifai.are_equal(c.arr, c.expected_arr, comparator);
} @Test

#scope_file

Verifai :: #import "Verifai";
Array_Helpers :: #import "Array_Helpers";
