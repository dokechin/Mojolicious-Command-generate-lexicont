package Mojolicious::Command::generate::lexicont;
use 5.008005;
use strict;
use warnings;
use Mojo::Base 'Mojolicious::Command';
use Lingua::Translate;
use Config::PL;
use Carp;
use Data::Dumper;

__PACKAGE__->attr(description => <<'EOF');
Generate lexicon file translations.
EOF

__PACKAGE__->attr(usage => <<"EOF");
usage: APPLICATION generate lexicont src_lang dest_lang ...
EOF

__PACKAGE__->attr('conf_file');
__PACKAGE__->attr('conf');

our $VERSION = "0.01";


sub run {
    my $self      = shift;
    
    my $arg_num = @_;

    if ($arg_num < 2){
        croak $self->usage;
    }

    my $src_lang  = shift;

    my $app;
    if (ref $self->app eq 'CODE'){
        $app = $self->app->();
    }
    else{
        $app = $self->app;
    }
    my $app_class = ref $app;
    $app_class =~ s{::}{/}g;
    my $app_klass = ref $app;

    my $verbose;

    my @dest_langs = @_;

    my $src_file = $app->home->rel_file("lib/$app_class/I18N/${src_lang}.pm");

    if (! -e $src_file) {
        croak <<NOTFOUND;
Src lexicon not found $src_file
NOTFOUND
    }

    my %srclex = eval {
        require "$app_class/I18N/${src_lang}.pm";
        no strict 'refs';
        %{*{"${app_klass}::I18N::${src_lang}::Lexicon"}};
    };            
    if ($@){
        croak( "error $@" );
    }

    my $conf_file = $self->conf_file || "lingua_translate.conf";
    my $conf;
    eval{
        $conf = config_do $conf_file;
    };
    if ($@){
        croak "Config file cannot read $@ ($conf_file)"
    }
    
    $self->conf($conf);

    for my $dest_lang (@dest_langs){

        my $dest_file = $app->home->rel_file("lib/$app_class/I18N/${dest_lang}.pm");

        my %lexicon = map { $_ => $self->translate( $src_lang, $dest_lang, $srclex{$_}) } keys %srclex;
        

        # Output lexem
        $self->render_to_file('package', $dest_file, $app_klass, $dest_lang,
            \%lexicon);

    }

}

sub translate{

    my $self = shift;
    my $src = shift;
    my $dest = shift;
    my $text = shift;

    my $xl8r;

    eval{
        $xl8r  = Lingua::Translate->new(%{$self->conf}, src => $src, dest => $dest);
    };
    if ($@){
        croak "Lingua::Translate create error $@";
    }
    
    my $trans_text = '';

    eval{
        $trans_text = $xl8r->translate($text);
        if ($self->conf->{back_end} eq "InterTran"){
            sleep(5);
        }
    };
    if ($@){
        warn ("Cannot translate $@");
    }
    return $trans_text;

}

1;

__DATA__
@@ package
% my ($app_class, $language, $lexicon) = @_;
package <%= $app_class %>::I18N::<%= $language %>;
use base '<%= $app_class %>::I18N';
use utf8;

our %Lexicon = (
% foreach my $lexem (sort keys %$lexicon) {
    % my $data = $lexicon->{$lexem} || '';
    % $lexem=~s/'/\\'/g;
    % utf8::encode $data;
    % $data =~s/'/\\'/g;
    % if( $data =~ s/\n/\\n/g ){
    %   $data = '"' . $data . '"';
    % } else {
    %   $data = "'${data}'";
    % }
    % unless ($lexem=~s/\n/\\n/g) {
    '<%= $lexem %>' => <%= $data %>,
    % } else {
    "<%= $lexem %>" => <%= $data %>,
    % };
% }
);

1;

__END__

=encoding utf-8

=head1 NAME

Mojolicious::Command::generate::lexicont - Mojolicious Lexicon Translation Generator

=head1 SYNOPSIS

    APPLICATION generate lexicont src_lang dest_lang ...

=head1 DESCRIPTION

Mojolicious::Command::generate::lexicont is lexicon translation generator.

=head1 CONFIGURATION

Create config file lingua_translate.conf on your project home directory.

for example 

Bing

{
  back_end => "Bing",
  client_id => "YOUR_CLIENT_ID", 
  client_secret => "YOUR_CLIENT_SECRET"
}

Google

{
  back_end => "Google",
  apy_key  => "YOUR_API_KEY",
}

=head1 LICENSE

Copyright (C) dokechin.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

dokechin E<lt>E<gt>

=cut

