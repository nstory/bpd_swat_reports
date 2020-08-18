require "./lib/report"

Report.new do
  file "exports/new-school-report-metadata-classifications.csv"

  # column headers for reports
  task 0, "Agency"
  task 1, "Date"
  task 2, "City"
  task 3, "Inside City Limits"
  task 4, "Call Out Time"
  task 5, "Arrival Time"
  task 6, "Type of Premises"
  task 7, "Photos"
  task 8, "Video"
  task 9, "K-9 Unit Utilized"
  task 10, "Date Terminated"
  task 11, "Time Terminated"
  task 12, "Officer Injured"
  task 13, "Connect #"
  task 14, "Agency Assist"
  task 15, "Agency Assist Agency"

  # calculated column
  column("URL") { |subject_data| "https://wokewindows-data.s3.amazonaws.com/swats/#{subject_data['incident_number']}.pdf" }

  # my final judgement when the crowd disagreed
  correct 48915853, "T1", "10/11/13"
  correct 48915870, "T1", "4/18/13"
  correct 48915844, "T6", "Triple Decker"
  correct 48915855, "T9", "YES"
  correct 48915858, "T10", "5/23/14"
  correct 48915820, "T2", "East Boston"
  correct 48915827, "T11", "4:55 AM"
  correct 48915861, "T2", "Everett, MA"

  # clean up data that was entered wrong by BPD
  correct 48915848, "T1", "5/17/13" # entered as 5/17/20
  correct 48915859, "T1", "5/19/14" # entered as 5/19/20
  correct 48915840, "T1", "9/17/13" # entered as 9/17/20
  correct 48915849, "T1", "11/21/14" # entered as 11/21/20
end
