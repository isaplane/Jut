BFS_Arr_Graph :: struct
{
    adj: [..] [..] int;
}

BFS_Arr_Setup_Data :: struct
{
    graph: *BFS_Arr_Graph;
}

get_neighbors :: (node_id: int) -> [] int
{
    using setup := context.setup_data.(*BFS_Arr_Setup_Data);
    return graph.adj[node_id];
}

setup_bfs_arr_tests :: ()
{
    setup := New(BFS_Arr_Setup_Data);
    setup.graph = New(BFS_Arr_Graph);
    array_resize(*setup.graph.adj, 7);

    adj := setup.graph.adj;
    array_add(*adj[0], 1);
    array_add(*adj[0], 2);
    array_add(*adj[1], 3);
    array_add(*adj[2], 4);
    array_add(*adj[3], 5);
    array_add(*adj[4], 1);
    array_add(*adj[4], 6);

    context.setup_data = setup;
} @Setup

teardown_bfs_arr_tests :: ()
{
    using setup := context.setup_data.(*BFS_Arr_Setup_Data);

    for *graph.adj array_free(it.*);

    array_free(graph.adj);
    free(graph);
    free(setup);
} @Teardown

//-----------------------------------------------------------------------------------------------

Find_Path_Arr_Test_Case :: struct
{
    start_idx:         int;
    target_idx:        int;
    expected_found:    bool;
    expected_path_ids: [] int;
}

find_path_arr_test_cases: [] Find_Path_Arr_Test_Case = .[
    .{0, 0, true, .[0]},
    .{0, 2, true, .[0, 2]},
    .{0, 5, true, .[0, 1, 3, 5]},
    .{2, 3, true, .[2, 4, 1, 3]},
    .{4, 6, true, .[4, 6]},
    .{5, 0, false, .[]},
];

find_path_arr_test :: (c: Find_Path_Arr_Test_Case)
{
    using setup := context.setup_data.(*BFS_Arr_Setup_Data);
    num_nodes := graph.adj.count;

    found, path := BFS.breadth_first_search(c.start_idx, c.target_idx, get_neighbors, num_nodes);
    defer array_free(path);

    comparator := #procedure_of_call Array_Helpers.arrays_are_equal(int.[], int.[]);

    Verifai.are_equal(found, c.expected_found);
    Verifai.are_equal(path, c.expected_path_ids, comparator);
} @Test


#scope_file
#import "Basic";
Verifai :: #import "Verifai";
BFS :: #import "BFS"(USE_ARR_BACKING = true);
Array_Helpers :: #import "Array_Helpers";
