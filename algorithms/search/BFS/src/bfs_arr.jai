breadth_first_search :: (start: int, target: int, get_neighbors: (int) -> ([] int), num_nodes: int) -> found: bool, path: [..] int
{
    assert(start >= 0 && start < num_nodes, "Bad start. Out of range (0 <= x < num_nodes).\n");
    assert(target >= 0 && start < num_nodes, "Bad target. Out of range (0 <= x < num_nodes).\n");

    path: [..] int;

    if start == target
    {
        array_add(*path, start);
        return true, path;
    }

    queue := Q.get_new_queue(int);
    defer Q.free_queue(queue);

    came_from: [..] int;
    defer array_free(came_from);

    array_resize(*came_from, num_nodes);
    for *came_from it.* = -1;

    Q.enqueue(queue, start);
    came_from[start] = start;

    while !Q.is_empty(queue)
    {
        ok, curr := Q.dequeue(queue);
        if !ok break;

        neighbors := get_neighbors(curr);
        for n: neighbors
        {
            if came_from[n] != -1 continue;

            came_from[n] = curr;
            Q.enqueue(queue, n);

            if n == target
            {
                reconstruct_path(*path, came_from, start, target);
                return true, path;
            }
        }
    }

    return false, path;
}

#scope_file

reconstruct_path :: (path: *[..] int, came_from: [] int, start: int, target: int)
{
    curr := target;
    while curr != start
    {
        array_add(path, curr);
        curr = came_from[curr];
        assert(curr != -1, "Bad predecessor = -1.\n");
    }

    array_add(path, start);
    Array_Helpers.reverse_in_place(path);
}

#import "Basic";
Q :: #import "Queue";
Array_Helpers :: #import "Array_Helpers";
