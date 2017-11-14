#!/usr/bin/env perl

use strict;
use warnings;
use v5.14;

use JSON;
use File::Slurper qw(read_text write_text);

my $file = "r9-user-info.json";

my $user_info = decode_json( read_text($file) );

my %oss;
my %lenguajes;
for my $u ( @$user_info ) {
  if ($u->{'os'} ) {
    $oss{'linux'}++ if $u->{'os'} =~ /inux/;
    $oss{'windows'}++ if $u->{'os'} =~ /indow/;
  }

  if ( $u->{'lenguajes'} ) {
    my @capitals = ($u->{'lenguajes'} =~ /\b([A-Z]\w*\+*)/g );
    map( $lenguajes{$_ }++, @capitals );
  }
  
}

write_text("r9-user-oss.json", encode_json( \%oss ));
write_text("r9-user-lenguajes.json", encode_json( \%lenguajes ));
