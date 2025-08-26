Queue_Test_Data :: struct
{
    index: int;
}

//-----------------------------------------------------------------------------------------------

create_new_array_backed_queue_test :: ()
{
    Q :: #import "Queue";
    queue := Q.get_new_queue(Queue_Test_Data);

    Verifai.is_not_null(queue);
    Verifai.is_null(queue.items.data);
    Verifai.are_equal(queue.items.count, 0);
} @Test

//-----------------------------------------------------------------------------------------------

create_new_ll_backed_queue_test :: ()
{
    Q :: #import "Queue"(USE_LL_BACKING = true);
    queue := Q.get_new_queue(Queue_Test_Data);

    Verifai.is_not_null(queue);
    Verifai.is_null(queue.head);
    Verifai.is_null(queue.tail);
    Verifai.are_equal(queue.count, 0);
} @Test

//-----------------------------------------------------------------------------------------------

create_and_free_array_backed_empty_queue_test :: ()
{
    Q :: #import "Queue";
    queue := Q.get_new_queue(Queue_Test_Data);

    Q.free_queue(queue);
    Verifai.is_true(true);
} @Test

//-----------------------------------------------------------------------------------------------

create_and_free_ll_backed_empty_queue_test :: ()
{
    Q :: #import "Queue"(USE_LL_BACKING = true);
    queue := Q.get_new_queue(Queue_Test_Data);

    Q.free_queue(queue);
    Verifai.is_true(true);
} @Test

//-----------------------------------------------------------------------------------------------

create_and_free_array_backed_nonempty_queue_test :: ()
{
    Q :: #import "Queue";
    queue := Q.get_new_queue(Queue_Test_Data);

    Verifai.is_true(Q.is_empty(queue));

    Q.free_queue(queue);
    Verifai.is_true(true);
} @Test

//-----------------------------------------------------------------------------------------------

create_and_free_ll_backed_nonempty_queue_test :: ()
{
    Q :: #import "Queue"(USE_LL_BACKING = true);
    queue := Q.get_new_queue(Queue_Test_Data);

    Verifai.is_true(Q.is_empty(queue));

    Q.free_queue(queue);
    Verifai.is_true(true);
} @Test

#scope_file
Verifai :: #import "Verifai";
#import "Basic";
