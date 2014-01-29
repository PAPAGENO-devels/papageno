#!/usr/bin/perl
#full regression test script for lua parser

$file_ls=qx(ls grim);
@file_list=split("\n",$file_ls);
foreach $file(@file_list){
  print "analyzing $file: ";
  @output=qx(../lua_serial_lexer_brack -j 2 grim/$file); 
  split(' ',$output[1]);
  print "@_[0]"
}
