#!/usr/bin/perl 

use strict;
use warnings;
use Wx;
use Yahoo::TW::Stock::GUI;

my $app = Wx::SimpleApp->new;
my $frame = Yahoo::TW::Stock::GUI->new;
$frame->Show(1);
$app->MainLoop;
