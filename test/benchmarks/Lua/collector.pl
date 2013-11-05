#!/usr/bin/perl
if ($#ARGV<3){
  die("Data collector for parallel parsing\n Use as : collector.pl <binary_name> <number of runs> <max_threads> <output_directory>\n");
 }
$parser_name=$ARGV[0];
$number_of_executions=$ARGV[1];
$thread_max=$ARGV[2];
$output_path=$ARGV[3];

if($ARGV[0] =~ /.*parallel.*/){
   $thread_start=2;
}
else{
   $thread_start=1;
}
%input_files=(
  1 => '7k.lua',
  2 => '70k.lua',
  3 => '700k.lua',
  4 => '3.5M.lua',
  5 => '7M.lua',
  6 => '35M.lua',
);

### DATA COLLECTION

while( my($file_idx,$filename) =each(%input_files)){
   $command="./lua_bison ".$filename;
     $bison_time=0.0;
     for($run=0;$run<$number_of_executions;$run++){
      @output=qx($command);
      foreach $line (@output){
        if ($line =~ m/time: .*/){
          @values = split(' ',$line);
          $bison_time+= $values[1];
        }
      }
    }
    $bison_baseline[$file_idx]=$bison_time/$number_of_executions;
}

while( my($file_idx,$filename) =each(%input_files)){
  for ($threadno=$thread_start;$threadno<=$thread_max;$threadno++){
    $command=$parser_name." -j ".$threadno." ".$filename;
    print ("file $filename, index $file_idx, $threadno\n");
    $parse_time=0.0;
    $lex_time=0.0;
    for($run=0;$run<$number_of_executions;$run++){
      @output=qx($command);
      foreach $line (@output){
          if ($line =~ m/Parser.*/){
            @values = split(' ',$line);
            $parse_time+= $values[1];
          }
          elsif ($line =~ m/Lexer.*/){
            @values= split(' ',$line);
            $lex_time+= $values[1];
          }
      }
    }
    $timing_parse[$file_idx][$threadno]=$parse_time/$number_of_executions;
    $timing_lex[$file_idx][$threadno]  =$lex_time  /$number_of_executions;
    $timing_tot[$file_idx][$threadno] =$timing_lex[$file_idx][$threadno]+ $timing_parse[$file_idx][$threadno];
  }
}

### SPEEDUP COMPUTATION AND FILE OUTPUT
# after data collection, output timing results and speedups

open(LEX_RESULTS,   ">".$output_path."/".$parser_name."_lex.dat");
open(PARSE_RESULTS, ">".$output_path."/".$parser_name."_parse.dat");
open(TOT_RESULTS,   ">".$output_path."/".$parser_name."_total.dat");
open(LEX_SPEEDUPS,  ">".$output_path."/".$parser_name."_lex_speedups.dat");
open(PARSE_SPEEDUPS,">".$output_path."/".$parser_name."_parse_speedups.dat");
open(TOT_SPEEDUPS,  ">".$output_path."/".$parser_name."_total_speedups.dat");
open(BISON_SPEEDUPS,">".$output_path."/".$parser_name."_bison_speedups.dat");

## print table header
print LEX_RESULTS "threads ";
print PARSE_RESULTS "threads ";
print LEX_SPEEDUPS "threads ";
print PARSE_SPEEDUPS "threads ";
print TOT_SPEEDUPS "threads ";
print TOT_RESULTS "threads ";
print BISON_SPEEDUPS "threads ";

foreach $file_idx(sort(keys(%input_files))){
  print LEX_RESULTS $input_files{$file_idx}."\t";
  print PARSE_RESULTS $input_files{$file_idx}."\t";
  print LEX_SPEEDUPS $input_files{$file_idx}."\t";
  print PARSE_SPEEDUPS $input_files{$file_idx}."\t";
  print TOT_RESULTS $input_files{$file_idx}."\t";
  print TOT_SPEEDUPS $input_files{$file_idx}."\t";
  print BISON_SPEEDUPS $input_files{$file_idx}."\t";
}

