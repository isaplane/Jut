cut_rect   :: () -> int, int { return 0, 0;}
check_rect :: () -> int { return 0; }

layout :: ()
{
    foo, bar := cut_rect();
}

layout_2 :: ()
{
    fuzz, _ := cut_rect();
}

layout_3 :: ()
{
    fah, baz: int;
    fah, baz = cut_rect();
}

layout_4 :: ()
{
    fuh: int;
    fuh = check_rect();
}

layout_5 :: ()
{
    foh := check_rect();
}
