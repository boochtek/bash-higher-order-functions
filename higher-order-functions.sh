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

# Run a command until it succeeds. The 1st argument is how many times to run it; the 2nd is how many seconds between runs; the rest is the command.
# TODO: Add an option to supress STDOUT/STDERR.
# TODO: Add an option to indicate progress (dots or spinner).
function poll() {
    if [ "$#" -lt '3' ]; then
        echo 1>&2 "USAGE: $0 n i command - run command n times, every i seconds, until command succeeds"
    fi

    local tries=1
    local max_tries="$1"
    local wait="$2"
    shift; shift  # Leaves the command to run in `$@`.


    if "$@" ; then
        return 0
    fi
    while [ "$tries" -lt "$max_tries" ]; do
        sleep $wait
        if "$@" ; then
            return 0
        fi
        (( tries++ ))
    done
    
    return 1
}
