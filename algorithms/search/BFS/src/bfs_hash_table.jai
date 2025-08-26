Procs :: struct(T: Type)
{
    get_neighbors: (T) -> ([] T);
    compare_nodes: (T, T) -> bool;
}

breadth_first_search :: (start: $T, target: T, using procs: Procs(T)) -> found: bool, path: [..] T
{
    path: [..] T;

    if compare_nodes(start, target)
    {
        array_add(*path, start);
        return true, path;
    }

    queue := Q.get_new_queue(T);
    defer Q.free_queue(queue);

    came_from: Table(T, T);
    init(*came_from);
    defer deinit(*came_from);

    Q.enqueue(queue, start);
    table_add(*came_from, start, start);

    while !Q.is_empty(queue)
    {
        ok, curr := Q.dequeue(queue);
        if !ok break;

        neighbors := get_neighbors(curr);
        for n: neighbors
        {
            found, _ := table_find_new(*came_from, n);
            if found continue;

            table_add(*came_from, n, curr);
            Q.enqueue(queue, n);

            if compare_nodes(n, target)
            {
                reconstruct_path(*path, came_from, start, target);
                return true, path;
            }
        }
    }

    return false, path;
}

#scope_file

reconstruct_path :: (path: *[..] T, came_from: Table($T, T), start: T, target: T)
{
    curr := target;
    while curr != start
    {
        array_add(path, curr);
        ok, prev := table_find_new(*came_from, curr);
        assert(ok, "Bad table search. Node not found.\n");
        curr = prev;
    }

    array_add(path, start);
    Array_Helpers.reverse_in_place(path);
}

#import "Basic";
#import "Hash_Table";
Q :: #import "Queue";
Array_Helpers :: #import "Array_Helpers";
