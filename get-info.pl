#!/usr/bin/env perl

use strict;
use warnings;
use v5.14;

use JSON;
use LWP::UserAgent;
use File::Slurper qw(read_lines);

my $file = "IX_Jornadas_de_Usuarios_de_R.csv";

my $gg_gid = 19214694;

my $API_KEY = $ENV{"MEETUP_API_KEY"};
my $ua = LWP::UserAgent->new;

my @members = read_lines($file);

shift @members;
my @user_info;
for my $m ( @members ) {
  my @parts = split(/\t/, $m);
  my ($id) = ($parts[1] =~ /(\d+)/);
  my $response = $ua->get("https://api.meetup.com/2/profile/$gg_gid/$id?&sign=true&key=$API_KEY");
  if ( $response->is_success) {
      my $user_json = $response->decoded_content;
      my $this_user = decode_json $user_json;
      push @user_info, { lenguajes => $this_user->{'answers'}[0]{'answer'},
			 os => $this_user->{'answers'}[1]{'answer'} };
  } else {
      say $response->status_line;
      say $response->
}

write_text("r9-user-info.json",encode_json( @user_info ));

my %oss;
my %lenguajes;
for my $u ( @user_info ) {
  $oss{'linux'}++ if $u->{'os'} =~ /inux/;
  $oss{'windows'}++ if $u->{'os'} =~ /indow/;
}
