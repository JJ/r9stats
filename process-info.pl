#!/usr/bin/env perl

use strict;
use warnings;
use v5.14;

use JSON;
use File::Slurper qw(read_text write_text);

my $file = "r9-user-info.json";

my $user_info = from_json( read_text($file) );

my %oss;
my %lenguajes;
for my $u ( @$user_info ) {
  if ($u->{'os'} ) {
    $oss{'linux'}++ if ($u->{'os'} =~ /inux/) or  ($u->{'os'} =~ /untu/);
    $oss{'windows'}++ if ($u->{'os'} =~ /indo/) or ($u->{'os'} =~ /W/);
    $oss{'mac'}++ if $u->{'os'} =~ /ac/;
  }

  if ( $u->{'lenguajes'} ) {
    my $lenguajes = $u->{'lenguajes'};
    $lenguajes =~ s/, (\w)/, \u$1/g;
    my @capitals = ($lenguajes =~ /\b([A-Z]\w*\+*)/g );
    # Corrige Python
    for my $c (@capitals) {
      $c = "Python" if ($c =~ /Phyt/) or ($c =~ /yton/) or ($c =~ /tyhon/) or ($c =~ /yhton/) ;
    }
    map( $lenguajes{lc($_) }++, @capitals );
  }
  
}
my %_1c_lenguajes = map( ucfirst($_), %lenguajes);

write_text("r9-user-oss.json", encode_json( \%oss ));
write_text("r9-user-lenguajes.json", encode_json(  \%_1c_lenguajes ));
