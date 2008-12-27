package Yahoo::TW::Stock;
use Mouse;
use Encode qw(encode decode);
use WWW::Mechanize;
use HTML::TableExtract;
use Smart::Comments;
use IO::All;
use version; our $VERSION = qv('0.0.1');
use Data::TreeDumper;


sub fetch {
	my $self = shift;
	my $id   = shift;

=pod
	### fetch
	my $mech = WWW::Mechanize->new;
	my $url  = "http://tw.stock.yahoo.com/q/q?s=$id";
	$mech->get($url);
	my $content = $mech->content;
	$content = encode('big5', $content);
	$content > io('2330.txt');
=cut

	my $content = io('2330.txt')->slurp;

	### parse
	my $te = HTML::TableExtract->new;
	$te->parse($content);

	my @tables = $te->tables;
	my $date = [split /\s+/, $tables[4]->rows->[0]->[1]]->[1];

	### elements
	my @values = @{ $tables[5]->rows->[1] }[0..10];
	my @keys   = qw(股票代號 時間 成交 買進 賣出 漲跌 張數 昨收 開盤 最高 最低);

	$values[0] =~ /(\d+)(\S+)/;
	$values[0] = $1;
	my $name   = $2;
	$values[5] = sprintf "%2f", $values[2] - $values[7];
	my %result = map { $keys[$_] => $values[$_] } 0..10;
	$result{'股票名稱'} = $name;
	$result{'資料日期'} = $date;

	return \%result;
}

1;
