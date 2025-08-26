map :: (array: [] $T, f: (T) -> $S) -> [..] S 
{
    results: [..] S;
    for array array_add(*results, f(it));
    return results;
}

arrays_are_equal :: (a: [] $T, b: [] T) -> bool
{
    return arrays_are_equal(a, b, (x, y) => x == y);
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

contains :: (a: [] $T, t: T) -> bool
{
    return contains(a, t, (x, y) => x == y);
}

contains :: (a: [] $T, t: T, comparator: (T, T) -> bool) -> bool
{
    for a
    {
        if comparator(it, t) return true;
    }
    return false;
}

ordered_remove_by_index_and_return :: (array_pointer: *[] $T, index: s64) -> T
{
    assert(index >= 0);
    assert(index < array_pointer.count);

    result := array_pointer.*[index];
    array_ordered_remove_by_index(array_pointer, index);
    return result;
}

#scope_file
#import "Basic";
