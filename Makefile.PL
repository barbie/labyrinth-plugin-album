use 5.006;
use ExtUtils::MakeMaker;
WriteMakefile(
    NAME            => 'Labyrinth::Plugin::Album',
    VERSION_FROM    => 'lib/Labyrinth/Plugin/Album.pm',
    PREREQ_PM       => {
        'Image::Size'               => '0',
        'Labyrinth'                 => '5.10',
        'Labyrinth::Plugin::Hits'   => '5.09'
    },
    NO_META     => 1,
    ABSTRACT    => 'Album plugin for the Labyrinth framework',
    AUTHOR      => 'Barbie <barbie@cpan.org>',
);
