// This module implements breadth-first search (BFS) over a generic graph, using a Queue to store frontier nodes.

// By default, this BFS implementation uses a Hash_Table to store the visited set and predecessor nodes.
// However, if your graph nodes are well-represented by a dense collection of integers (ie consecutive node ids), using arrays to store the visited and predecessor nodes may offer performance benefits.
// Just enable the USE_ARR_BACKING module parameter to switch to the array implementation.

#module_parameters(USE_ARR_BACKING := false);

#if USE_ARR_BACKING #load "src/bfs_arr.jai";
else #load "src/bfs_hash_table.jai";
