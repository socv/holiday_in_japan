#!/usr/bin/env perl
use strict;
use warnings;
use YAML::Syck;
use POSIX;
use Template;
(my $wd = __FILE__) =~ s{[^/]+\z}{};
$wd eq "" or chdir $wd or die "ERROR: chdir '$wd': $!";

my $src_dir      = "src/yaml";
my $dst_base_dir = "dst";


my @standard_all_keys = qw(ymd y m d wday wday_ja wday_en name reason);
my @wday_ja           = qw(日 月 火 水 木 金 土);
my @wday_en           = qw(Sunday Monday Tuesday Wednesday Thursday Friday Saturday);

opendir(my $d_src, $src_dir) or die "opendir '$src_dir': $!";
my @src_files = grep { /\.yml\z/ } readdir($d_src);
closedir($d_src);

my @src_data_all = sort { $a->{ymd} cmp $b->{ymd} }
  map {
    my $filename = "$src_dir/$_";
    my $hash = eval { YAML::Syck::LoadFile($filename) } // die "ERROR: ymlfile='$filename: $@";
    my @result;
    my $common = $hash->{common} // {};
    for my $ymd (keys %$hash) {
        next if $ymd !~ /^\d/;
        my %values = (%$common);
        if (!ref($hash->{$ymd})) {
            $values{name} = $hash->{$ymd};
        }
        else {
            %values = (%values, %{ $hash->{$ymd} });
        }
        push @result, +{ %values, ymd => $ymd };
    }
    @result;
  }
  sort @src_files;

my %src_data_by_year;
for (@src_data_all) {
    $_->{ymd} =~ /^(\d+)/ or die "invalid format ymd '" . $_->{ymd} . "'";
    push @{ $src_data_by_year{$1} }, $_;
}

my %outout_format = (
    yaml_short         => { ext => "yml" },
    yaml_long          => { ext => "yml" },
    json_short         => { ext => "json" },
    json_long          => { ext => "json" },
    jsonl_short        => { ext => "jsonl" },
    jsonl_long         => { ext => "jsonl" },
    csv_short          => { ext => "csv" },
    csv_long           => { ext => "csv" },
    ltsv_long          => { ext => "ltsv" },
    sql                => { ext => "sql" },
    iCalendar_long     => { ext => "ics" },
    iCalendar_short    => { ext => "ics" },
    iCalendar_we_long  => { ext => "ics" },
    iCalendar_we_short => { ext => "ics" },
);

my $tt = Template->new(
    INCLUDE_PATH => "template",
    POST_CHOMP   => 1,
    PRE_CHOMP    => 1,
);

my @rows_holiday_all;  # 祝日
my @rows_weekend_all;  # 土日

for my $year (sort keys %src_data_by_year) {
    my @src_data = @{ $src_data_by_year{$year} };

    my @rows_holiday = map {
        my $row = $_;
        my $ymd = $row->{ymd};
        ($ymd =~ /^(\d\d\d\d)-(\d\d)-(\d\d)/) or die "invalid format ymd '$ymd'";
        +{  ymd_to_row($1, $2, $3),
            (map { $_ => $row->{$_} } qw[name reason purpose reason_of_date reason_of_holiday date])
          }
    } @src_data;
    push @rows_holiday_all, @rows_holiday;

    my @rows_weekend;
    my $begin = POSIX::mktime(0, 0, 0, 1, 0, $year - 1900);
    my $end   = POSIX::mktime(0, 0, 0, 1, 0, $year - 1900 + 1);
    for (my $t = $begin; $t < $end; $t += 86400) {
        my (undef, undef, undef, $d, $m, $y, $wday) = localtime($t);
        $m += 1; $y += 1900;
        next unless ($wday == 0 || $wday == 6);
        push @rows_weekend, +{
            ymd_to_row($y, $m, $d),
            name => ($wday == 0 ? "日曜日" : "土曜日"),
        };
    }
    push @rows_weekend_all, @rows_weekend;

    my @rows_combined = sort { $a->{ymd} cmp $b->{ymd} } (@rows_holiday, @rows_weekend);

    my $vars = {
        rows_holiday      => \@rows_holiday,
        rows_weekend      => \@rows_weekend,
        rows_combined     => \@rows_combined,
        standard_all_keys => \@standard_all_keys,
    };
    while (my ($format_name, $format_spec) = each %outout_format) {
        my $fh = open_dst_file(format_name => $format_name, format_spec => $format_spec, year => $year);
        $tt->process("$format_name.tt", { %$vars, year => $year }, $fh) or die $tt->error . "\n";
    }
}

if (1) {
    my $vars = {
        rows_holiday      => \@rows_holiday_all,
        rows_weekend      => \@rows_weekend_all,
        rows_combined     => [sort { $a->{ymd} cmp $b->{ymd} } (@rows_holiday_all, @rows_weekend_all)],
        standard_all_keys => \@standard_all_keys,
    };
    while (my ($format_name, $format_spec) = each %outout_format) {
        my $fh = open_dst_file(format_name => $format_name, format_spec => $format_spec, year => "all");
        $tt->process("$format_name.tt", $vars, $fh) or die $tt->error . "\n";
    }
}

sub ymd_to_row {
    my $y = int shift;
    my $m = int shift;
    my $d = int shift;
    my (undef, undef, undef, undef, undef, undef, $wday) = localtime mktime(0, 0, 0, $d, $m - 1, $y - 1900);
    return (
        y          => $y,
        m          => $m,
        d          => $d,
        ymd        => sprintf("%04d-%02d-%02d", $y, $m, $d),
        ymd_digits => sprintf("%04d%02d%02d", $y, $m, $d),
        wday       => $wday,
        wday_ja    => $wday_ja[$wday],
        wday_en    => $wday_en[$wday],
    );
}

sub open_dst_file {
    my %arg         = @_;
    my $format_name = $arg{format_name};
    my $format_spec = $arg{format_spec};
    my $year        = $arg{year};

    my $dst_dir = "$dst_base_dir/$format_name";
    (-d $dst_dir) or mkdir $dst_dir => oct(755) or die "ERROR: mkdir '$dst_dir' : $!";
    my $ext      = $format_spec->{ext};
    my $dst_file = "$dst_dir/$year.$ext";
    my $fh;
    open($fh, ">", $dst_file) or die "ERROR: open '$dst_file': $!";
    return $fh;
}
