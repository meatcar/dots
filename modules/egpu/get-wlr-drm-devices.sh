# Inspired by https://github.com/swaywm/wlroots/issues/1923
# Prefer amd, since nvidia could be an internal dgpu on laptops
# TODO: make order customizeable

debug () {
    echo "$(basename "$0"):" "$@" >&2
}

if [ "$(find /dev/dri -name 'card*' | wc -l)" -lt 2 ]; then
    debug "$0: No eGPU detected"
    echo /dev/dri/card0
else
    debug "Probable eGPU detected"
    for card in /dev/dri/card*; do
        drivers=$(udevadm info -a -n "$card" | grep DRIVERS | sort | uniq)
        debug "$card"
        debug "$(echo "$drivers" | tr -d '\n' | sed 's/ \+/ /g')"
        if echo "$drivers" | grep -q i915; then
            intel=$card
        elif echo "$drivers" | grep -q amdgpu; then
            amd=$card
        else
            nvidia=$card
        fi
    done
    printf "%s\n" "$amd" "$nvidia" "$intel" | sed '/^$/d' | paste -sd:
fi
