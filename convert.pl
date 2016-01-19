#!/usr/bin/env perl
use strict;
use warnings;
use YAML::Syck;
(my $wd = __FILE__) =~ s{[^/]+\z}{};
$wd eq "" or chdir $wd or die "ERROR: chdir '$wd': $!";

my $src_dir      = "src/yaml";
my $dst_base_dir = "dst";

opendir(my $d_src, $src_dir) or die "opendir '$src_dir': $!";
my @src_files = grep {/\.yml\z/} readdir($d_src);
closedir($d_src);

my @data;
for my $f (@src_files) {
    my $hash = YAML::Syck::LoadFile("$src_dir/$f");
    push @data, map { +{ ymd => $_, name => $hash->{$_} } } keys %$hash;
}
@data = sort { $a->{ymd} cmp $b->{ymd} } @data;
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
            my %v = %$_; "- { " . join(", ", map {"$_:\"$v{$_}\""} qw(ymd y m d name)) . " }\n";
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
            my %v = %$_; '{ ' . join(", ", map {"\"$_\":\"$v{$_}\""} qw(ymd y m d name)) . " }";
        }
    },
    csv_short => {
        ext => "csv",
        row => sub { join(",", $_->{ymd}, $_->{name}) . "\n" }
    },
    csv_long => {
        ext => "csv",
        row => sub {
            my %v = %$_; join(",", map { $v{$_} } qw(ymd y m d name)) . "\n";
        }
    },
    ltsv_long => {
        ext => "ltsv",
        row => sub {
            my %v = %$_; join("\t", map {"$_:$v{$_}"} qw(ymd y m d name)) . "\n";
        }
    },
    sql => {
        ext    => "sql",
        before => sub {"REPLACE INTO holiday (`date`,`description`) VALUES "},
        after  => sub {";\n"},
        join   => sub { join ", ", @_ },
        row => sub { "('" . $_->{ymd} . "','" . $_->{name} . "')" },
    },
);

while (my ($format_name, $format_spec) = each %outout_format) {
    my $dst_dir = "$dst_base_dir/$format_name";
    (-d $dst_dir) or mkdir $dst_dir => 0755 or die "ERROR: mkdir '$dst_dir' : $!";

    my $ext           = $format_spec->{ext};
    my $filter_row    = $format_spec->{row};
    my $filter_before = $format_spec->{before};
    my $filter_after  = $format_spec->{after};
    my $filter_join   = $format_spec->{join} // sub { join "", @_ };
    while (my ($year, $rows) = each %by_year) {
        my $dst_file = "$dst_dir/$year.$ext";
        open(my $fh, ">", $dst_file) or die "ERROR: open '$dst_file': $!";

        print $fh $filter_before->() if $filter_before;
        print $fh $filter_join->(
            map { local $_ = $_; $filter_row->() }
              map {
                my $ymd = $_->{ymd};
                ($ymd =~ /^(\d\d\d\d)-(\d\d)-(\d\d)/) or die "invalid format ymd '$ymd'";
                +{  ymd  => $ymd,
                    y    => int($1),
                    m    => int($2),
                    d    => int($3),
                    name => $_->{name},
                  }
              } @$rows
        );
        print $fh $filter_after->() if $filter_after;
    }
}


