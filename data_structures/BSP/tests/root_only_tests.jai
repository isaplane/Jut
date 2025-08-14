setup_root_only_tests :: ()
{
    setup := New(Setup_Data);
    setup.tree = BSP.get_new_tree(Node_Data.{
        index = 0,
        rect = .{0, 0, 1920, 1080}
    });

    context.setup_data = setup;
} @Setup

teardown_root_only_tests :: ()
{
    free(context.setup_data);
} @Teardown

//-----------------------------------------------------------------------------------------------

init_tree_root_only_test :: ()
{
    setup := context.setup_data.(*Setup_Data);
    using setup;

    Verifai.is_not_null(tree);
    Verifai.is_not_null(tree.root);
    Verifai.is_not_null(*tree.root.data);
    Verifai.are_equal(tree.root.data.index, 0);
} @Test

//-----------------------------------------------------------------------------------------------

free_root_root_only_test :: ()
{
    setup := context.setup_data.(*Setup_Data);
    using setup;

    BSP.free_all_nodes(tree);

    Verifai.is_null(tree.root);
} @Test

//-----------------------------------------------------------------------------------------------

free_tree_root_only_test :: ()
{
    setup := context.setup_data.(*Setup_Data);
    using setup;

    BSP.free_tree(tree);

    Verifai.is_true(true);
} @Test

//-----------------------------------------------------------------------------------------------

find_leaf_root_only_passing_test :: (c: Find_Leaf_Root_Only_Passing_Case)
{
    setup := context.setup_data.(*Setup_Data);
    using setup;

    actual_node := BSP.find_leaf_containing_point(tree, c.x, c.y, node_contains_point);

    Verifai.is_not_null(actual_node);
    Verifai.are_equal(actual_node.data.index, c.expected_node_index);
} @Test

//-----------------------------------------------------------------------------------------------

Find_Leaf_Root_Only_Passing_Case :: struct
{
    x, y: float;
    expected_node_index: int;
}

Find_Leaf_Root_Only_Passing_Cases: [] Find_Leaf_Root_Only_Passing_Case = .[
    .{x = 960, y = 540, expected_node_index = 0},
    .{x = 0, y = 0, expected_node_index = 0},
    .{x = 1919, y = 1079, expected_node_index = 0},
];

//-----------------------------------------------------------------------------------------------

find_leaf_root_only_failing_test :: (c: Find_Leaf_Root_Only_Failing_Case)
{
    setup := context.setup_data.(*Setup_Data);
    using setup;

    actual_node := BSP.find_leaf_containing_point(tree, c.x, c.y, node_contains_point);

    Verifai.is_null(actual_node);
} @Test

Find_Leaf_Root_Only_Failing_Case :: struct
{
    x, y: float;
}

Find_Leaf_Root_Only_Failing_Cases: [] Find_Leaf_Root_Only_Failing_Case = .[
    .{x = -1, y = -1},
    .{x = 1920, y = 0},
    .{x = 1920, y = 1080},
];

//-----------------------------------------------------------------------------------------------

find_leaf_with_path_root_only_passing_test :: (c: Find_Leaf_With_Path_Root_Only_Passing_Case)
{
    setup := context.setup_data.(*Setup_Data);
    using setup;

    path: [..] type_of(tree.root);
    actual_node := BSP.find_leaf_containing_point(tree, c.x, c.y, node_contains_point, path = *path);

    path_indices := map(path, x => x.data.index);

    Verifai.is_not_null(actual_node);
    Verifai.are_equal(actual_node.data.index, c.expected_node_index);
    Verifai.are_equal(path_indices, c.expected_path_indices, array_comparator);
} @Test

Find_Leaf_With_Path_Root_Only_Passing_Case :: struct
{
    x, y: float;
    expected_node_index: int;
    expected_path_indices: [] int;
}

Find_Leaf_With_Path_Root_Only_Passing_Cases: [] Find_Leaf_With_Path_Root_Only_Passing_Case = .[
    .{x = 960, y = 540, expected_node_index = 0, expected_path_indices = .[]},
    .{x = 0, y = 0, expected_node_index = 0, expected_path_indices = .[]},
    .{x = 1919, y = 1079, expected_node_index = 0, expected_path_indices = .[]},
];

//-----------------------------------------------------------------------------------------------

#scope_file

Verifai :: #import "Verifai";
#import "Basic";
BSP :: #import "BSP";
