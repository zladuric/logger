#!/usr/bin/perl

use strict;
use warnings;
package Logger;

# Check input arguments

#!/usr/bin/perl -w
#
# line mode is a mandaory param
our $argc = $#ARGV + 1;
if ($argc < 1) {
  usage();
  exit;
}

my $mode = shift @ARGV;
my $channel = 'null';
my $keys = "";
if ($argc > 1) {
  my $chan = shift @ARGV;
  $channel = "\"$chan\"";
}
# for now
if ($argc > 2) {
  $keys = get_keys(@ARGV);
}
if ( ! ( $mode eq "block" || $mode eq "line" ) ) {
  usage();
  exit;
}

# pretty print thing
my $prepend="";
if(defined $ENV{'LOGGER_PRE'}) {

  $prepend = "$ENV{'LOGGER_PRE'} ";
}

if ($mode eq "line") {

  foreach my $entry (<STDIN>) {
    chomp($entry);
    my $current = print_line($entry, $keys, $prepend);
    print "$current\n";
  }
} else {

  my $msg;
  while (<STDIN>) {
      chomp;
      $msg .= "$_\\n";
  }
  chomp $msg;
  my $current = print_line($msg, $keys, $prepend);
  print "$current\n";
}

## Subs
# print_line(message, keys, prepend);

sub print_line {

  my $timestamp = localtime();
  my $line = $_[2];
  $line .= "{\"log_level\":\"INFO\", \"channel\": $channel,";
  $line .= " \"message\":\"$_[0]\", \"timestamp\": \"$timestamp\"";
  $line .= $keys;
  $line .= "}";
  return $line;
}

# get_keys(arr) gets the key:val stuff
sub get_keys {

  my $item = "";
  foreach my $i(0 .. $#_) {

    my $entry = $_[$i];
    my @tokens = split ':', $entry;
    my $key = shift @tokens;
    my $val = join ':', @tokens;
    $item .= ", \"$key\": \"$val\"";
  }
  return $item;
}

sub usage {

  print "Usage: logger.pl MODE [CHANNEL] [<key1:val1>,[<key2:val2>...]]\n";
  print "    MODE must be one of: block, line\n";
}
