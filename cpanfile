requires 'perl', '5.008001';
requires 'Mojolicious';
requires 'Lingua::Translate';
requires 'Config::PL';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

