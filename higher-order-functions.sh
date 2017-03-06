# Much like the Lisp `filter` function, takes a list of lines on STDIN and prints to STDOUT only the lines where the command passed in ($@) returns a TRUE (0) error code.
function filter() {
    local IFS=$'\n'
    for line in $(cat /dev/stdin) ; do
        $@ $line && echo $line
    done
}

# The opposite of `filter`.
function reject() {
    local IFS=$'\n'
    for line in $(cat /dev/stdin) ; do
        $@ $line || echo $line
    done
}

# Run a command, ignoring errors temporarily. Alternatively, give no arguments to ignore all errors going forward, or `--off` to terminate on errors going forward.
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
