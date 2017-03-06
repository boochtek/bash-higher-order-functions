# Much like the Lisp `filter` function, takes a list of lines on STDIN and prints to STDOUT only the lines where the command passed in ($@) returns a TRUE (0) error code.
function filter() {
    xargs -I{} sh -c "$@ '{}' && echo '{}'"
}

# The opposite of `filter`.
function reject() {
    xargs -I{} sh -c "$@ '{}' || echo '{}'"
}

# Run a command, ignoring errors temporarily. Alternatively, give not options to ignore all errors going forward, or `--off` to terminate on errors going forward.
function ignore_errors() {
    if [ "$@" == "" ]; then
        set +e
    elif [ "$@" == "--off" ]; then
        set -e
    elif echo $SHELLOPTS | grep -q 'errexit' ; then
        set +e
        $@
        set -e
    else
        $@
    fi
}
