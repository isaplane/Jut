Empty_Arr_Queue_Test_Data :: struct
{
    id: int;
    name: string;
}

Empty_Arr_Queue_Setup_Data :: struct
{
    queue: *Q.Queue(Empty_Arr_Queue_Test_Data);
}

setup_empty_arr_queue_tests :: ()
{
    setup := New(Empty_Arr_Queue_Setup_Data);
    setup.queue = Q.get_new_queue(Empty_Arr_Queue_Test_Data);
    context.setup_data = setup;
} @Setup

teardown_empty_arr_queue_tests :: ()
{
    using setup := context.setup_data.(*Empty_Arr_Queue_Setup_Data);
    Q.free_queue(queue);
    free(setup);
} @Teardown

//-----------------------------------------------------------------------------------------------

get_new_arr_queue_test :: ()
{
    using setup := context.setup_data.(*Empty_Arr_Queue_Setup_Data);

    Verifai.is_not_null(queue);
    Verifai.is_true(Q.is_empty(queue));
    Verifai.are_equal(Q.count(queue), 0);
} @Test

//-----------------------------------------------------------------------------------------------

enqueue_on_empty_arr_queue_test :: ()
{
    using setup := context.setup_data.(*Empty_Arr_Queue_Setup_Data);

    Q.enqueue(queue, .{id = 10, name = "ten"});

    Verifai.is_false(Q.is_empty(queue));
    Verifai.are_equal(Q.count(queue), 1);
} @Test

//-----------------------------------------------------------------------------------------------

dequeue_on_empty_arr_queue_test :: ()
{
    using setup := context.setup_data.(*Empty_Arr_Queue_Setup_Data);

    ok, item := Q.dequeue(queue);

    Verifai.is_false(ok);
    Verifai.is_true(Q.is_empty(queue));
    Verifai.are_equal(Q.count(queue), 0);
} @Test

#scope_file
Verifai :: #import "Verifai";
Q :: #import "Queue";
