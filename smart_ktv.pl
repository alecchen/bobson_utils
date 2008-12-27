#!/usr/bin/perl -w

use strict;
use Tk;
use Encode;

my ($mw, $next_flag, %fm, %var);

# initial variables
foreach (qw/vol track lang singer sexual song filename/) {
    $var{$_} = '';
}

# main window
$mw = MainWindow->new;
$mw->configure(-title => &utf8('KTV輸入批次處理(天才老爹 v1.0 版)'));

# directory
&lab_entry('歌曲目錄', 'dir');
$fm{'dir'}->Button(-text    => &utf8('瀏覽'),
                   -command => sub { $var{'dir'} = &dir_select }
                   )->pack(-side => 'left',
		           -padx => 5);
$fm{'dir'}->Button(-text    => &utf8('開始處理'),
                   -command => sub { &parse_dir($var{'dir'}) }
                   )->pack(-side => 'left',
		           -padx => 5);

# filename
&lab_entry('原始檔名', 'filename');

# singer
&lab_entry('歌手', 'singer');

# sexual
&lab('歌手類別', 'sexual');
$var{'sexual'} = 0;
my $radio_index = 0;
foreach (qw/女歌手 男歌手 團體/) {
    $fm{'sexual'}->Radiobutton(-text     => &utf8("$_"),
                               -value    => $radio_index,
			       -variable => \$var{'sexual'},
			       -command  => sub { &singer_name }
			       )->pack(-side => 'left');
    $radio_index++;
}

# song name
&lab_entry('歌名', 'song');

# song type
&lab('歌曲語言', 'lang');
$var{'lang'} = &utf8('國語');
foreach (qw/國語 台語 日語 英語/) {
    $fm{'lang'}->Radiobutton(-text     => &utf8("$_"),
                             -value    => &utf8($_),
			     -variable => \$var{'lang'}
			     )->pack(-side => 'left');

}

# volumn
$var{'vol'} = 70;
&lab_entry('音量大小', 'vol');

# track
$var{'track'} = 1;
&lab_entry('伴奏軌聲道', 'track');

# output filename
$var{'csv'} = &parse_time . '.csv';
&lab_entry('CSV檔名', 'csv');

# next song button
$mw->Button(-text    => &utf8('下一首'),
            -command => sub { $next_flag = 1 }
            )->pack(-side => 'top',
	            -padx => 5);


MainLoop;

sub lab {
    my $text = shift;
    my $name = shift;
    $fm{$name} = $mw->Frame->pack(-pady => 5,
                                  -fill => 'x');
    $fm{$name}->Label(-text  => &utf8($text),
		      -width => 10 
		      )->pack(-side  => 'left');
}

sub lab_entry {
    my $text = shift;
    my $name = shift;
    $fm{$name} = $mw->Frame->pack(-pady => 5,
                                  -fill => 'x');
    $fm{$name}->Label(-text  => &utf8($text),
		      -width => 10 
		     )->pack(-side  => 'left');
    $fm{$name}->Entry(-textvariable => \$var{$name},
		      -width        => 35 
                     )->pack(-side  => 'left');
}

sub big5 {
    my $text = shift;
    return encode('big5', $text);
}

sub utf8 {
    my $text = shift;
    return decode('big5', $text);
}

sub dir_select {
    my ($dir_big5, $dir_utf8);
    $dir_big5 = $mw->chooseDirectory(-initialdir => 'D:\\KTV\\');
    $dir_big5 =~ s/\//\\/g;
    $dir_utf8 = &utf8($dir_big5);
    return $dir_utf8;
}

sub parse_dir {
    my $dir = &big5(shift);
    my $ext  = qr/\.(mpg|mpeg|avi|wmv|rm|rmvb|dat)/i;
    my $ktv  = qr/[\[\(]+\s*ktv\s*[\]\)]*/i;
    open OUT, ">$dir\\$var{'csv'}"
	or die "Couldn't open $dir\\$var{'cvs'} to write: $!\n";
    opendir DH, "$dir"
	or die "Couldn't open directory $dir: $!\n";
    foreach (sort readdir DH) {
	my $output = '';
	next if !/$ext$/;
	next if /^\d\d\d\d\d-/;
	$next_flag = 0;
	&singer_name;
	$var{'filename'} = &utf8($_);
	if (/^$ktv?(.*?)[_-](.*?)$ktv?(?:-ktv)?$ext/i) {
	    $var{'singer'} = &utf8($1);
	    $var{'song'}   = &utf8($2);
	} elsif (/(.*?)$ext/i) {
	    $var{'song'}   = &utf8($1);
	} else {
	    $var{'singer'} = &utf8('請輸入歌手');
	    $var{'song'}   = &utf8('請輸入歌名');
	}
	$mw->waitVariable(\$next_flag);
	foreach (qw/vol track lang singer sexual song filename/) {
	    $output = $output . &big5($var{$_}) . ',';
	}
	chop $output;
	print "$output\n";
	print OUT "$output\n";
    }
    close OUT;
    closedir DH;
    $mw->Button(-text    => &utf8('離開'),
                -command => sub { exit }
		)->pack(-side => 'top',
		        -pady => 5);
}

sub singer_name {
   if ($var{'singer'} eq '' || $var{'singer'} eq &utf8('女歌手') || $var{'singer'} eq &utf8('男歌手') || $var{'singer'} eq &utf8('團體')) { 
	if ($var{'sexual'} == 0) {
	    $var{'singer'} = &utf8('女歌手');
	} elsif ($var{'sexual'} == 1) {
	    $var{'singer'} = &utf8('男歌手');
	} elsif ($var{'sexual'} == 2) {
	    $var{'singer'} = &utf8('團體');
	}
    }
}

sub parse_time {
    my @time = localtime;
    my $year = 1900 + $time[5];
    my $mon  = $time[4] + 1;
    my $day  = $time[3];
    my $hour = $time[2];
    my $min  = $time[1];
    $mon  = '0' . $mon  if length($mon)  < 2;
    $day  = '0' . $day  if length($day)  < 2;
    $hour = '0' . $hour if length($hour) < 2;
    $min  = '0' . $min  if length($min)  < 2;
    my $time = "$year-$mon-$day-$hour-$min";
    return $time;
}
