package Koha::Plugin::Xyz::Paulderscheid::Pomodoro v0.0.2;

use strict;
use warnings;

use base qw(Koha::Plugins::Base);

use Koha::DateUtils qw(dt_from_string);

use JSON qw(decode_json);

our $metadata = {
    'author'           => 'Paul Derscheid <me@paulderscheid.xyz>',
    'date_authored'    => '2024-09-29',
    'date_updated'     => '2024-09-29',
    'description'      => 'This plugin adds a pomodoro widget to the staff interface 🍅',
    'max_koha_version' => q{},
    'min_koha_version' => q{},
    'name'             => 'Koha Plugin Pomodoro',
    'release_filename' => 'koha-plugin-pomodoro',
    'static_dir_name'  => 'static',
    'version'          => '0.0.2'
};

sub new {
    my ( $class, $args ) = @_;

    return $class->SUPER::new( { ( $args // {} )->%*, metadata => { $metadata->%*, class => $class } } );
}

=pod

=head3 upgrade

This subroutine is triggered when a newer version of the plugin is installed over an existing older version.

It is typically used to handle any data migration, cleanup, or updates that need to occur when the plugin is upgraded. The method can store relevant upgrade data, such as the timestamp of the last upgrade.

=over 4

=item *

B<Parameters:>

=over 8

=item *

C<$self> - Koha::Plugin object (plugin instance)

=item *

C<$args> - HashRef containing optional parameters related to the upgrade process

=back

=item *

B<Returns:> Boolean - Returns true to indicate that the upgrade was successful.

=back

=cut

sub upgrade {
    my ( $self, $args ) = @_;

    my $dt = dt_from_string;

    $self->store_data( { last_upgraded => $dt->ymd(q{-}) . q{ } . $dt->hms(q{:}) } );

    return 1;
}

=pod

=head3 configure

This subroutine provides a hook for adding a configuration interface to the plugin.

Plugins can use this method to either display a configuration page where users can adjust 
settings or save the updated settings submitted via a form. The actual logic for rendering 
the configuration page or storing data is flexible and up to the plugin’s needs.

Commonly, the configuration might include fields for enabling or disabling features, setting values,
and storing user-specific data.

The method is designed to be extended and adapted to various plugin requirements.

=over 4

=item *

B<Parameters:>

=over 8

=item *

C<$self> - Koha::Plugin object (plugin instance)

=item *

C<$args> - HashRef containing optional arguments for configuration handling

=back

=item *

B<Returns:> Void

=back

=cut

sub configure {
    my ( $self, $args ) = @_;

    my $template = $self->get_template( { file => q{configure.tt} } );

    return $self->output_html( $template->output );
}

=pod

=head2 api_namespace

This subroutine defines the API namespace for the plugin. It returns the value
C<[a]>, which represents the subdomain in a structured domain format such as
C<[c].[b].[a]>.

In this context, the API namespace is typically used as part of a domain structure,
where C<[a]> is the subdomain, e.g., C<tld.org.project> for C<[a]> = C<project>, 
C<[b]> = C<org>, and C<[c]> = C<tld>.

=over 4

=item *

B<Parameters:> 

=over 8

=item *

C<$self> - Koha::Plugin object (plugin instance)

=back

=item *

B<Returns:> String representing the subdomain (C<[a]>).

=back

=cut

sub api_namespace {
    my $self = shift;

    return 'pomodoro';
}

=pod

=head3 static_routes

This subroutine returns static API routes from a predefined JSON specification file.

It reads the JSON file, parses it, and returns the resulting data structure as a hash reference. 
This method is typically used to provide static API routes that do not change dynamically and 
are predefined in the plugin.

This subroutine depends on the C<JSON> module for decoding the JSON specification.

=over 4

=item *

B<Parameters:>

=over 8

=item *

C<$self> - Koha::Plugin object (plugin instance)

=item *

C<$args> - HashRef containing parameters related to route handling

=back

=item *

B<Returns:> HashRef - The parsed JSON structure representing static API routes.

=back

=cut

sub static_routes {
    my ( $self, $args ) = @_;

    my $spec_str = $self->mbf_read('staticapi.json');
    my $spec     = decode_json($spec_str);

    return $spec;
}

=pod

=head3 intranet_head

This subroutine allows the plugin to add custom CSS to the staff intranet interface.

You can return a string of CSS here, wrapped in C<< <style> >> tags if needed, or include external CSS files by constructing the appropriate HTML. This flexibility allows plugins to style the intranet interface in various ways, including injecting inline styles or linking to external resources.

=over 4

=item *

B<Parameters:>

=over 8

=item *

C<$self> - Koha::Plugin object (plugin instance)

=back

=item *

B<Returns:> String - a string containing HTML, CSS or JavaScript to be included in the intranet head.

=back

=cut

sub intranet_head {
    my $self = shift;

    return q{<script type="module" src="/api/v1/contrib/pomodoro/static/assets/index.js"></script>};
}

=pod

=head3 intranet_js

This subroutine allows the plugin to inject custom JavaScript into the staff intranet interface.

You can return a string of JavaScript wrapped in C<< <script> >> tags if necessary, or include external JavaScript files by constructing the appropriate HTML. This gives the plugin flexibility to include inline JavaScript or reference external JavaScript resources as needed.

=over 4

=item *

B<Parameters:>

=over 8

=item *

C<$self> - Koha::Plugin object (plugin instance)

=back

=item *

B<Returns:> String - a string containing JavaScript or HTML to be included in the intranet.

=back

=cut

sub intranet_js {
    my $self = shift;

    return <<~'JS';
        <script defer>
            const pomodoroTimer = document.createElement('pomodoro-timer');
            document.body.appendChild(pomodoroTimer);
        </script>
    JS
}

1;
