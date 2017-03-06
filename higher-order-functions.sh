# Much like the Lisp `filter` function, takes a list of lines on STDIN and prints to STDOUT only the lines where the command passed in ($@) returns a TRUE (0) error code.
function filter() {
    xargs -I{} sh -c "$@ '{}' && echo '{}'"
}

# The opposite of `filter`.
function reject() {
    xargs -I{} sh -c "$@ '{}' || echo '{}'"
}
