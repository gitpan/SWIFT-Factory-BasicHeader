package SWIFT::Factory::BasicHeader;
use strict;
use warnings;

use vars qw($VERSION);
$VERSION = '0.01';

BEGIN{
   *provide=*string;
}

use constant APP_ID_FIN=>'F';
use constant APP_ID_GPA=>'A';
use constant APP_ID_GPA_LOG=>'L';

use constant SERVICE_ID_USER_2_USER=>1;

############################################################
# The Basic Header is block number 1 of a SWIFT message.
# This block appears in all SWIFT messages.
#
# The block is normally built for "input", which in SWIFT
# speak means "input to the SWIFT network".
#
# This module will implement an "Input Basic Header".
#
# To create an output basic block, subclass this class and
# implement the required specifics.
############################################################
sub new {
   my$self={};
   bless($self,shift())->_init(@_);
}

############################################################
sub string {
   my$self=shift;
   '{1:'.
   $self->{APP_ID}.
   sprintf("%02u",$self->{SERVICE_ID}).
   $self->{BIC}.
   $self->{TERMINAL}.
   $self->{BRANCH_CODE}.
   sprintf("%04u",$self->{SESS_NBR}).
   sprintf("%06u",$self->{I_SEQ_NBR}).
   '}';
}

############################################################
sub version {
   $VERSION;
}

############################################################
sub _init {
   my$self=shift;
   my%args=(
      APPLICATION_ID=>APP_ID_FIN,
      SERVICE_ID=>SERVICE_ID_USER_2_USER,
      BIC=>'X'x8,          # Reciever BIC for SWIFT input msg.
      TERMINAL=>'X',       # Reciever Terminal for SWIFT input msg.
      BRANCH_CODE=>'X'x3,  # Reciever Branch code for SWIFT input msg.
      SESSION_NBR=>0,
      INPUT_SEQUENCE_NBR=>0,
      @_
   );
   $self->{APP_ID}=$args{APPLICATION_ID};
   $self->{SERVICE_ID}=$args{SERVICE_ID};
   $self->{BIC}=$args{BIC};
   $self->{TERMINAL}=$args{TERMINAL};
   $self->{BRANCH_CODE}=$args{BRANCH_CODE};
   $self->{SESS_NBR}=$args{SESSION_NBR};
   $self->{I_SEQ_NBR}=$args{INPUT_SEQUENCE_NBR};
   $self;
}

'Choppers rule';
__END__

=head1 NAME

SWIFT::Factory::BasicHeader - Provides a Basic Header Block (Block 1) for a SWIFT message.

=head1 SYNOPSIS

  use SWIFT::Factory::BasicHeader;
  my $hdr1=SWIFT::Factory::BasicHeader->new();

=head1 DESCRIPTION

This module is primarily intended to be used by the different SWIFT::Factory::MTnnn modules to provide full SWIFT messages for input to the SWIFT network.

Nevertheless, there is nothing prohibiting an application to directly use this module for whatever purpose.

Given reasonable parameter values in the constructor, the string method in this module will return a Basic Header Block (Block nbr 1) that can be used in a SWIFT message sent to the SWIFT network.

=head1 CONSTRUCTOR

=head4 new( APPLICATION_ID=>'F', SERVICE_ID=>1, BIC=>'VALIDBIC', TERMINAL=>'X', BRANCH_CODE=>'XXX', SESSION_NBR=>0, INPUT_SEQUENCE_NBR=>0)

=over 4

The parameters may be given in arbitrary order.

=item C<APPLICATION_ID=E<gt>>

Optional. A one character value that indicates the application within which the message is being sent.

Valid values are:

  'F' (FIN = All user-to-user, FIN system and FIN system msgs),
  'A' (GPA = Most GPA system mesgs)
  and
  'L' (Certain GPA msgs, for ex. LOGIN).

  Default value: 'F', which is the most commonly used application.

  To set this value, use one of:

  SWIFT::Factory::BasicHeader->APP_ID_FIN,
  SWIFT::Factory::BasicHeader->APP_ID_GPA,
  and
  SWIFT::Factory::BasicHeader->APP_ID_GPA_LOG.

  Yes, these are 'constants', and yes, since they are class methods they are available before calling the constructor.
  Opposit of the object methods that are functional only after having called the new() constructor.

=item C<SERVICE_ID=E<gt>>

Optional. A numeric value that identifies the type of data that is being sent.
Maximum two characters long.
See the relevant SWIFT handbook for details.

Default value: 1, which will output as '01'.

=item C<BIC=E<gt>>

Technically optional,
but it will probably quite rarely make sense to instantiate an object of this class without specifying a BIC.
An eight character value that contains a valid reciever BIC.

=item C<TERMINAL=E<gt>>

Optional. A one character value that identifies the recieving terminal.

Default value: 'X'.

=item C<BRANCH_CODE=E<gt>>

Optional. A three character value that identifies the branch code at the reciever.

Default value: 'XXX'.

=item C<SESSION_NBR=E<gt>>

Optional.
A numeric value.
Maximum four characters long.
See the relevant SWIFT handbook for details.

Default value: 0, which will output as '0000'.

=item C<INPUT_SEQUENCE_NBR=E<gt>>

Optional. A numeric value.
Maximum six characters long.
See the relevant SWIFT handbook for details.

Default value: 0, which will output as '000000'.

=back

=head2 Example:

=head4 new( APPLICATION_ID=>SWIFT::Factory::BasicHeader->APP_ID_FIN, BIC=>'VALIDBIC', INPUT_SEQUENCE_NBR=>2)

=head1 PUBLIC METHODS

=over 4

=item string()

Will return a fully formatted string containing a Basic Header Block 1 for a SWIFT message.

=item provide()

An alias for string(). Will execute exactly the same code as the string() method.

=item version()

Will return the version of this Perl module.

=back

=head1 AUTHOR

Gustav Schaffter, E<lt>schaffter_cpan@hotmail.comE<gt>

=head1 COPYRIGHT

Copyright (c) 2003, Gustav Schaffter. All rights reserved.
This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

Appropriate SWIFT documentation.

=cut

