#!/bin/bash
# Here you can create functions which will be available from the commands file
# You can also use here user variables defined in your config file
# To avoid conflicts, name your function like this
# pg_XX_myfunction () { }
# pg for PluGin
# XX is a short code for your plugin, ex: ww for Weather Wunderground
# You can use translations provided in the language folders functions.sh
#!/bin/bash
pg_jh_turn () {
    # $1: action [on|off]
    # $2: received order
    local -r order="$(jv_sanitize "$2")"
    while read device; do
        local sdevice="$(jv_sanitize "$device" ".*")"
        if [[ "$order" =~ .*$sdevice.* ]]; then
            local address="$(echo $pg_jh_config | jq -r ".devices[] | select(.name==\"$device\") | .address")"
            say "$(pg_jh_lg "switching_$1" "$2")"
            heyu $1 $address
            return $?
        fi
    done <<< "$(echo $pg_jh_config | jq -r '.devices[].name')"
    say "$(pg_jh_lg "no_device_matching" "$2")"
    return 1
}

