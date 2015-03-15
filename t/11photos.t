#!/usr/bin/perl -w
use strict;

use Data::Dumper;
use Labyrinth::Test::Harness;
use Test::More tests => 44;

my $test_vars = {
        'testing' => '0',
        'copyright' => '2013-2014 Me',
        'cgiroot' => 'http://example.com',
        'lastpagereturn' => '0',
        'autoguest' => '1',
        'administrator' => 'admin@example.com',
        'timeout' => '3600',
        'docroot' => 'http://example.com',
        'mailhost' => '',
        'iname' => 'Test Site',
        'blank' => 'images/blank.png',
        'realm' => 'public',
        'cookiename' => 'session',
        'minpasslen' => '6',
        'maxpasslen' => '20',
        'webdir' => 't/_DBDIR/html',
        'ipaddr' => '',
        'script' => '',
        'requests' => 't/_DBDIR/cgi-bin/config/requests',
        'cgidir' => 't/_DBDIR/cgi-bin',
        'maxpicwidth' => '500',
        'host' => 'example.com',
        'basedir' => 't/_DBDIR',
        'cgipath' => '/cgi-bin',
        'album' => {
                     'iid' => 0
                   },
        'htmltags' => '+img',
        'icode' => 'testsite',
        'evalperl' => '1',
        'webpath' => '',
        'randpicwidth' => '400'
};

my $test_data = { 
    add => {
        'pageid' => '1',
        'title' => 'Archive'
    },
    edit1a => [
        {
          'pageid' => '1',
          'title' => 'Archive'
        },
        {
          'pageid' => '2',
          'title' => 'Home Page'
        },
        {
          'pageid' => '3',
          'title' => 'Test Page'
        }
    ],
    edit2a => [
        {
          'pageid' => '1',
          'title' => 'Archive'
        },
        {
          'pageid' => '2',
          'title' => 'Home Page'
        },
        {
          'pageid' => '3',
          'title' => 'Test Page'
        }
    ],
    edit2b => {
        'dimensions' => '800x600',
        'photoid' => '2',
        'thumb' => '20050830/dscf5904-thumb.jpg',
        'image' => '20050830/dscf5904.jpg',
        'tagline' => undef,
        'cover' => '0',
        'hide' => '0',
        'pageid' => '3',
        'orderno' => '2'
    },
    admin1 => [
        {
          'tagline' => undef,
          'pageid' => '3',
          'title' => 'Test Page',
          'photoid' => '1',
          'thumb' => '20050830/dscf5903-thumb.jpg'
        },
        {
          'tagline' => undef,
          'pageid' => '3',
          'title' => 'Test Page',
          'photoid' => '2',
          'thumb' => '20050830/dscf5904-thumb.jpg'
        }
    ],
    admin3 => [
        {
          'tagline' => undef,
          'pageid' => '3',
          'title' => 'Test Page',
          'photoid' => '1',
          'thumb' => '20050830/dscf5903-thumb.jpg'
        },
        {
          'tagline' => 'Labyrinth',
          'pageid' => '3',
          'title' => 'Test Page',
          'photoid' => '2',
          'thumb' => 'thumb.png'
        }
    ],
    admin4 => {
        'photoid' => '2',
        'thumb' => '',
        'image' => '',
        'tagline' => '',
        'summary' => '',
        'hide' => 0,
        'pageid' => '',
        'title' => 'Labyrinth2'
    },
    view1 => {
        'photo' => {
                 'orderno' => '2',
                 'photoid' => '2',
                 'tagline' => 'Labyrinth',
                 'cover' => '0',
                 'pageid' => '3',
                 'thumb' => 'thumb.png',
                 'hide' => '0',
                 'image' => 'image.jpg',
                 'prev' => '1',
                 'toobig' => 1,
                 'dimensions' => '800x600'
        },
        'page' => {
                'hide' => '0',
                'year' => '2005',
                'summary' => '',
                'title' => 'Test Page',
                'orderno' => '0',
                'path' => 'photos/20050830',
                'month' => 'August',
                'tagline' => '',
                'area' => '1',
                'parent' => '0',
                'pageid' => '3'
        }
    }      
};

my @plugins = qw(
    Labyrinth::Plugin::Album::Photos
);

# -----------------------------------------------------------------------------
# Set up

my $loader = Labyrinth::Test::Harness->new( keep => 0 );
my $dir = $loader->directory;

my $res = $loader->prep(
    sql     => [ "$dir/cgi-bin/db/plugin-base.sql","t/data/test-base.sql" ],
    files   => { 
        't/data/phrasebook.ini' => 'cgi-bin/config/phrasebook.ini'
    },
    config  => {
        'INTERNAL'  => { logclear => 0 }
    }
);
diag($loader->error)    unless($res);

