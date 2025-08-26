Filled_LL_Queue_Test_Data :: struct
{
    id: int;
    name: string;
}

Filled_LL_Queue_Setup_Data :: struct
{
    queue: *Q.Queue(Filled_LL_Queue_Test_Data);
}

setup_filled_ll_queue_tests :: ()
{
    setup := New(Filled_LL_Queue_Setup_Data);
    setup.queue = Q.get_new_queue(Filled_LL_Queue_Test_Data);
    
    Q.enqueue(setup.queue, .{id = 1, name = "one"});
    Q.enqueue(setup.queue, .{id = 2, name = "two"});
    Q.enqueue(setup.queue, .{id = 3, name = "three"});

    context.setup_data = setup;
} @Setup

teardown_filled_ll_queue_tests :: ()
{
    using setup := context.setup_data.(*Filled_LL_Queue_Setup_Data);
    Q.free_queue(queue);
    free(setup);
} @Teardown

//-----------------------------------------------------------------------------------------------

init_filled_ll_queue_test :: ()
{
    using setup := context.setup_data.(*Filled_LL_Queue_Setup_Data);
    
    Verifai.is_not_null(queue);
    Verifai.is_false(Q.is_empty(queue));
    Verifai.are_equal(Q.count(queue), 3);
} @Test

//-----------------------------------------------------------------------------------------------

peek_filled_ll_queue_test :: ()
{
    using setup := context.setup_data.(*Filled_LL_Queue_Setup_Data);

    ok, item := Q.peek(queue);

    Verifai.is_true(ok);
    Verifai.are_equal(item.id, 1);
    Verifai.are_equal(item.name, "one");
    Verifai.are_equal(Q.count(queue), 3);
} @Test

//-----------------------------------------------------------------------------------------------

Dequeue_Filled_LL_Test_Case :: struct
{
    dequeue_count: int;
    expected_id:   int;
    expected_name: string;
}

dequeue_filled_ll_test_cases: [] Dequeue_Filled_LL_Test_Case = .[
    .{1, 1, "one"},
    .{2, 2, "two"},
    .{3, 3, "three"},
]; 

dequeue_filled_ll_queue_test :: (c: Dequeue_Filled_LL_Test_Case)
{
    using setup := context.setup_data.(*Filled_LL_Queue_Setup_Data);

    ok: bool;
    last_item: Filled_LL_Queue_Test_Data;
    for 0..c.dequeue_count - 1
    {
        ok, last_item = Q.dequeue(queue);
        Verifai.is_true(ok);
    }

    Verifai.are_equal(last_item.id, c.expected_id);
    Verifai.are_equal(last_item.name, c.expected_name);
    Verifai.are_equal(Q.count(queue), 3 - c.dequeue_count);
} @Test

//-----------------------------------------------------------------------------------------------

dequeue_filled_ll_queue_until_empty_test :: ()
{
    using setup := context.setup_data.(*Filled_LL_Queue_Setup_Data);

    ok, item := Q.dequeue(queue);
    ok, item  = Q.dequeue(queue);
    ok, item  = Q.dequeue(queue);


    Verifai.is_true(Q.is_empty(queue));
    
    ok, item  = Q.dequeue(queue);
    Verifai.is_false(ok);
} @Test


#scope_file
Verifai :: #import "Verifai";
Q :: #import "Queue"(USE_LL_BACKING = true);
