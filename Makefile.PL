#!/usr/bin/perl

use strict;
use warnings;
use 5.006;

use ExtUtils::MakeMaker;

WriteMakefile(
    AUTHOR              => 'Barbie <barbie@cpan.org>',
    NAME                => 'Labyrinth::Plugin::Album',
    VERSION_FROM        => 'lib/Labyrinth/Plugin/Album.pm',
    ABSTRACT            => 'Album plugin for the Labyrinth framework',
    NO_META             => 1,
    PREREQ_PM           => {

        # prereqs
        'Image::Size'               => '0',
        'Labyrinth'                 => '5.10',
        'Labyrinth::Plugin::Hits'   => '5.09',

        # build/test prereqs
        'Test::More'                => '0.70',
        'IO::File'                  => '0'

    }
);
