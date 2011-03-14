package Win32::MailboxGUID;

#ABSTRACT: functions to convert Exchange mailbox GUIDs

use strict;
use warnings;

our @ISA            = qw[Exporter];
our @EXPORT_OK      = qw[ad_to_exch exch_to_ad];

my $guidre = qr/^\{[[:xdigit:]]{8}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{12}\}$/i;

sub ad_to_exch {
  my $guid = shift;
  $guid = shift if eval { $guid->isa(__PACKAGE__) };
  return unless $guid;
  my @vals = map { sprintf("%.2X", ord $_) } unpack "(a1)*", $guid;
  return unless scalar @vals == 16;
  return join '', '{', @vals[3,2,1,0], '-', @vals[5,4], '-', @vals[7,6], '-', @vals[8,9], '-', @vals[10..$#vals], '}';
}

sub exch_to_ad {
  my $guid = shift;
  $guid = shift if eval { $guid->isa(__PACKAGE__) };
  return unless $guid;
  return unless $guid =~ /$guidre/i;
  $guid =~ s/[\{\}]+//g;
  my $string = '';
  my $count = 0;

  $string .= "\\$_" for
    map { $count++; ( $count >= 4 ? ( unpack "(A2)*", $_ ) : ( reverse unpack "(A2)*", $_ ) ) }
      split /\-/, $guid;

  return $string;
}

q"GUID! GUID, GUID, gum gum";

=pod

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 FUNCTIONS

=over

=item C<ad_to_exch>

=item C<exch_to_ad>

=back

=cut
