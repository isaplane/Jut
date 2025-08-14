Rect :: struct
{
    x, y: float;
    w, h: float;
}

Node_Data :: struct
{
    index: int;
    rect: Rect;
}

Setup_Data :: struct
{
    tree: *BSP.Tree(BSP.Node(Node_Data));
}

Setup_Data_One_Bisect :: struct
{
    tree:  *BSP.Tree(BSP.Node(Node_Data));
    left:  *BSP.Node(Node_Data);
    right: *BSP.Node(Node_Data);
}

node_contains_point :: (using data: Node_Data, x: float, y: float) -> bool
{
    return (x >= rect.x) && (x < rect.x + rect.w) && (y >= rect.y) && (y < rect.y + rect.h);
}

map :: (array: [] $T, f: (T) -> $S) -> [..] S {
    results: [..] S;

    for array array_add(*results, f(it));

    return results;
}

array_comparator :: (a: [] int, b: [] int) -> bool
{
    if a.count != b.count return false;
    for 0 .. a.count - 1
    {
        if a[it] != b[it] return false;
    }

    return true;
}

compile_test :: ()
{
    Verifai.is_true(true);
} @Test

Contains_Test_Case :: struct
{
    data: Node_Data;
    x: float;
    y: float;

    expected: bool;
}

contains_test_cases : [] Contains_Test_Case = .[
    .{data = .{rect = .{0, 0, 100, 100}}, x = 50, y = 50, expected = true},
    .{data = .{rect = .{0, 0, 100, 100}}, x = 100, y = 50, expected = false},
    .{data = .{rect = .{0, 0, 100, 100}}, x = 99, y = 50, expected = true},
    .{data = .{rect = .{0, 0, 100, 100}}, x = 50, y = 100, expected = false},
    .{data = .{rect = .{0, 0, 100, 100}}, x = 50, y = 99, expected = true},
    .{data = .{rect = .{0, 0, 100, 100}}, x = 100, y = 100, expected = false},
    .{data = .{rect = .{0, 0, 100, 100}}, x = 0, y = 0, expected = true},
];

contains_test :: (c: Contains_Test_Case)
{
    Verifai.are_equal(node_contains_point(c.data, c.x, c.y), c.expected);
} @Test

#scope_file
Verifai :: #import "Verifai";
BSP :: #import "BSP";
