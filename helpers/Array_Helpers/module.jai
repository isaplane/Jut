map :: (array: [] $T, f: (T) -> $S) -> [..] S 
{
    results: [..] S;
    for array array_add(*results, f(it));
    return results;
}

arrays_are_equal :: (a: [] $T, b: [] T) -> bool
{
    return arrays_are_equal(a, b, (a, b) => a == b);
}

arrays_are_equal :: (a: [] $T, b: [] T, comparator: (T, T) -> bool) -> bool
{
    if a.count != b.count return false;
    for 0 .. a.count - 1
    {
        if !comparator(a[it], b[it]) return false;
    }

    return true;
}

#scope_file
#import "Basic";
