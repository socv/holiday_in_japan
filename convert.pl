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
my @src_files = grep {/\.yml\z/} readdir($d_src);
closedir($d_src);

my @data =
  sort { $a->{ymd} cmp $b->{ymd} }
  map {
      my $hash = $_;
      map {
          my $ymd = $_;
          my %values = ();
          if(!ref($hash->{$ymd})) {
              $values{name} = $hash->{$ymd};
          }
          else {
              %values = %{ $hash->{$ymd} };
          }
          +{ ymd => $ymd, %values }

      } keys %$hash;
  }
  map { YAML::Syck::LoadFile("$src_dir/$_") }
  @src_files;

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
            my %v = %$_; "- { " . join(", ", map {"$_: \"$v{$_}\""} grep {defined $v{$_} } @all_keys) . " }\n";
        }
    },
    json_short => {
        ext => "json", before => sub {"{\n"}, after => sub {"\n}\n"},
        join => sub { join(",\n", @_) },
        row => sub { '"' . $_->{ymd} . '": "' . $_->{name} . '"' }
    },
    json_long => {
        ext => "json", before => sub {"[\n"}, after => sub {"\n]\n"},
        join => sub { join(",\n", @_) },
        row => sub {
            my %v = %$_; '{ ' . join(", ", map {"\"$_\":\"$v{$_}\""} grep {defined $v{$_} } @all_keys) . " }";
        }
    },
    csv_short => {
        ext => "csv",
        row => sub { join(",", $_->{ymd}, $_->{name}) . "\n" }
    },
    csv_long => {
        ext => "csv",
        row => sub {
            my %v = %$_; join(",", map { $v{$_} } grep {defined $v{$_} } @all_keys) . "\n";
        }
    },
    ltsv_long => {
        ext => "ltsv",
        row => sub {
            my %v = %$_; join("\t", map {"$_:$v{$_}"} grep {defined $v{$_} } @all_keys) . "\n";
        }
    },
    sql => {
        ext    => "sql",
        before => sub {
            "CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));\n"
            . "REPLACE INTO `holiday` (`date`,`description`) VALUES \n"
        },
        after  => sub {";\n"},
        join   => sub { join ",\n", @_ },
        row => sub { "('" . $_->{ymd} . "','" . $_->{name} . "')" },
    },
);

while (my ($format_name, $format_spec) = each %outout_format) {
    my $dst_dir = "$dst_base_dir/$format_name";
    (-d $dst_dir) or mkdir $dst_dir => 0755 or die "ERROR: mkdir '$dst_dir' : $!";

    my $ext           = $format_spec->{ext};
    my $filter_row    = $format_spec->{row};
    my $filter_before = $format_spec->{before} // sub {""};
    my $filter_after  = $format_spec->{after} // sub {""};
    my $filter_join   = $format_spec->{join} // sub { join "", @_ };

    my @filtered_rows_all;

    for my $year (sort keys %by_year) {
        my $rows = $by_year{$year};

        my $dst_file = "$dst_dir/$year.$ext";
        open(my $fh, ">", $dst_file) or die "ERROR: open '$dst_file': $!";

        my @filtered_rows =
          map { local $_ = $_; $filter_row->() }
          map {
            my $ymd = $_->{ymd};
            ($ymd =~ /^(\d\d\d\d)-(\d\d)-(\d\d)/) or die "invalid format ymd '$ymd'";
            my ($y, $m, $d) = (int($1), int($2), int($3));
            my (undef, undef, undef, undef, undef, undef, $wday) = localtime mktime(0, 0, 0, $d, $m - 1, $y - 1900);
            +{  ymd     => $ymd,
                y       => $y,
                m       => $m,
                d       => $d,
                wday    => $wday,
                wday_ja => $wday_ja[$wday],
                wday_en => $wday_en[$wday],
                name    => $_->{name},
                reason  => $_->{reason},
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


