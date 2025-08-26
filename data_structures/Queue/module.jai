// Generic Queue data structure
// The default module configuration uses an array-backed queue.
// Set the module parameter USE_LL_BACKING to true to switch to a linked list.

#load "src/common.jai";

#module_parameters(USE_LL_BACKING := false);

#if USE_LL_BACKING #load "src/queue_ll.jai";
else #load "src/queue_arr.jai";
