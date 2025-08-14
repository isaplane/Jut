setup_one_gen_tests :: ()
{
    setup := New(Setup_Data_One_Bisect);
    setup.tree = BSP.get_new_tree(Node_Data.{
        index = 0,
        rect = .{0, 0, 1920, 1080}
    });
    ok, left, right := BSP.bisect_node(setup.tree, setup.tree.root,
                                        .{index = 1, rect = .{0, 0, 960, 1080}},
                                        .{index = 2, rect = .{960, 0, 960, 1080}});

    assert(ok, "Bad bisect in setup.\n");

    setup.left = left;
    setup.right = right;

    context.setup_data = setup;
} @Setup

teardown_one_gen_tests :: ()
{
    free(context.setup_data);
} @Teardown

init_tree_one_gen_test :: ()
{
    setup := context.setup_data.(*Setup_Data_One_Bisect);
    using setup;

    Verifai.is_not_null(tree);
    Verifai.is_not_null(tree.root);
    Verifai.is_not_null(*tree.root.data);
    Verifai.are_equal(tree.root.data.index, 0);
} @Test

check_bisect_one_gen_test :: ()
{
    setup := context.setup_data.(*Setup_Data_One_Bisect);
    using setup;

    Verifai.is_not_null(tree.root.left);
    Verifai.is_not_null(tree.root.right);
    Verifai.are_equal(tree.root.left, left);
    Verifai.are_equal(tree.root.right, right);
    Verifai.are_equal(tree.root.left.data.index, 1);
    Verifai.are_equal(tree.root.right.data.index, 2);
} @Test

free_left_one_gen_test :: ()
{
    setup := context.setup_data.(*Setup_Data_One_Bisect);
    using setup;

    BSP.free_node_and_children(tree, tree.root.left);

    Verifai.is_null(tree.root.left);

    Verifai.is_not_null(tree.root);
    Verifai.is_not_null(tree.root.right);
} @Test

free_right_one_gen_test :: ()
{
    setup := context.setup_data.(*Setup_Data_One_Bisect);
    using setup;

    BSP.free_node_and_children(tree, tree.root.right);

    Verifai.is_null(tree.root.right);

    Verifai.is_not_null(tree.root);
    Verifai.is_not_null(tree.root.left);
} @Test

free_root_one_gen_test :: ()
{
    setup := context.setup_data.(*Setup_Data_One_Bisect);
    using setup;

    BSP.free_all_nodes(tree);

    Verifai.is_null(tree.root);
} @Test

free_tree_one_gen_test :: ()
{
    setup := context.setup_data.(*Setup_Data_One_Bisect);
    using setup;

    BSP.free_tree(tree);

    Verifai.is_true(true);
} @Test

//-----------------------------------------------------------------------------------------------

find_leaf_one_gen_passing_test :: (c: Find_Leaf_One_Gen_Passing_Case)
{
    setup := context.setup_data.(*Setup_Data_One_Bisect);
    using setup;

    actual_node := BSP.find_leaf_containing_point(tree, c.x, c.y, node_contains_point);

    Verifai.is_not_null(actual_node);
    Verifai.are_equal(actual_node.data.index, c.expected_node_index);
} @Test

Find_Leaf_One_Gen_Passing_Case :: struct
{
    x, y: float;
    expected_node_index: int;
}

Find_Leaf_One_Gen_Passing_Cases: [] Find_Leaf_One_Gen_Passing_Case = .[
    .{x = 959, y = 539, expected_node_index = 1},
    .{x = 960, y = 540, expected_node_index = 2},
    .{x = 0, y = 0, expected_node_index = 1},
    .{x = 1919, y = 1079, expected_node_index = 2},
];

//-----------------------------------------------------------------------------------------------

find_leaf_one_gen_failing_test :: (c: Find_Leaf_One_Gen_Failing_Case)
{
    setup := context.setup_data.(*Setup_Data_One_Bisect);
    using setup;

    actual_node := BSP.find_leaf_containing_point(tree, c.x, c.y, node_contains_point);

    Verifai.is_null(actual_node);
} @Test

Find_Leaf_One_Gen_Failing_Case :: struct
{
    x, y: float;
}

Find_Leaf_One_Gen_Failing_Cases: [] Find_Leaf_One_Gen_Failing_Case = .[
    .{x = -1, y = -1},
    .{x = 1920, y = 0},
    .{x = 1920, y = 1080},
];

//-----------------------------------------------------------------------------------------------

find_leaf_with_path_one_gen_passing_test :: (c: Find_Leaf_With_Path_One_Gen_Passing_Case)
{
    setup := context.setup_data.(*Setup_Data_One_Bisect);
    using setup;

    path: [..] type_of(tree.root);
    actual_node := BSP.find_leaf_containing_point(tree, c.x, c.y, node_contains_point, path = *path);

    path_indices := map(path, x => x.data.index);

    Verifai.is_not_null(actual_node);
    Verifai.are_equal(actual_node.data.index, c.expected_node_index);
    Verifai.are_equal(path_indices, c.expected_path_indices, array_comparator);
} @Test

Find_Leaf_With_Path_One_Gen_Passing_Case :: struct
{
    x, y: float;
    expected_node_index: int;
    expected_path_indices: [] int;
}

Find_Leaf_With_Path_One_Gen_Passing_Cases: [] Find_Leaf_With_Path_One_Gen_Passing_Case = .[
    .{x = 959, y = 539, expected_node_index = 1, expected_path_indices = .[0]},
    .{x = 960, y = 540, expected_node_index = 2, expected_path_indices = .[0]},
    .{x = 0, y = 0, expected_node_index = 1, expected_path_indices = .[0]},
    .{x = 1919, y = 1079, expected_node_index = 2, expected_path_indices = .[0]},
];

//-----------------------------------------------------------------------------------------------

#scope_file
Verifai :: #import "Verifai";
#import "Basic";
BSP :: #import "BSP";
