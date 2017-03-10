# Much like the Lisp `filter` function, takes a list of lines on STDIN and prints to STDOUT only the lines where the command passed in ($@) returns a TRUE (0) error code.
function filter() {
    if [ "$(type -t $1)" == 'file' ]; then
        xargs -I{} sh -c "$@ '{}' && echo '{}'"
    else
        local IFS=$'\n'
        for line in $(cat /dev/stdin) ; do
            $@ $line && echo $line
        done
    fi
}

# The opposite of `filter`.
function reject() {
    if [ "$(type -t $1)" == 'file' ]; then
        xargs -I{} sh -c "$@ '{}' || echo '{}'"
    else
        local IFS=$'\n'
        for line in $(cat /dev/stdin) ; do
            $@ $line || echo $line
        done
    fi
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
