#!/usr/bin/perl 
#===============================================================================
#       AUTHOR:  Alec Chen (alec@cpan.org)
#      VERSION:  1.0
#===============================================================================

use strict;
use warnings;
use Yahoo::TW::Stock;
use Spreadsheet::ParseExcel;
use Smart::Comments;
use IO::All;

my $input = 'D:\20--pri\2D--stock\stock.xls';
my $output = '';

### parsing
my $excel = Spreadsheet::ParseExcel::Workbook->Parse($input);
my @id_list;
my $sheet = $excel->{Worksheet}->[0];

### collect id
my $row = 1;
while (1) {
	my $cell = $sheet->{Cells}[$row][0];
	last unless $cell;
	last if $row > 1000;
	my $id = $cell->{Val};
	push @id_list, $id;
	$row++;
}

### fetch
my $q = Yahoo::TW::Stock->new;
my @keys = qw(�Ѳ��N�� �Ѳ��W�� ��Ƥ�� �ɶ� ���� �R�i ��X ���^ �i�� �Q�� �}�L �̰� �̧C);
my $label = join q{ }, @keys;
print "$label\n";

foreach my $id (@id_list) {
	my $result = $q->fetch($id);
	my @values = map { $result->{$_} } @keys;
	my $output = join q{ }, @values;
	print "$output\n";
}
