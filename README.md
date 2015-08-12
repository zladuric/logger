## logger

Simple excersize to learn a bit of perl. Takes input and converts to output in logger format.

## Usage:

    logger.pl MODE [CHANNEL] [KEY[:VAL],[KEY[:VAL]...]]

Mode is one of `block` or `line`. If mode is `block`, everything is put together as one single message (newlines replaced to \n). If mode is `line`, each line is one log message.

Optionally the scripts takes a `channel` arguments sets the "channel", channel defaults to `null`. All other arguments are broken down into KEY:VALUE pairs (or KEY with empty string value).

Finally, if LOGGER_PRE environment variable is set, the logger will set a $pre text to each log line.

## Examples

    [zlatko@zlatko-mint ~/projects/logger]$ logger.pl
    Usage: logger.pl MODE [CHANNEL] [<key1:val1>,[<key2:val2>...]]
        MODE must be one of: block, line
    [zlatko@zlatko-mint ~/projects/logger]$ logger.pl line
    This is line 1.
    This is another one.
    {"log_level":"INFO", "channel": null, "message":"This is line 1.", "timestamp": "Thu Aug 13 00:49:31 2015"}
    {"log_level":"INFO", "channel": null, "message":"This is another one.", "timestamp": "Thu Aug 13 00:49:31 2015"}
    [zlatko@zlatko-mint ~/projects/logger]$ logger.pl line my_channel
    A line with a channel.
    {"log_level":"INFO", "channel": "my_channel", "message":"A line with a channel.", "timestamp": "Thu Aug 13 00:49:47 2015"}
    [zlatko@zlatko-mint ~/projects/logger]$ logger.pl block CHANNEL key:value another:entry
    This is a block message.
    It should pick rows into a single message.
    {"log_level":"INFO", "channel": "CHANNEL", "message":"This is a block message.\nIt should pick rows into a single message.\n", "timestamp": "Thu Aug 13 00:50:19 2015", "key": "value", "another": "entry"}
    [zlatko@zlatko-mint ~/projects/logger]$ LOGGER_PRE=@cee logger.pl line channel_name
    This line will be prepended by environment setting.
    This one gets it too.
    @cee {"log_level":"INFO", "channel": "channel_name", "message":"This line will be prepended by environment setting.", "timestamp": "Thu Aug 13 00:51:11 2015"}
    @cee {"log_level":"INFO", "channel": "channel_name", "message":"This one gets it too.", "timestamp": "Thu Aug 13 00:51:11 2015"}
    [zlatko@zlatko-mint ~/projects/logger]$ LOGGER_PRE=@cee logger.pl block channel_name
    Prepending works in block mode too.

    Isn't it?
    @cee {"log_level":"INFO", "channel": "channel_name", "message":"Prepending works in block mode too.\n\nIsn't it?\n", "timestamp": "Thu Aug 13 00:51:29 2015"}
    [zlatko@zlatko-mint ~/projects/logger]$
    [zlatko@zlatko-mint ~/projects/logger]$ cat input.txt | LOGGER_PRE=@cee logger.pl line works_from_piped_stdin_too
    @cee {"log_level":"INFO", "channel": "works_from_piped_stdin_too", "message":"This is the first line", "timestamp": "Thu Aug 13 00:52:40 2015"}
    @cee {"log_level":"INFO", "channel": "works_from_piped_stdin_too", "message":"This is the second line", "timestamp": "Thu Aug 13 00:52:40 2015"}
    @cee {"log_level":"INFO", "channel": "works_from_piped_stdin_too", "message":"This is the third line", "timestamp": "Thu Aug 13 00:52:40 2015"}
    [zlatko@zlatko-mint ~/projects/logger]$