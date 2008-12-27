#!/usr/bin/perl

use strict;
use warnings;
use Finance::QuoteTW;
use IO::All;

my $output = 'd:\fund.txt';
unlink $output;

my $title = sprintf "%-30s%10s%10s%10s%10s\r\n", 
            '基金名稱', '淨值日期', '最新淨值', '漲跌', '漲跌幅';
$title >> io($output);

my $q = Finance::QuoteTW->new;

# 國際 
printer( $q->fetch( site => 'iit', name => '生命科學' ) );
"\r\n" >> io($output);

# 金鼎 
#printer($_) foreach $q->fetch( site => 'tisc');
#"\r\n" >> io($output);

# 怡富
#printer($_) foreach $q->fetch( site => 'jpmrich', type => 'onshore' );
#"\r\n" >> io($output);

sub printer {
    my $r = shift;
    my $content = sprintf "%-30s%10s%10s%10s%10f\r\n", 
                  $r->{name}, $r->{date}, $r->{nav}, $r->{change}, $r->{change}/$r->{nav};
    $content >> io($output);
}
