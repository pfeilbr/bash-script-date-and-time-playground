TIMESTAMP_STRING_FORMAT="%Y-%m-%dT%H:%M:%S.000Z"

function epoch_time_from_timestamp_string() {
  local timestamp_string=$1
  local epoch_time=$(date -u -j -f "${TIMESTAMP_STRING_FORMAT}" "${timestamp_string}" "+%s")
  echo $epoch_time
}

function timestamp_string_from_epoch_time() {
    local epoch_time=$1
    local timestamp_string=$(date -u -j -f "%s" "${epoch_time}" "+${TIMESTAMP_STRING_FORMAT}")
    echo $timestamp_string
}

function get_time_spans() {
  local start_time=$1
  local end_time=$2
  local step_in_seconds=$3

  local start_time_epoch=$( epoch_time_from_timestamp_string "${start_time}" )
  local end_time_epoch=$( epoch_time_from_timestamp_string "${end_time}" )
  
  local current_start_time_epoch=$start_time_epoch
  local current_start_timestamp_string=$( timestamp_string_from_epoch_time "${current_start_time_epoch}" )

  local current_end_time_epoch=$(( $start_time_epoch + $step_in_seconds ))
  local current_end_timestamp_string=$( timestamp_string_from_epoch_time "${current_end_time_epoch}" )


  local time_spans=
  while [ $current_start_time_epoch -lt $end_time_epoch ]
  do
    time_spans="${time_spans} ${current_start_timestamp_string},${current_end_timestamp_string}"

    current_start_time_epoch=$(( $current_start_time_epoch + $step_in_seconds ))
    current_start_timestamp_string=$( timestamp_string_from_epoch_time "${current_start_time_epoch}" )

    current_end_time_epoch=$(( $current_end_time_epoch + $step_in_seconds ))
    current_end_timestamp_string=$( timestamp_string_from_epoch_time "${current_end_time_epoch}" )
  done
  
  echo "${time_spans}"
}

START_TIME='2020-02-05T11:45:00.000Z'
END_TIME='2020-02-11T00:00:00.000Z'
SECONDS_IN_DAY=$(( 60*60*24 ))
STEP_IN_SECONDS=$(( $SECONDS_IN_DAY * 1 ))

echo "timespans are from ${START_TIME} to ${END_TIME} split into ${SECONDS_IN_DAY} seconds (1 day) chunks/spans"

# split into 1 day time spans
time_spans_string=$( get_time_spans "${START_TIME}" "${END_TIME}" "${STEP_IN_SECONDS}" )
time_spans_array=( $(echo "${time_spans_string}") )

for time_span in "${time_spans_array[@]}"
do
    IFS=","
    time_span_components=( $( echo "${time_span}") )
    start_time_string="${time_span_components[0]}"
    end_time_string="${time_span_components[1]}"
    echo "start: ${start_time_string}, end: ${end_time_string}"
done

# ---

# examples of working with dates

# timestamp format string
FORMAT="%Y-%m-%dT%H:%M:%S.000Z"

# local time as timestamp formatted string
date "+${FORMAT}" >/dev/null

# GMT time as timestamp formatted string
date -u "+${FORMAT}" >/dev/null

# GMT time in epoch
date -u "+%s" >/dev/null

# parse time string to local time epoch
date -j -f "${FORMAT}" "2020-02-07T00:00:00.000Z" "+%s" >/dev/null

# parse time string to GMT time epoch
date -u -j -f "${FORMAT}" "2020-02-07T00:00:00.000Z" "+%s" >/dev/null

# get epoch time from timestamp string
EPOCH_TIME=$(date -u -j -f "${FORMAT}" "2020-02-07T00:00:00.000Z" "+%s")

SECONDS_IN_DAY=$(( 60*60*24 ))

EPOCH_TIME_PLUS_ONE_DAY=$(( $SECONDS_IN_DAY+$EPOCH_TIME ))

# get the new time as formatted timestamp
NEW_TIME_STRING=$(date -u -j -f "%s" "${NEW_EPOCH}" "+${FORMAT}")
