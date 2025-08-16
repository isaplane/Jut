are_equal_int_test_positive :: ()
{
    a := int.[1, 2, 3, 4];
    b := int.[1, 2, 3, 4];

    Verifai.is_true(Arr_Help.arrays_are_equal(a, b, (a, b) => a == b));
} @Test

// -----------------------------------------------------------------------------

are_equal_float_test_positive :: ()
{
    a := float.[1, 2, 3, 4];
    b := float.[1, 2, 3, 4];

    Verifai.is_true(Arr_Help.arrays_are_equal(a, b, (a, b) => a == b));
} @Test

// -----------------------------------------------------------------------------

are_equal_string_test_positive :: ()
{
    a := string.["Hello", ",", "Sailor", "!"];
    b := string.["Hello", ",", "Sailor", "!"];

    Verifai.is_true(Arr_Help.arrays_are_equal(a, b, (a, b) => a == b));
} @Test

// This causes a compiler crash??
// -----------------------------------------------------------------------------

are_equal_string_test_negative :: ()
{
    a := string.["My", "Name", "Is", "Bob"];
    b := string.["My", "Name", "Is", "Alice"];

    Verifai.is_false(Arr_Help.arrays_are_equal(a, b, (a, b) => a == b));
} @Test

// -----------------------------------------------------------------------------

are_equal_int_array_test :: ()
{
    a := [4] int.[int.[1, 2, 3, 4], int.[5, 6, 7, 8]];
    b := [4] int.[int.[1, 2, 3, 4], int.[5, 6, 7, 8]];

    array_of_arrays_are_equal :: (a: [] $T, b: [] T) -> bool
    {
        if a.count != b.count return false;

        for 0..a.count-1
        {
            if !Arr_Help.arrays_are_equal(a[it], b[it], (a, b) => a == b) return false;
        }

        return true;
    }

    Verifai.is_true(array_of_arrays_are_equal(a, b));
}

#scope_file
Verifai  :: #import "Verifai";
Arr_Help :: #import "Array_Helpers";
