enqueue :: (using queue: *$Q/Queue, item: Q.T)
{
    N :: Node(Q.T);
    node := New(N,, allocator);
    node.item = item;

    if tail tail.next = node;
    else head = node;

    tail = node;
    count += 1;
}

dequeue :: (using queue: *$Q/Queue) -> (ok: bool, item: Q.T)
{
    item: Q.T;
    if !head return false, item;

    deq_node := head;
    item = deq_node.item;

    head = deq_node.next;
    if !head tail = null;

    free(deq_node,, allocator);
    count -= 1;

    return true, item;
}

peek :: (using queue: *$Q/Queue) -> (ok: bool, item: Q.T)
{
    item: Q.T;
    if !head return false, item;

    return true, head.item;
}

free_queue_data :: (using queue: *Queue)
{
    curr := head;
    while curr
    {
        next := curr.next;
        free(curr);
        curr = next;
    }
}

count :: (using queue: *Queue) -> int
{
    return count;
}

#scope_file
#import "Basic";
