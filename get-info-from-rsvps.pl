#!/usr/bin/env perl

use strict;
use warnings;
use v5.14;

use JSON;
use LWP::UserAgent;
use File::Slurper qw(read_text write_text);
use Unicode::Normalize;

my $file = "rsvps.json"; # Fichero privado que hay que descargarse desde la API
my $rsvps_json = read_text($file);
my $rsvps = from_json $rsvps_json;

my $gg_gid = 19214694;

my $API_KEY = $ENV{"MEETUP_API_KEY"};
my $ua = LWP::UserAgent->new;

my @user_info;
for my $k ( sort { $a <=> $b} keys %$rsvps ) {
  my $m = $rsvps->{$k};
  my $member = $m->{'member'};
  say "→ ",$member->{'name'};
  my $user = {inscrito => $m->{'created'},
	      registrado => $m->{'updated'},
	      asistira => $m-> {'response'}
	     };
  my $id = $member->{'id'};
  my $response = $ua->get("https://api.meetup.com/2/profile/$gg_gid/$id?&sign=true&key=$API_KEY");
  if ( $response->is_success ) {
    my $user_json = $response->decoded_content;
    my $this_user = decode_json $user_json;

    # Lenguajes y OS
    $user->{'lenguajes'} = $this_user->{'answers'}[0]{'answer'};
    $user->{'os'} = $this_user->{'answers'}[1]{'answer'};

    # Encuentra el género
    my ($name) = split(/\s+/,$member->{'name'});
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
    $user->{'sexo'} = $gender;

    # Resto de datos del perfil
    my $user_response = $ua->get("https://api.meetup.com/2/member/$id?&sign=true&key=$API_KEY");
    
    if ( $user_response->is_success ) {
      my $profile_json = $user_response->decoded_content;
      my $this_profile = decode_json $profile_json;
      $user->{'lon'} = $this_profile->{'lon'};
      $user->{'lat'} = $this_profile->{'lat'};
      $user->{'city'} = $this_profile->{'city'};
    }
    
    push @user_info, $user;
    say $response->header("X-RateLimit-Remaining"), " to go ";
    if ( $response->header("X-RateLimit-Remaining") <= 2 ) {
      sleep($response->header("X-RateLimit-Reset"));
      say "Sleeping";
    }
  } else {
    say "Error → ", $response->status_line;
    say $response->header("X-RateLimit-Reset");
    say $response->header("X-RateLimit-Limit");
  }
}

write_text("r9-user-info.json", to_json( \@user_info ));


