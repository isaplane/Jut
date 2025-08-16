map_simple_test_positive :: ()
{
    nums    := int.[1, 2, 3, 4];
    squares := Arr_Help.map(nums, x => x * x);

    equal := Arr_Help.arrays_are_equal(squares, int.[1, 4, 9, 16], (a, b) => a == b);
    Verifai.is_true(equal);
} @Test

// -----------------------------------------------------------------------------

map_simple_test_negative :: ()
{
    nums    := int.[1, 2, 3, 4];
    squares := Arr_Help.map(nums, x => x * x);

    equal := Arr_Help.arrays_are_equal(squares, int.[2, 4, 9, 16], (a, b) => a == b);
    Verifai.is_false(equal);
} @Test

// -----------------------------------------------------------------------------

Test_Struct :: struct
{
    num: int;
    str: string;
}

map_struct_member_test_positive :: ()
{
    a := Test_Struct.[
        .{num = 1, str = "Bob"},
        .{num = 2, str = "Alice"},
    ];

    b := Arr_Help.map(a, x => x.num);

    equal := Arr_Help.arrays_are_equal(b, int.[1, 2], (a, b) => a == b);
    Verifai.is_true(equal);
} @Test

#scope_file
Verifai  :: #import "Verifai";
Arr_Help :: #import "Array_Helpers";
