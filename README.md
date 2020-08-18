# Boston Police SWAT Reports
Crowdsourced effort to tabularize data found in SWAT after-action reports produced by the Boston Police Department.

## Overview
The BPD released 172 SWAT after-action reports covering the years 2010 - 2014 after a request by the Boston City Council ([more information here](https://www.wokewindows.org/pages/help#swat)). These reports are scanned PDF documents from which text cannot be automatically extracted reliably.

The goal of this project is to crowdsource data entry of the interesting fields present in these documents, and to produce convenient tabularized (CSV) data suitable for analysis in Excel, R, etc. To power the crowdsourcing effort, we've opted to use the excellent [Zooniverse](https://www.zooniverse.org/). Our project page is here: https://www.zooniverse.org/projects/nstory/bpd-swat-reports

Zooniverse provides the ability to define subjects to be classified (in this case, SWAT after-action reports), and to define workflows of classification tasks (in this case, a task is entering the data contained in a single field in a single report). We can then export the classification data from Zooniverse, at which point it is our responsibility to resolve conflicts (when two people enter different data for the same field), and to generate our final CSV files.

This repository contains:

1. [classification exports](https://help.zooniverse.org/next-steps/data-exports/#classification-export) from Zooniverse in [exports/](exports/)
2. code to parse the classification exports, correct conflicts, and produce final tables
3. the final tables in [tables/](tables/)

## New School Report Metadata
This is our first classification project, and is intended as a proof-of-concept (that also produces some useful data!)

This project is limited to "new school" SWAT reports. These are 64 reports from years 2012 - 2014 that appear to come from a newer database; older reports have a different layout. This first project only collects data from the first page of each report, which contains basic information regarding the date, location, etc.

Data entry of each SWAT report ("classification" in Zooniverse's parlance) was performed by two different people. If they provided different answers, I reviewed the report and hard-coded the answer (see [new_school_report_metadata.rb](new_school_report_metadata.rb)).

The final tabluarized data is available here: *[tables/new_school_report_metadata.csv](tables/new_school_report_metadata.csv)*.

## Next Steps
1. create workflows for data entry of additional fields from the "new school" reports: People Involved, Forced User By Police, etc.
2. add newer SWAT reports (2015 onwards) when those are released
3. create workflows for data entry of reports from 2012 and before in "old school" format

## External Links
- [zooniverse_upload_pdf.rb](https://github.com/nstory/wokewindows/blob/master/scripts/zooniverse_upload_pdf.rb)
- [SWAT Reports on Woke Windows](https://www.wokewindows.org/swats)
