#! /usr/bin/perl -w
#
# Convert an a0 poster to a4 for previewing and handing out
#
# Graeme Stewart (graeme@astro.gla.ac.uk) 2001-04-06
#
# $Id: a0toa4.pl,v 1.1 2001/07/02 17:23:32 norman Exp $

# Check we have one argument
die "Usage: a0toa4.pl [FILE_NAME]\n" if $#ARGV != 0;

# See if the source file exists and is readable
die "Can't seem to open $ARGV[0] for reading\n" if ! -r $ARGV[0];

# Try and work out what file name we want for the a4 poster
if ($ARGV[0] =~ /^(.*)\.ps$/) {
  $target = "$1_a4.ps";
} else {
  $target = "$ARGV[0]_a4";
}

# Invoke psrezise
system "psresize", "-q", "-H238cm", "-h59.5cm", $ARGV[0], $target;
die "psresize didn't see to work - sorry ($?)\n" if $? != 0;

# Now hack the postscript to remove the bogus translate command
# We only do this once - otherwise other graphics get messed up!
open(IN, "$target") || die "Oh dear - failed to open $target for reading: $!\n";
open(OUT, ">$target.tmp") || die "Oh dear - failed to open $target.tmp for writing: $!\n";
$done = 0;
while(<IN>) {
  if ($done == 0) {
    if (s/^[\d\.]+ [\d\.]+ (translate)/0.0 0.0 $1/) {$done = 1};
  }
  print OUT;
}

# Finally, rename the temporary file to the target name
die "Oh dear - failed to rename $target.tmp to $target\n" if ! rename "$target.tmp", "$target";

# Success
print "Wrote output to $target.\n"
