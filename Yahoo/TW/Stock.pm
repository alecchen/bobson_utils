package Yahoo::TW::Stock;
use Mouse;
use Encode qw(encode decode);
use WWW::Mechanize;
use HTML::TableExtract;
#use Smart::Comments;
use version; our $VERSION = qv('0.0.1');

sub fetch {
	my $self = shift;
	my $id   = shift;

	### fetch
	my $mech = WWW::Mechanize->new;
	my $url  = "http://tw.stock.yahoo.com/q/q?s=$id";
	$mech->get($url);
	my $content = $mech->content;
	$content = encode('big5', $content);

	### parse
	my $te = HTML::TableExtract->new;
	$te->parse($content);

	my @tables = $te->tables;
	my $date = [split /\s+/, $tables[4]->rows->[0]->[1]]->[1];

	### elements
	my @values = @{ $tables[5]->rows->[1] }[0..10];
	($values[0]) = $values[0] =~ /(\d+)/;
	$values[5] = sprintf "%2f", $values[2] - $values[7];

	my %result = (
		id   => $values[0],
		nav  => $values[2],
		dev  => $values[5],
		date => $date,
	);

	return \%result;
}

1;
