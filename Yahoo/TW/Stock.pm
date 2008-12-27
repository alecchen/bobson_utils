package Yahoo::TW::Stock;
use Mouse;
use Rubyish::Attribute;
use Readonly;
use Encode qw(encode decode);
use IO::All;
use HTML::TableExtract;
use Data::TreeDumper;

use version; our $VERSION = qv('0.0.1');

#Readonly my @KEYS => qw(股票代號 時間 成交 買進 賣出 漲跌 張數 昨收 開盤 最高 最低);

attr_accessor qw(id time nav dev date);

sub new {
	my ($class, %args) = @_;
	my $self = bless \%args, $class;
	return $self;
}

sub id {
	my $self = shift;
	my $id   = shift;

	# fetch
	my $mech = WWW::Mechanize->new;
	my $url  = "http://tw.stock.yahoo.com/q/q?s=$id";
	$mech->get($url);
	my $content = $mech->content;
	$content = encode('big5', decode('utf8', $content));

	# parse
	my $te = HTML::TableExtract->new;
	$te->parse($content);

	my @tables = $te->tables;
	my $date = [split /\s+/, $tables[4]->rows->[0]->[1]]->[1];

	# elements
	my @values = @{ $tables[5]->rows->[1] }[0..10];
	($values[0]) = $values[0] =~ /(\d+)/;
	$values[5] = sprintf "%2f", $values[2] - $values[7];

	#my %result = map { $keys[$_] => $values[$_] } 0..10;
	$self->id($values[0]);
	$self->time($values[1]);
	$self->nav($values[2]);
	$self->dev($values[5]);
	$self->date($date);

	return;
}

1;
