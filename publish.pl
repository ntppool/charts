#!/usr/bin/env perl
use v5.30.0;
use warnings;
use Carp qw(croak);

my %repos = (
    "k8s-at-home-library" => "https://library-charts.k8s-at-home.com",
    "bjw-s"               => "https://bjw-s.github.io/helm-charts/",
    "stable"              => "https://charts.helm.sh/stable",
);

chdir "charts" or die "could not chdir to charts: $!";

my @charts = grep { -d $_ } glob "*";

my @publish;

my $helm_url = $ENV{HELM_URL};

my $commit = $ENV{DRONE_COMMIT_MESSAGE};

$commit =~ m/^(\S+):/sm;
push @publish, $1 if $1;

push @publish, ($commit =~ m/\#(\S+)/gsm);

my %charts = map { $_ => 1 } @charts;

@publish = grep { my $ok = $charts{$_}; $charts{$_} = 0; $ok } @publish;

say "publish ", join ", ", @publish;

#run(qq[helm --username "\$HELM_USERNAME" --password="\$HELM_PASSWORD" repo add ntppool ${helm_url}], {silent => 1});

run(qq[helm repo add ntppush ${helm_url}], {silent => 0});

for my $repo (sort keys %repos) {
    run(qq[helm repo add "$repo" "$repos{$repo}"]);
}

run("helm repo update");

mkdir "build" or die "could not create build directory: $!";

for my $chart (@publish) {

    #run("helm dependency build $chart");
    run("helm package -d build/ -u $chart");
    run("helm s3 push --relative build/$chart*.tgz ntppush");    # add --ignore-if-exists ?
}

if ($ENV{FASTLY_API_TOKEN} && $ENV{FASTLY_SERVICE_ID}) {
    run("fastly -i purge --soft --url https://charts.ntppool.org/charts/index.yaml");
}

sub run {
    my @ar    = @_;
    my $parms = ref $ar[-1] eq "HASH" ? pop @ar : {};

    print "Running: ", join(" ", @ar), "\n" unless $parms->{silent};

    return 1 if system(@ar) == 0;

    my $exit_value = $? >> 8;
    return 0
      if $parms->{fail_silent_if}
      && $exit_value == $parms->{fail_silent_if};

    my $msg = "system @ar failed: $exit_value ($?)";
    croak($msg) unless $parms->{failok};
    print "$msg\n";
    return 0;
}
