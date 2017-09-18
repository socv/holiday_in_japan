#!/usr/bin/env perl
use strict;
use warnings;
use YAML::Syck;
use POSIX;
(my $wd = __FILE__) =~ s{[^/]+\z}{};
$wd eq "" or chdir $wd or die "ERROR: chdir '$wd': $!";

my $src_dir      = "src/yaml";
my $dst_base_dir = "dst";


my @all_keys = qw(ymd y m d wday wday_ja wday_en name reason);
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
    yaml_short => {
        ext => "yml", row => sub { $_->{ymd} . ": " . $_->{name} . "\n" }
    },
    yaml_long => {
        ext => "yml",
        row => sub {
            my %v = %$_; "- { " . join(", ", map { "$_: \"$v{$_}\"" } grep { defined $v{$_} } @all_keys) . " }\n";
        }
    },
    json_short => {
        ext => "json", before => sub { "{\n" }, after => sub { "\n}\n" },
        join => sub { join(",\n", @_) },
        row  => sub { '"' . $_->{ymd} . '": "' . $_->{name} . '"' }
    },
    json_long => {
        ext => "json", before => sub { "[\n" }, after => sub { "\n]\n" },
        join => sub { join(",\n", @_) },
        row  => sub {
            my %v = %$_; '{ ' . join(", ", map { "\"$_\":\"$v{$_}\"" } grep { defined $v{$_} } @all_keys) . " }";
        }
    },
    csv_short => {
        ext => "csv",
        row => sub { join(",", $_->{ymd}, $_->{name}) . "\n" }
    },
    csv_long => {
        ext => "csv",
        row => sub {
            my %v = %$_; join(",", map { $v{$_} } grep { defined $v{$_} } @all_keys) . "\n";
        }
    },
    ltsv_long => {
        ext => "ltsv",
        row => sub {
            my %v = %$_; join("\t", map { "$_:$v{$_}" } grep { defined $v{$_} } @all_keys) . "\n";
        }
    },
    sql => {
        ext    => "sql",
        before => sub {
            "CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));\n"
              . "REPLACE INTO `holiday` (`date`,`description`) VALUES \n";
        },
        after => sub { ";\n" },
        join  => sub { join ",\n", @_ },
        row   => sub { "('" . $_->{ymd} . "','" . $_->{name} . "')" },
    },
    iCalendar => {
        ext    => "ics",
        before => sub {
            my $ymd = POSIX::strftime("%Y%m%d", localtime);
            return "BEGIN:VCALENDAR\n" . "VERSION:2.0\n" . "PRODID:-//socv/hiliday_in_japan//$ymd//EN\n" . join(
                "",
                map { "$_\n" } qw(
                  CALSCALE:GREGORIAN
                  METHOD:PUBLISH
                  X-WR-CALNAME:holiday_in_japan(日本の祝日や休日)
                  X-WR-TIMEZONE:Asia/Tokyo
                  X-WR-CALDESC:日本の祝日や休日
                  BEGIN:VTIMEZONE
                  TZID:Asia/Tokyo
                  X-LIC-LOCATION:Asia/Tokyo
                  BEGIN:STANDARD
                  TZOFFSETFROM:+0900
                  TZOFFSETTO:+0900
                  TZNAME:JST
                  DTSTART:19700101T000000
                  END:STANDARD
                  END:VTIMEZONE
                  )
              )

        },
        after => sub { "END:VCALENDAR\n" },
        row   => sub {
            my %v           = %$_;
            my $ymd_digits  = $v{ymd_digits};
            my %label = (
                reason => "理由",
                reason_of_date => "日付の理由",
                reason_of_holiday => "祝日になった理由・経緯",
                date => "日付について",
            );
            my $description = join("\n\n", map { $label{$_}. ": ". $v{$_} } grep { defined $v{$_} } qw[reason reason_of_date reason_of_holiday date]);

            $description =~ s/\n/\\n/gs;
            return
                "BEGIN:VEVENT\n"
              . "DTSTART;VALUE=DATE:$ymd_digits\n"
              . "DTEND;VALUE=DATE:$ymd_digits\n"
              . "SUMMARY:$v{name}\n"
              . ($description ? "DESCRIPTION:$description\n" : "")
              . "END:VEVENT\n";
        },
    },
);

while (my ($format_name, $format_spec) = each %outout_format) {
    my $dst_dir = "$dst_base_dir/$format_name";
    (-d $dst_dir) or mkdir $dst_dir => 0755 or die "ERROR: mkdir '$dst_dir' : $!";

    my $ext           = $format_spec->{ext};
    my $filter_row    = $format_spec->{row};
    my $filter_before = $format_spec->{before} // sub { "" };
    my $filter_after  = $format_spec->{after} // sub { "" };
    my $filter_join   = $format_spec->{join} // sub { join "", @_ };

    my @filtered_rows_all;

    for my $year (sort keys %by_year) {
        my $rows = $by_year{$year};

        my $dst_file = "$dst_dir/$year.$ext";
        open(my $fh, ">", $dst_file) or die "ERROR: open '$dst_file': $!";

        my @filtered_rows = map { local $_ = $_; $filter_row->() }
        map {
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
                (map { $_ => $row->{$_} } qw[name reason reason_of_date reason_of_holiday date])
              }
          } @$rows;
        push @filtered_rows_all, @filtered_rows;

        print $fh $filter_before->();
        print $fh $filter_join->(@filtered_rows);
        print $fh $filter_after->();
    }

    my $dst_all_file = "$dst_dir/all.$ext";
    open(my $fh, ">", $dst_all_file) or die "ERROR: open '$dst_all_file': $!";
    print $fh $filter_before->();
    print $fh $filter_join->(@filtered_rows_all);
    print $fh $filter_after->();
}


