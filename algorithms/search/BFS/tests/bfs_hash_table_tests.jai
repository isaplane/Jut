BFS_HT_Graph_Node :: struct
{
    id: int;
    neighbors: [..] *BFS_HT_Graph_Node;
}

BFS_HT_Graph :: struct
{
    nodes: [..] *BFS_HT_Graph_Node;
}

BFS_HT_Setup_Data :: struct
{
    graph: *BFS_HT_Graph;
    procs: BFS.Procs(*BFS_HT_Graph_Node);
}

setup_bfs_ht_tests :: ()
{
    setup := New(BFS_HT_Setup_Data);
    setup.graph = New(BFS_HT_Graph);

    for 1..7
    {
        node := New(BFS_HT_Graph_Node);
        node.id = it;
        array_add(*setup.graph.nodes, node);
    }

    nodes := setup.graph.nodes;
    array_add(*nodes[0].neighbors, nodes[1]);
    array_add(*nodes[0].neighbors, nodes[2]);
    array_add(*nodes[1].neighbors, nodes[3]);
    array_add(*nodes[2].neighbors, nodes[4]);
    array_add(*nodes[3].neighbors, nodes[5]);
    array_add(*nodes[4].neighbors, nodes[1]);
    array_add(*nodes[4].neighbors, nodes[6]);

    get_neighbors :: (node: *BFS_HT_Graph_Node) -> [] *BFS_HT_Graph_Node
    {
        return node.neighbors;
    }

    compare_nodes :: (a: *BFS_HT_Graph_Node, b: *BFS_HT_Graph_Node) -> bool
    {
        return a.id == b.id;
    }

    setup.procs = .{
        get_neighbors,
        compare_nodes,
    };

    context.setup_data = setup;
} @Setup

teardown_bfs_ht_tests :: ()
{
    using setup := context.setup_data.(*BFS_HT_Setup_Data);
    for graph.nodes
    {
        array_free(it.neighbors);
        free(it);
    }

    array_free(graph.nodes);
    free(graph);
    free(setup);
} @Teardown

//-----------------------------------------------------------------------------------------------

Find_Path_HT_Test_Case :: struct
{
    start_idx:         int;
    target_idx:        int;
    expected_found:    bool;
    expected_path_ids: [] int;
}

find_path_ht_test_cases: [] Find_Path_HT_Test_Case = .[
    .{0, 0, true, .[1]},
    .{0, 2, true, .[1, 3]},
    .{0, 5, true, .[1, 2, 4, 6]},
    .{2, 3, true, .[3, 5, 2, 4]},
    .{4, 6, true, .[5, 7]},
    .{5, 0, false, .[]},
];

find_path_ht_test :: (c: Find_Path_HT_Test_Case)
{
    using setup := context.setup_data.(*BFS_HT_Setup_Data);

    start := graph.nodes[c.start_idx];
    target := graph.nodes[c.target_idx];

    found, path := BFS.breadth_first_search(start, target, procs);
    defer array_free(path);

    compare_paths :: (found_path: [] *BFS_HT_Graph_Node, expected_path_ids: [] int) -> bool
    {
        found_path_ids := Array_Helpers.map(found_path, x => x.id);
        return Array_Helpers.arrays_are_equal(found_path_ids, expected_path_ids);
    }

    Verifai.are_equal(found, c.expected_found);
    Verifai.is_true(compare_paths(path, c.expected_path_ids));
} @Test


#scope_file
#import "Basic";
Verifai :: #import "Verifai";
BFS :: #import "BFS";
Array_Helpers :: #import "Array_Helpers";
