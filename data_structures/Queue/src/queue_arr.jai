enqueue :: (using queue: *$Q/Queue, item: Q.T)
{
    array_add(*items, item);
}

dequeue :: (using queue: *$Q/Queue) -> (ok: bool, item: Q.T)
{
    if items.count == 0 return false, .{};
    item := Array_Helpers.ordered_remove_by_index_and_return(*items, 0);
    return true, item;
}

peek :: (using queue: *$Q/Queue) -> (ok: bool, item: Q.T)
{
    if items.count == 0 return false, .{};
    return true, items[0];
}


free_queue_data :: (using queue: *Queue)
{
    array_free(items);
}

count :: (using queue: *Queue) -> int
{
    return items.count;
}

#scope_file
#import "Basic";
Array_Helpers :: #import "Array_Helpers";
