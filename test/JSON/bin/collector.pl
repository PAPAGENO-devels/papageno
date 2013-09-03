#!/usr/bin/perl
$parser_name="./json_parser";
$number_of_executions=3.0;
@thread_number=("1","2","3","4");
%input_files=(
  1 => 'G2700',
  2 => 'G30000',
  3 => 'G80000',
  4 => 'G150000',
  5 => 'G1600000',
#  6 => 'G10000000',
#  7 => 'G75000000',
);

while( my($file_idx,$filename) =each(%input_files)){
  foreach $threadno(@thread_number){
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
  }
}
while( my($file_idx,$filename) =each(%input_files)){
  print "timing for ".$filename." index".$file_idx."\n";
  foreach $threadno(@thread_number){
    print $timing_parse[$file_idx][$threadno]." ";
  }
  print "\n";
}
