#!/usr/bin/env perl

use strict;
use warnings;
use v5.14;

use JSON;
use LWP::UserAgent;
use File::Slurper qw(read_lines write_text);
use Unicode::Normalize;

my $file = "../../Descargas/IX_Jornadas_de_Usuarios_de_R(2).xls";

my $gg_gid = 19214694;

my $API_KEY = $ENV{"MEETUP_API_KEY"};
my $ua = LWP::UserAgent->new;

my @members = read_lines($file);

shift @members;
my @user_info;
for my $m ( @members ) {
  next if $m !~ /\d/;
  say "→ $m";
  my @parts = split(/\t/, $m);
  my ($id) = ($parts[1] =~ /(\d+)/);
  if ( !$id ) {
    ($id) = ($parts[8] =~ /(\d+)/);
  }
  my $response = $ua->get("https://api.meetup.com/2/profile/$gg_gid/$id?&sign=true&key=$API_KEY");
  if ( $response->is_success ) {
      my $user_json = $response->decoded_content;
      my $this_user = decode_json $user_json;

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
      push @user_info, {inscrito => $parts[6],
			registrado => $parts[7],
			lenguajes => $this_user->{'answers'}[0]{'answer'},
			os => $this_user->{'answers'}[1]{'answer'},
			sexo => $gender };
      say $response->header("X-RateLimit-Remaining"), " to go ";
      if ( $response->header("X-RateLimit-Remaining") <= 1 ) {
	sleep($response->header("X-RateLimit-Reset"));
	say "Sleeping";
      }
  } else {
    say "Error → ", $response->status_line;
    say $response->header("X-RateLimit-Reset");
    say $response->header("X-RateLimit-Limit");
  }
}

write_text("r9-user-info.json", encode_json( \@user_info ));


