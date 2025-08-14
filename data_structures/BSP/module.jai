// A generic 2D Binary Space Partition (BSP) Tree module.
// This module provides a way to represent a 2D space that is recursively subdivided.

// The tree is polymorphic over the type of data stored in each node.
// This data should, at a minimum, contain some inforation about the partition geometry for that node.
// It is up to the user to provide a contains_point_proc for testing whether a particular point exists inside a partition node.

Tree :: struct(Node_Type: Type)
{
    root:      *Node_Type;
    allocator: Allocator;
}

Node :: struct(Data_Type: Type)
{
    data:   Data_Type;

    parent: *Node(Data_Type);
    left:   *Node(Data_Type);
    right:  *Node(Data_Type);
}

get_new_tree :: (root_data: $Data_Type, allocator := context.allocator) -> *Tree(Node(Data_Type)) 
{
    T :: Node(Data_Type);
    root := New(T,, allocator);
    root.data  = root_data;

    tree := New(Tree(T),, allocator);
    tree.root = root;
    tree.allocator = allocator;
    return tree;
}

free_node_and_children :: (tree: *Tree, node: *Node)
{
    if !node return;

    free_node_and_children(tree, node.left);
    free_node_and_children(tree, node.right);
    defer free(node,, tree.allocator);

    // In case this is the root node.
    if !node.parent return;

    if node.parent.left == node node.parent.left = null;
    else if node.parent.right == node node.parent.right = null;
    return;
}

free_all_nodes :: (tree: *Tree)
{
    if !tree.root
    {
        log_error("Bad tree root = null.\n");
        return;
    }

    free_node_and_children(tree, tree.root);
    tree.root = null;
}

free_tree :: (tree: *Tree)
{
    if !tree
    {
        log_error("Bad tree = null.\n");
        return;
    }

    free_node_and_children(tree, tree.root);
    free(tree,, tree.allocator);
}

bisect_node :: (tree: *Tree, node: *$N/Node, left_data: N.Data_Type, right_data: N.Data_Type) -> bool, *N, *N
{
    if node.left || node.right
    {
        log_error("Bad bisect. Internal node instead of leaf.\n");
        return false, null, null;
    }

    left := New(N,, tree.allocator);
    left.data = left_data;
    left.parent = node;

    right := New(N,, tree.allocator);
    right.data = right_data;
    right.parent = node;

    node.left = left;
    node.right = right;

    return true, left, right;
}

// Provide a pointer to a resizeable array to get the full path to the leaf node (starting from root, leaf not included)
find_leaf_containing_point :: (using tree: *$T/Tree, x: $V, y: V, 
                      contains_point_proc: (T.Node_Type.Data_Type, V, V) -> bool, 
                      path: *[..] *T.Node_Type = null) -> *T.Node_Type
{
    if !root
    {
        log_error("Bad root = null.\n");
        return null;
    }

    if !contains_point_proc(root.data, x, y)
    {
        log_error("Bad point, not found in root.\n");
        return null;
    }

    curr := root;
    while curr.left
    {
        if path array_add(path, curr);

        if contains_point_proc(curr.left.data, x, y)
            curr = curr.left;
        else if contains_point_proc(curr.right.data, x, y)
            curr = curr.right;
        else break;
    }

    return curr;
}

#scope_module

#import "Basic";
