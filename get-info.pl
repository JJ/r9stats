#!/usr/bin/env perl

use strict;
use warnings;
use v5.14;

use JSON;
use LWP::Simple;
use File::Slurper qw(read_lines);

my $file = "../../Documentos/IX_Jornadas_de_Usuarios_de_R.csv";

my $gg_gid = 19214694;

my $API_KEY = $ENV{"MEETUP_API_KEY"};

my @members = read_lines($file);

shift @members;
my @user_info;
for my $m ( @members ) {
  my @parts = split(/\t/, $m);
  my ($id) = ($parts[1] =~ /(\d+)/);
  my $user_json = get "https://api.meetup.com/2/profile/$gg_gid/$id?&sign=true&key=$API_KEY";
  my $this_user = decode_json $user_json;
  push @user_info, { lenguajes => $this_user->{'answers'}[0]{'answer'},
		     os => $this_user->{'answers'}[1]{'answer'} };
}

write_text("r9-user-info.json",encode_json( @user_info ));

my %oss;
my %lenguajes;
for my $u ( @user_info ) {
  $oss{'linux'}++ if $u->{'os'} =~ /inux/;
  $oss{'windows'}++ if $u->{'os'} =~ /indow/;
}
