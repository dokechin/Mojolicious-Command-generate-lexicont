# NAME

Mojolicious::Command::generate::lexicont - Mojolicious Lexicon Translation Generator

# SYNOPSIS

    # You write en.pm and generate fr.pm
    # All the lexicon described in en.pm will translate.
    ./script/my_app generate lexicont en fr
    

    # You write en.pm and generate de.pm, fr.pm and ru.pm.
    # All the lexicon described in en.pm will translate.
    ./script/my_app generate lexicont en de fr ru

    # You write org.pm and generate en.pm, de.pm, fr.pm and ru.pm.
    # Difference between org.pm and en.pm will translate.
    ./script/my_app generate lexicont en de fr ru

# DESCRIPTION

Mojolicious::Command::generate::lexicont is lexicon translation generator.

Mojolicious::Plugin::I18N is standard I18N module for Mojolicious.
For example English, you must make lexicon file in the package Myapp::I18N::en.
This module is lexicon file generator from one language to specified languages using
Lingua::Translate. So you can customize translation service.

It is not convenient every time all the lexicons are translated.
Write the lexicon in the package Myapp::I18N::org, and generate only difference parts.

# CONFIGURATION

Create config file lexicont.conf on your project home directory.



\#InterTran

{
    lingua\_translate => {
      back\_end => "InterTran",
    },
    sleep => 5,
}

\#Bing

{
    lingua\_translate => {
        back\_end => "BingWrapper",
        client\_id => "YOUR\_CLIENT\_ID", 
        client\_secret => "YOUR\_CLIENT\_SECRET"
    }
}



\#Google

{
    lingua\_translate => {
        back\_end => "Google",
        api\_key => "YOUR\_API\_KEY", 
    }
}







# LICENSE

Copyright (C) dokechin.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

dokechin <>
