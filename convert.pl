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
my @wday_ja  = qw(日 月 火 水 木 金 土);
my @wday_en  = qw(Sunday Monday Tuesday Wednesday Thursday Friday Saturday);


opendir(my $d_src, $src_dir) or die "opendir '$src_dir': $!";
my @src_files = grep { /\.yml\z/ } readdir($d_src);
closedir($d_src);


my @data = sort { $a->{ymd} cmp $b->{ymd} }
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

my %by_year;
for (@data) {
    $_->{ymd} =~ /^(\d+)/ or die "invalid format ymd '" . $_->{ymd} . "'";
    push @{ $by_year{$1} }, $_;
}

my %outout_format = (
    yaml_short => { ext => "yml" },
    yaml_long => { ext => "yml" },
    json_short => { ext => "json" },
    json_long => { ext => "json" },
    csv_short => { ext => "csv" },
    csv_long => { ext => "csv" },
    ltsv_long => { ext => "ltsv" },
    sql => { ext => "sql" },
    iCalendar_long => { ext    => "ics" },
    iCalendar_short => { ext    => "ics" },
);


my $tt = Template->new(
    INCLUDE_PATH => "template",
    POST_CHOMP => 1,
    PRE_CHOMP => 1,
);


while (my ($format_name, $format_spec) = each %outout_format) {
    my $template_filename = "$format_name.tt";
    my $template_pathname = "template/$template_filename";

    my $dst_dir = "$dst_base_dir/$format_name";
    (-d $dst_dir) or mkdir $dst_dir => 0755 or die "ERROR: mkdir '$dst_dir' : $!";

    my $ext           = $format_spec->{ext};
    my $filter_row    = $format_spec->{row};
    my $filter_before = $format_spec->{before} // sub { "" };
    my $filter_after  = $format_spec->{after} // sub { "" };
    my $filter_join   = $format_spec->{join} // sub { join "", @_ };

    my @filtered_rows_all;
    my @raw_rows_all;

    for my $year (sort keys %by_year) {
        my $rows = $by_year{$year};

        my $dst_file = "$dst_dir/$year.$ext";
        open(my $fh, ">", $dst_file) or die "ERROR: open '$dst_file': $!";

        my @raw_rows = map {
            my $row = $_;
            my $ymd = $row->{ymd};
            ($ymd =~ /^(\d\d\d\d)-(\d\d)-(\d\d)/) or die "invalid format ymd '$ymd'";
            my $ymd_digits = "$1$2$3";
            my ($y, $m, $d) = (int($1), int($2), int($3));
            my (undef, undef, undef, undef, undef, undef, $wday) = localtime mktime(0, 0, 0, $d, $m - 1, $y - 1900);
            +{  ymd        => $ymd,
                ymd_digits => $ymd_digits,
                y          => $y,
                m          => $m,
                d          => $d,
                wday       => $wday,
                wday_ja    => $wday_ja[$wday],
                wday_en    => $wday_en[$wday],
                (map { $_ => $row->{$_} } qw[name reason purpose reason_of_date reason_of_holiday date])
            }
        } @$rows;
        push @raw_rows_all, @raw_rows;

        if(-e $template_pathname) {
            my $vars = {
                rows => \@raw_rows,
                standard_all_keys => \@standard_all_keys,
            };
            $tt->process($template_filename, $vars, $fh) or die $tt->error . "\n";
        }
        else {
            my @filtered_rows = map { local $_ = $_; $filter_row->() } @raw_rows;
            push @filtered_rows_all, @filtered_rows;
            print $fh $filter_before->();
            print $fh $filter_join->(@filtered_rows);
            print $fh $filter_after->();
        }
    }

    if(1) {
        my $dst_all_file = "$dst_dir/all.$ext";
        open(my $fh, ">", $dst_all_file) or die "ERROR: open '$dst_all_file': $!";

        if(-e $template_pathname) {
            my $vars = {
                rows => \@raw_rows_all,
                standard_all_keys => \@standard_all_keys,
            };
            $tt->process($template_filename, $vars, $fh) or die $tt->error . "\n";
        }
        else {
            print $fh $filter_before->();
            print $fh $filter_join->(@filtered_rows_all);
            print $fh $filter_after->();
        }
    }
}


