open Unix

let start =
    (times ()).tms_utime

let stop t =
    (times ()).tms_utime -. t