print LEX_RESULTS "\n";
print PARSE_RESULTS "\n";
print TOT_RESULTS "\n";
print LEX_SPEEDUPS "\n";
print PARSE_SPEEDUPS "\n";
print TOT_SPEEDUPS "\n";
print BISON_SPEEDUPS "\n";

#if needed, load baselines from the serial version
if($ARGV[0] =~ /.*parallel.*/){
 $new_pathname=$ARGV[0];
 $new_pathname=~s/(.*)parallel(.*)/\1serial\2/;

 open(LEX_BASELINE_FILE,"<".$output_path."/".$new_pathname."_lex.dat");
 #chow up header line 
 $line=<LEX_BASELINE_FILE>;
 #read actual serial baseline line
 $line=<LEX_BASELINE_FILE>;
 @lex_baseline=split('\t',$line);
# shift(@lex_baseline);
 close(LEX_BASELINE_FILE);
 open(PARSE_BASELINE_FILE,"<".$output_path."/".$new_pathname."_parse.dat");
 #chow up header line 
 $line=<PARSE_BASELINE_FILE>;
 #read actual serial baseline line
 $line=<PARSE_BASELINE_FILE>;
 @parse_baseline=split('\t',$line);
# shift(@parse_baseline);
 close(PARSE_BASELINE_FILE);

 foreach $file_idx(sort(keys(%input_files))){
   $tot_baseline[$file_idx]=$lex_baseline[$file_idx]+ $parse_baseline[$file_idx];
 }
}
else{
   foreach $file_idx(sort(keys(%input_files))){
     $lex_baseline[$file_idx]=$timing_lex[$file_idx][1];
     $parse_baseline[$file_idx]=$timing_parse[$file_idx][1];
     $tot_baseline[$file_idx]=$lex_baseline[$file_idx]+ $parse_baseline[$file_idx];
  }
}

#compute tabular results and output to file
for ($threadno=$thread_start;$threadno<=$thread_max;$threadno++){
  print LEX_RESULTS $threadno."\t";
  print PARSE_RESULTS $threadno."\t";
  print TOT_RESULTS $threadno."\t";
  print LEX_SPEEDUPS $threadno."\t";
  print PARSE_SPEEDUPS $threadno."\t";
  print TOT_SPEEDUPS $threadno."\t";
  print BISON_SPEEDUPS $threadno."\t";

  foreach $file_idx(sort(keys(%input_files))){
    print LEX_RESULTS $timing_lex[$file_idx][$threadno]."\t";
    print PARSE_RESULTS $timing_parse[$file_idx][$threadno]."\t";
    $current_tot= $timing_parse[$file_idx][$threadno] + $timing_lex[$file_idx][$threadno];
    print TOT_RESULTS $current_tot."\t";

    $lex_sup=$lex_baseline[$file_idx]/$timing_lex[$file_idx][$threadno];
    $par_sup=$parse_baseline[$file_idx]/$timing_parse[$file_idx][$threadno];
    $tot_sup=$tot_baseline[$file_idx]/$timing_tot[$file_idx][$threadno];
    $bis_sup=$bison_baseline[$file_idx]/$timing_tot[$file_idx][$threadno];
    print LEX_SPEEDUPS $lex_sup."\t";
    print PARSE_SPEEDUPS $par_sup."\t";
    print TOT_SPEEDUPS $tot_sup."\t";
    print BISON_SPEEDUPS $bis_sup."\t";
}
  print LEX_RESULTS "\n";
  print PARSE_RESULTS "\n";
  print TOT_RESULTS "\n";
  print PARSE_SPEEDUPS "\n";
  print LEX_SPEEDUPS "\n";
  print TOT_SPEEDUPS "\n";
  print BISON_SPEEDUPS "\n";
} 

close(LEX_RESULTS);
close(PARSE_RESULTS);
close(TOT_RESULTS);
close(LEX_SPEEDUPS);
close(TOT_RESULTS);
close(PARSE_SPEEDUPS);
close(BISON_SPEEDUPS);
