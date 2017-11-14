#!/usr/bin/env perl

use strict;
use warnings;
use v5.14;

use JSON;
use File::Slurper qw(read_text write_text);
use DateTime::Format::Strptime;

my $file = "r9-user-info.json";

my $user_info = decode_json( read_text($file) );

my %oss;
my %lenguajes;
my @lenguajes = qw(R Python Java C++ C Matlab SPSS SQL SAS JavaScript);

my $strp = DateTime::Format::Strptime->new(
					   pattern   => '%m/%d/%Y',
					   locale    => 'es_ES',
					   time_zone => 'Europe/Madrid'
					  );
my @oss = qw( linux windows mac);

my @columnas = qw( days );
push @columnas, @oss;
push @columnas, @lenguajes;

say join(", ", @columnas);
for my $u ( @$user_info ) {
  my %user;
  if ($u->{'os'} ) {
    $user{'linux'}++ if $u->{'os'} =~ /inux/;
    $user{'windows'}++ if $u->{'os'} =~ /indow/;
    $user{'mac'}++ if $u->{'os'} =~ /ac/;
  }

  if ( $u->{'lenguajes'} ) {
    my @capitals = ($u->{'lenguajes'} =~ /\b([A-Z]\w*\+*)/g );
    my %estos_lenguajes;
    map( $estos_lenguajes{$_ }++, @capitals );
    for my $l ( @lenguajes ) {
      $user{$l} = 1 if ( $estos_lenguajes{$l} );
    }
  }

  my $registro = $strp->parse_datetime( $u->{'registrado'} );
  my $inscripcion = $strp->parse_datetime( $u->{'inscrito'} );
  $user{'days'} = $registro->delta_days($inscripcion)->delta_days;

  my @data = map( $user{$_}, @columnas );

  say join(", ", map( $_ // 0, @data ) );
  
}


