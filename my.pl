#!/usr/bin/env perl;
use Mojolicious::Lite;
use DBI;
our $dbh = DBI->connect("dbi:SQLite:dbname=my.db3","","", {RaiseError => 1, AutoCommit => 1, sqlite_unicode => 1});

get '/' => sub {
	my $self = shift;
	$dbh->do("CREATE TABLE IF NOT EXISTS notes(id INTEGER,name VARCHAR(25), PRIMARY KEY(id));");
	my $sth = $dbh->prepare("SELECT count(*) FROM notes;");
	$sth->execute;
	my $count = $sth->fetchrow_array();
	if($count < 1) {
	$dbh->do("INSERT INTO notes VALUES(1,'Ed');");
	$dbh->do("INSERT INTO notes VALUES(2,'Lee');");
	}
	$self->render('index');
};
post '/all' => sub {
	my $self = shift;
	my $sth = $dbh->prepare("select id, name from notes");
	$sth->execute;
	my $all = [];
	while(my ($id, $name) = $sth->fetchrow_array()) {
		push @$all,{id=>$id,name=>$name};
	}
	$self->render(json=>{all=>$all});
};
post '/row/:name' => sub {
	my $self = shift;
	my $key = $self->stash('name');
	my $sth = $dbh->prepare("select id, name from notes where name='" . $key ."'");
	$sth->execute;
	my ($id, $name) = $sth->fetchrow;
	$self->render(json=>{id=>$id,name=>$name});
};

app->start;
__DATA__

@@ layouts/default.html.ep
<!doctype html>
<html data-ng-app="my">
<head>
<base href="/" />
<title><%= title %></title>
%= javascript '/mojo/jquery/jquery.js'
%= javascript '/js/angular.min.js';
%= javascript '/js/angular-route.min.js';
%= javascript '/js/my.js';
</head>
<body>
<div><%= content %></div>
</body>
</html>

@@not_found.html.ep
Not Found!
@@ index.html.ep
% layout 'default';
% title 'my';
<div data-ng-view></div>