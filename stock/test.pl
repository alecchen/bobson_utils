#!/usr/bin/env perl
#===============================================================================
#       AUTHOR:  Alec Chen , <alec@cpan.org>
#===============================================================================

use strict;
use warnings;
use Wx;
use GUI;

my $app = Wx::SimpleApp->new;
my $frame = GUI->new;
$frame->Show(1);
$app->MainLoop;