SKIP: {
    skip "Unable to prep the test environment", 44  unless($res);

    $res = is($loader->labyrinth(@plugins),1);
    diag($loader->error)    unless($res);

    # -------------------------------------------------------------------------
    # Public methods

    $res = is($loader->action('Album::Photos::List'),1);
    diag($loader->error)    unless($res);

    my $vars = $loader->vars;
    #diag("list vars=".Dumper($vars));
    is_deeply($vars,$test_vars,'list variables are as expected');

    # -------------------------------------------------------------------------
    # Admin Link methods

    # test bad access

    # refresh instance
    $loader->refresh(
        \@plugins,
        { loggedin => 0, loginid => 2 } );

    # test bad access to admin
    for my $call (  'Album::Photos::Admin','Album::Photos::Add','Album::Photos::Edit','Album::Photos::Move',
                    'Album::Photos::Save','Album::Photos::Delete','Album::Photos::Archive') {
        $res = is($loader->action($call),1);
        diag($loader->error)    unless($res);

        $vars = $loader->vars;
        is($vars->{data},undef,"no permission: $call");
    }
    
    # Add a page
    $loader->refresh(
        \@plugins,
        { loggedin => 1, loginid => 1, data => undef } );

    # test adding a link
    $res = is($loader->action('Album::Photos::Add'),1);
    diag($loader->error)    unless($res);

    $vars = $loader->vars;
    #diag("add vars=".Dumper($vars->{pages}));
    is_deeply($vars->{pages},$test_data->{add},'add variables are as expected');


    # edit with no photo given
    $loader->refresh(
        \@plugins,
        { loggedin => 1, loginid => 1 } );

    $res = is($loader->action('Album::Photos::Edit'),1);
    diag($loader->error)    unless($res);

    $vars = $loader->vars;
    #diag("edit1a vars=".Dumper($vars->{pages}));
    is_deeply($vars->{pages},$test_data->{edit1a},"base data provided, when no photo given");
    #diag("edit1b vars=".Dumper($vars->{record}));
    is_deeply($vars->{record},$test_data->{edit1b},"base data provided, when no photo given");

    # Edit known photo
    $loader->refresh(
        \@plugins,
        { loggedin => 1, loginid => 1 },
        { iid => 2 });

    $res = is($loader->action('Album::Photos::Edit'),1);
    diag($loader->error)    unless($res);

    $vars = $loader->vars;
    #diag("edit2a vars=".Dumper($vars->{pages}));
    is_deeply($vars->{pages},$test_data->{edit2a},"base data provided, with photo given");
    #diag("edit2b vars=".Dumper($vars->{record}));
    is_deeply($vars->{record},$test_data->{edit2b},"base data provided, with photo given");


    # refresh instance
    $loader->refresh(
        \@plugins,
        { loggedin => 1, loginid => 1 } );

    # test basic admin
    $res = is($loader->action('Album::Photos::Admin'),1);
    diag($loader->error)    unless($res);

    $vars = $loader->vars;
    #diag("admin1 vars=".Dumper($vars->{records}));
    is_deeply($vars->{records},$test_data->{admin1},'admin list variables are as expected');


    # save photo, without data
    $loader->refresh(
        \@plugins,
        { loggedin => 1, loginid => 1, data => undef } );

    # test saving a (new and existing) category without order
    $res = is($loader->action('Album::Photos::Save'),1);
    diag($loader->error)    unless($res);
    $vars = $loader->vars;
    is($vars->{thanks},undef,'failed to saved');

    $res = is($loader->action('Album::Photos::Admin'),1);
    diag($loader->error)    unless($res);
    $vars = $loader->vars;
    #diag("admin2 vars=".Dumper($vars->{records}));
    is_deeply($vars->{records},$test_data->{admin1},'admin list variables are as expected');


    # update known photo
    $loader->refresh(
        \@plugins,
        { loggedin => 1, loginid => 1, data => undef },
        { 'pageid' => 3, 'tagline' => 'Labyrinth', 'thumb' => 'thumb.png', 'image' => 'image.jpg', 'photoid' => 2 } );

    $res = is($loader->action('Album::Photos::Save'),1);
    diag($loader->error)    unless($res);
    $vars = $loader->vars;
    is($vars->{thanks_message},'Photo saved successfully.','successful save');

    $res = is($loader->action('Album::Photos::Admin'),1);
    diag($loader->error)    unless($res);
    $vars = $loader->vars;
    #diag("admin3 vars=".Dumper($vars->{records}));
    is_deeply($vars->{records},$test_data->{admin3},'admin list variables are as expected');
    

    # view known photo
    $loader->refresh(
        \@plugins,
        { loggedin => 1, loginid => 1, data => undef },
        { 'photoid' => 2 } );

    $res = is($loader->action('Album::Photos::View'),1);
    diag($loader->error)    unless($res);
    $vars = $loader->vars;
    #diag("view1 vars=".Dumper($vars));
    is_deeply($vars->{photo},$test_data->{view1}{photo},'view1 photo variables are as expected');
    is_deeply($vars->{page},$test_data->{view1}{page},'view1 page variables are as expected');

    # view unknown photo
    $loader->refresh(
        \@plugins,
        { loggedin => 1, loginid => 1, data => undef },
        { 'photoid' => 2999 } );

    $res = is($loader->action('Album::Photos::View'),1);
    diag($loader->error)    unless($res);
    $vars = $loader->vars;
    #diag("view2 vars=".Dumper($vars));
    is($vars->{errcode},'ERROR','admin list variables are as expected');

    # -------------------------------------------------------------------------
    # Admin Link Delete/Save methods - as we change the db

    # archive photo
    $loader->refresh(
        \@plugins,
        { loggedin => 1, loginid => 1, data => undef },
        { photoid => 2 } );

    # test delete via admin
    $res = is($loader->action('Album::Photos::Archive'),1);
    diag($loader->error)    unless($res);
    is($vars->{thanks_message},'Photo archived successfully.','archived successful');

    
    # delete photo
    $loader->refresh(
        \@plugins,
        { loggedin => 1, loginid => 1, data => undef },
        { photoid => 2 } );

    # test delete via admin
    $res = is($loader->action('Album::Photos::Archive'),1);
    diag($loader->error)    unless($res);
    is($vars->{thanks_message},'Photo deleted successfully.','deleted successful');
}
