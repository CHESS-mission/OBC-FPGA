#!/usr/bin/perl
# filename:          projectManager.vhd
# created by:        Corthay Francois, Gubler Oliver
#
#-------------------------------------------------------------------------------
#
# Description: 
#   Updates the file references in the .prj Libero project file
#   and launches the Libero project manager
#
#-------------------------------------------------------------------------------
#
# History:
#   V0.3 : guo 08.2015 	-- change to ENV variables from HELS
#						-- removed passage of fileSpec as param
#						-- added path modificaton in designer file
#   V0.2 : guo 08.2014 	-- create nonexisting projectDir
#					   	-- unified printing
#   V0.1 : cof 12.2013 	-- Initial release
#
################################################################################

use File::Copy qw(copy);
use File::Path qw(mkpath);

$separator = '-' x 79;
$indent = ' ' x 2;
$verbose = 1;

$ENV{TZ} = ''; # needed to be able to run Synplify avoinding license error
my $designerExe = "$ENV{SYNTHESIS_HOME}\\Designer\\bin\\libero.exe";
#my $actelFileSpec = $ARGV[0];
#$actelFileSpec =~ s/\//\\/g;
#$actelFileSpec =~ s/\\\w+\\\.\.//;
my $actelFileSpec = "$ENV{SYNTHESIS_WORK_DIR}\\$ENV{DESIGN_NAME}.prjx";

#-------------------------------------------------------------------------------
# Project variables
#
                                                              # source directory
#my $sourceDir = $actelFileSpec;
#$sourceDir =~ s/\.\w+\Z//;
#$sourceDir =~ s/\\\w+\Z//;
#$sourceDir =~ s/\\actel\Z/\\concat/;
my $sourceDir = $ENV{HDS_CONCAT_DIR};
                                                             # generic file spec
#my $sourceFile = $actelFileSpec;
#$sourceFile =~ s/\.\w+\Z//;
#$sourceFile =~ s/\A.+\\//;
my $sourceFile = $ENV{DESIGN_NAME};
                                                             # source file specs
my $vhdlFileSpec = "$ENV{HDS_CONCAT_DIR}\\$sourceFile.vhd";
my $pdcFileSpec = "$ENV{HDS_CONCAT_DIR}\\$sourceFile.pdc";
                                                                # work directory
my $projectDir = "$ENV{LIBERO_SCRATCH_WORK_DIR}";
# unless (-d $projectDir) {
  # mkpath($projectDir) or die "ERROR: Failed to create path: $projectDir";
  # print "\n$separator\nCreated directory: $projectDir\n";
# }
                                                                # work file spec
$actelWorkFileSpec = "$ENV{LIBERO_SCRATCH_PRJX}";

if ($verbose == 1) {
  print "\n$separator\n";
  print "actelApp: $designerExe\n";
  print "actelFile: $actelFileSpec\n";
  print "sourceDir: $sourceDir\n";
  print "sourceFile: $sourceFile\n";
  print "vhdlFileSpec: $vhdlFileSpec\n";
  print "pdcFileSpec: $pdcFileSpec\n";
  print "projectDir: $projectDir\n";
}

#------------------------------------------------------------------------------
# Global variables
#
my $line;

#-------------------------------------------------------------------------------
# Update paths in the libero project file
#
if ($verbose == 1) {
  print "\n$separator\n";
  print "Updating file specifications in\n";
  print $indent, $actelFileSpec, "\n";
  print "to\n"; 
  print $indent, $actelWorkFileSpec, "\n";
}
# open(ActelFile, "<$actelFileSpec") || die "ERROR: Couldn't open $actelFileSpec!";
# open(workFile, ">$actelWorkFileSpec");
# while (chop($line = <ActelFile>)) {
# while (<ActelFile>) {
  # chomp;
  # $line = $_;
                                               # # replace source path
  # if ($line =~ m/DEFAULT_IMPORT_LOC/i) {
    # $line =~ s/".*"/"$sourceDir"/;
  # }
                                                          # # replace project path
  # if ($line =~ m/ProjectLocation/i) {
    # $line =~ s/".*"/"$projectDir"/;
  # }
                                                        # # replace VHDL file spec
  # if ($line =~ m/VALUE\s".*,hdl"/i) {
    # $line =~ s/".*"/"$vhdlFileSpec,hdl"/;
  # }
                                                         # # replace PDC file spec
  # if ($line =~ m/VALUE\s".*\.pdc,pdc"/i) {
    # $line =~ s/".*"/"$pdcFileSpec,pdc"/;
  # }
  
  # print workFile ("$line\n");
# }
# close(workFile);
# close(ActelFile);

#-------------------------------------------------------------------------------
# Update paths in the designer project file
#
my $designerProject = $ENV{LIBERO_PROJECT_IDEDES_FILE};
my $designerScratch = $ENV{LIBERO_SCRATCH_IDEDES_FILE};
if ($verbose == 1) {
  print "\n$separator\n";
  print "Updating file specifications in\n";
  print $indent, $designerProject, "\n";
  print "to\n"; 
  print $indent, $designerScratch, "\n";
}
# open(designerProject_fh, "<$designerProject") || die "ERROR: Couldn't open $designerProject!";
# open(designerScratch_fh, ">$designerScratch");
# # while (chop($line = <ActelFile>)) {
# while (<designerProject_fh>) {
  # chomp;
  # $line = $_;
  # # point to original constraints file
  # if ($line =~ m/VALUE.*pdc/i) {
    # $line =~ s/".*\\/"$sourceDir\\/;
  # }
  
  # print designerScratch_fh ("$line\n");
# }
# close(designerScratch_fh);
# close(designerProject_fh);

# #-------------------------------------------------------------------------------
# # delete original file and rename temporary file
# #
# if ($verbose == 1) {
  # print "\n$separator\n";
  # print "Replace $actelFileSpec with temporary file $actelWorkFileSpec.\n";
# }
# unlink($actelFileSpec);
# #rename($actelWorkFileSpec, $actelFileSpec);
# copy($actelWorkFileSpec, $actelFileSpec);

#-------------------------------------------------------------------------------
# launch libero with temporary file
#
if ($verbose == 1) {
  print "\n$separator\n";
  print "launching $designerExe\n";
  print $indent, "with project file: $actelWorkFileSpec\n";
}

system("$designerExe $actelFileSpec")or die "ERROR: Failed to launch $actelWorkFileSpec with $designerExe";
