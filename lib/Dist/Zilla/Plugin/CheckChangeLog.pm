package Dist::Zilla::Plugin::CheckChangeLog;

# ABSTRACT: Dist::Zilla with Changes check

use Moose;
with 'Dist::Zilla::Role::InstallTool';

=head1 SYNOPSIS
 
    # dist.ini
    [CheckChangeLog]

=head1 DESCRIPTION

The code is mostly a copy-paste of L<ShipIt::Step::CheckChangeLog>
 
=cut

sub setup_installer {
    my ($self, $arg) = @_;

    # grep files to check if there is any Changes file
  
    return;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
