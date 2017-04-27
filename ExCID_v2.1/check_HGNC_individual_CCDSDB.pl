#!/usr/bin/perl -w
use strict;


my $annotated_index = $ARGV[0];
my $HGNC = $ARGV[1];

my %words_to_genes = (); # not a perfect index, but will do the same as "grep -w"
open(my $hgnc_fh, "<$HGNC") or die $!;
while (my $line = <$hgnc_fh>) {
    chomp $line;
    my @row = split(/[\s,]/, $line);
    my $gene = shift @row;
    map { $words_to_genes{$_} = $gene } @row;
}
close $hgnc_fh or die $!;

open(my $fh,"<$annotated_index") or die $!;


while (my $line = <$fh>) {
    
    chomp($line);
    
    my ($chr,$start,$Stop,$ID,$in_gene) = split("\t",$line);
    my @transcript_ID_split = split("_exon_",$ID);
    my $transcript_ID = $transcript_ID_split[0] || '';
    my $gene_name = $words_to_genes{$transcript_ID} || '.';

    print "$chr\t$start\t$Stop\t$ID\t$gene_name\n";
    
 
}

close($fh);
