package Dist::Zilla::Plugin::CheckChangeLog;

# ABSTRACT: Dist::Zilla with Changes check

use 5.004;
use Moose;
use Moose::Autobox;
with 'Dist::Zilla::Role::InstallTool';

has filename => (
    is      => 'ro',
    isa     => 'Str',
    default => '',
);

sub setup_installer {
    my ( $self, undef ) = @_;

    my @change_files;
    my $filename = $self->{filename};
    if ($filename) {
        my $file = $self->zilla->root->file($filename);
        die "[CheckChangeLog] $! $file\n" unless -e $file;
        push @change_files,
          Dist::Zilla::File::OnDisk->new( { name => $filename } );
    }
    else {
        # grep files to check if there is any Changes file
        my $filter = sub {
            $_->name =~ m/Change/i
              and $_->name ne $self->zilla->main_module->name;
        };

        my $files = $self->zilla->files->grep($filter);
        undef $filter;
        if ( scalar @$files ) {
            push @change_files, @$files;
        }
        else {
            die "[CheckChangeLog] No changelog file found.\n";
        }
    }

    my $zilla_ver = $self->zilla->version;
    foreach my $file (@change_files) {
        my $ok = $self->check_file_for_version( $file->content, $zilla_ver );
        if ($ok) {
            $self->log( "[CheckChangeLog] OK with " . $file->name );
            return;
        }

        # XXX? prompt to edit?
    }

    print "[CheckChangeLog] No Change Log in "
      . join( ', ', map { $_->name } @change_files ) . "\n";
    die "[CheckChangeLog] Please edit\n";

    return;
}

sub check_file_for_version {
    my ( $self, $content, $version ) = @_;

    my @lines = split( /\n/, $content );
    foreach (@lines) {

        # no blanket lines
        next unless /\S/;

        # skip things that look like bullets
        next if /^\s+/;
        next if /^\*/;
        next if /^\-/;

        # seen it?
        return 1 if /\Q$version\E/;
    }
    return 0;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

=head1 SYNOPSIS
 
    # dist.ini
    [CheckChangeLog]
    
    # or
    [CheckChangeLog]
    filename = Changes.pod

=head1 DESCRIPTION

The code is mostly a copy-paste of L<ShipIt::Step::CheckChangeLog> 

=head1 METHODS

=head2 setup_installer

=head2 check_file_for_version($content_str, $version_str)

=head1 AUTHORS

Fayland Lam, C<< <fayland at gmail.com> >>

=cut
