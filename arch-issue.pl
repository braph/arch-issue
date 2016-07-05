#!/bin/perl

eval 'exec /usr/bin/perl  -S $0 ${1+"$@"}'
    if 0; # not running under some shell

=begin COPYRIGHT

	arch-issue - generate an arch linux /etc/issue
	Copyright (C) 2015 Benjamin Abendroth
	
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.

=end COPYRIGHT

=cut

use strict;
use warnings;
use Term::ANSIColor qw(:constants color);
use IPC::System::Simple qw(capturex);
use Getopt::Long qw(:config gnu_getopt auto_version);

GetOptions(
   'preview|p' => \(my $preview = 0),
   'color1=s'  => \(my $color1 = 'white'),
   'color2=s'  => \(my $color2 = 'blue'),

   'help|h'    => sub {
      require Pod::Usage;
      Pod::Usage::pod2usage(-exitstatus => 0, -verbose => 2);
   }
) or exit 1;

sub _color {
   return color($_[0]) . $_[1] . CLEAR;
}

sub _bright {
   return color("bold $_[0]") . $_[1] . CLEAR;
}


my @logo = split "\n", q{
         ,
        /#\
       /###\
      /#####\
     /##.-.##\
    /##(   )##\
   /#.--   --.#\
  /´           `\
};
shift @logo; #remove newline

$_ = _color($color1, $_)  for @logo[0..1];
$_ = _bright($color1, $_) for @logo[2..3];
$_ = _bright($color2, $_) for @logo[4..5];
$_ = _color($color2, $_)  for @logo[6..7];

my @arch =  map { _bright($color1, $_) } split "\n", capturex('figlet', 'arch');
my @linux = map { _bright($color2, $_) } split "\n", capturex('figlet', 'linux');

# pad the logo
my @result = map { sprintf "%-*s", 34, $_ } @logo;

# logo + "arch" + "linux"
for (0 .. $#arch) {
   $result[1 + $_] .= $arch[$_] . $linux[$_];
}

my $joined = join "\n", @result;
$joined =~ s/\\/\\\\/g if ! $preview;

print "\e[H\e[2J\n", $joined, q{

  Hostname:   \n
  Kernel:     \s \r \m
  Users:      \u
  Line:       \l
  Date:       \d \t

};

__END__

=pod

=head1 NAME

arch-issue - generate an arch linux /etc/issue

=head1 SYNOPSIS

=over 8

arch-issue
[B<--preview|-p>]
[B<--color1>=COLOR]
[B<--color2>=COLOR]

=back

=head1 OPTIONS

=head2 Basic Startup Options

=over

=item B<--help>

Display this help text and exit.

=item B<--version>

Display the script version and exit.

=back

=head1 Options

=over

=item B<--preview|-p>

Preview mode.

=item B<--color1>

Set first color.

=item B<--color2>

Set second color.

=back

=head1 AUTHOR

Written by Benjamin Abendroth.

=cut

