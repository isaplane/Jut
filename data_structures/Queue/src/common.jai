#if USE_LL_BACKING 
{
    Node :: struct(T: Type)
    {
        item: T;
        next: *Node(T);
    }

    Queue_Linked_List :: struct(T: Type)
    {
        head: *Node(T);
        tail: *Node(T);
        count: int;
    }

    Queue :: struct(T: Type)
    {
        #as using,except(T) backing: Queue_Linked_List(T);
        allocator: Allocator;
    }
}

else
{
    Queue_Array :: struct(T: Type)
    {
        items: [..] T;
    }

    Queue :: struct(T: Type)
    {
        #as using,except(T) backing: Queue_Array(T);
        allocator: Allocator;
    }
}

get_new_queue :: ($T: Type, allocator := context.allocator) -> *Queue(T)
{
    q := New(Queue(T),, allocator);
    q.allocator = allocator;
    return q;
}

free_queue :: (queue: *Queue)
{
    free_queue_data(queue,, queue.allocator);
    free(queue,, queue.allocator);
}

is_empty :: (queue: *Queue) -> bool
{
    return count(queue) == 0;
}

#scope_file
#import "Basic";
