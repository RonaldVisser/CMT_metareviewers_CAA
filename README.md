# CMT_metareviewers_CAA
Script to add meta reviewers in CMT to papers of their session for CAA

The script uses the input of the Excel-export of papers from CMT (https://cmt3.research.microsoft.com/). This file is an XML-2003 format and needs to saved as an xlsx-file, since the export-format is hard to read in R.

The output is an XML file used to attach meta-reviewers to the papers in CMT. In addition, the orginal input file with the papers is renamed to the current data.
