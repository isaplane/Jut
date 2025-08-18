find_procedure_calls_by_name_cut_rect :: () -> int, int { return 0, 0;}
find_procedure_calls_by_name_return_rect :: () -> int { return 0;}
find_procedure_calls_by_name_layout :: ()
{
    foo, bar := find_procedure_calls_by_name_cut_rect();
    Foo, Bar := find_procedure_calls_by_name_cut_rect();
    fee, bee := find_procedure_calls_by_name_cut_rect();
}

find_procedure_calls_by_name_check_rect :: () {}
find_procedure_calls_by_name_second_layout :: ()
{
    find_procedure_calls_by_name_check_rect();
    find_procedure_calls_by_name_check_rect();
    find_procedure_calls_by_name_check_rect();
}

find_procedure_calls_by_name_third_layout :: ()
{
    foo: int;
    foo = find_procedure_calls_by_name_return_rect();
    foo = find_procedure_calls_by_name_return_rect();
    foo = find_procedure_calls_by_name_return_rect();
}

find_procedure_calls_by_name_fourth_layout :: ()
{
    bar: int;
    foo:, bar = find_procedure_calls_by_name_cut_rect();
    Foo:, bar = find_procedure_calls_by_name_cut_rect();
    FOO:, bar = find_procedure_calls_by_name_cut_rect();
}

find_procedure_calls_by_name_fifth_layout :: ()
{
    foo, bar: int;
    foo, bar = find_procedure_calls_by_name_cut_rect();
    foo, bar = find_procedure_calls_by_name_cut_rect();
    foo, bar = find_procedure_calls_by_name_cut_rect();
}

find_procedure_calls_by_name_sixth_layout :: ()
{
    foo := find_procedure_calls_by_name_return_rect();
    Foo := find_procedure_calls_by_name_return_rect();
    FOO := find_procedure_calls_by_name_return_rect();
}
