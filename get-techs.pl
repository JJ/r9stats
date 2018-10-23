#!/usr/bin/env perl

# Extraer las tecnologías que usan una serie de miembros de un Meetup

use strict;
use warnings;
use v5.14;

use JSON;
use LWP::UserAgent;
use File::Slurper qw(read_lines write_text);
use Unicode::Normalize;

my $file = shift || "IX_Jornadas_de_Usuarios_de_R.csv";

my $API_KEY = $ENV{"MEETUP_API_KEY"};
my $ua = LWP::UserAgent->new;

my @members = read_lines($file);

shift @members;
my @user_info;
for my $m ( @members ) {
  my @parts = split(/,/, $m);
  my ($id) = ($parts[1] =~ /(\d+)/);
  if ( !$id ) {
    ($id) = ($parts[8] =~ /(\d+)/);
  }

  # Encuentra el género
  my ($name,@cosas) = split( /\s+/, $parts[0] );
  my $decomposed = NFKD( $name );
  $decomposed =~ s/\p{NonspacingMark}//g;
  $name = $decomposed;
  my $gender_response = $ua->get("https://api.genderize.io/?name=$name");
  my $gender;
  if ( $gender_response->is_success ) {
    my $gender_json = decode_json $gender_response->decoded_content;
    if ( $gender_json->{'probability'} &&  $gender_json->{'probability'} > 0.55 ) {
      $gender = $gender_json->{'gender'};
    } else {
      say "Can't say $name";
      $gender = "X";
    }
  }
}

write_text("r9-user-info.json", encode_json( \@user_info ));


