#!/usr/bin/perl 
#===============================================================================
#       AUTHOR:  Alec Chen (alec@cpan.org)
#      VERSION:  1.0
#===============================================================================

use strict;
use warnings;
use Yahoo::TW::Stock;
use Data::Dumper;

=pod
my $q = Yahoo::TW::Stock->new;
my $result = $q->fetch(2330);
print Dumper($result);
