#!/usr/bin/perl

use strict;
use warnings;
use Finance::QuoteTW;
use IO::All;

my $output = 'd:\fund.txt';
unlink $output;

my $title = sprintf "%-30s%10s%10s%10s%10s\r\n", 
            '����W��', '�b�Ȥ��', '�̷s�b��', '���^', '���^�T';
$title >> io($output);

my $q = Finance::QuoteTW->new;

# ��� 
printer( $q->fetch( site => 'iit', name => '�ͩR���' ) );
"\r\n" >> io($output);

# ���� 
#printer($_) foreach $q->fetch( site => 'tisc');
#"\r\n" >> io($output);

# �ɴI
#printer($_) foreach $q->fetch( site => 'jpmrich', type => 'onshore' );
#"\r\n" >> io($output);

sub printer {
    my $r = shift;
    my $content = sprintf "%-30s%10s%10s%10s%10f\r\n", 
                  $r->{name}, $r->{date}, $r->{nav}, $r->{change}, $r->{change}/$r->{nav};
    $content >> io($output);
}
