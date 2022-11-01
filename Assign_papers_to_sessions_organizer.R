library(readxl)
library(tidyverse)
library(XML)

# open xls-export from CMT in Excel and save as xlsx, 
# since the xls export of CMT is not a correct xls-file, but an XML 2003 format

paper <- read_xlsx("data/Papers.xlsx", skip = 2)
session <- read_xlsx("data/Session_List.xlsx")
session_co_author <- read_xlsx("data/Co_authors_session.xlsx")
session_scc <- read_xlsx("data/CAA_SCC.xlsx")

# export of papers from cmt shortens cell content to 100 chars 
session$Title_with_nr <- substr(session$Title_with_nr, 1, 100)
session$Title_with_nr <- str_trim(session$Title_with_nr, "right") # remove trailing space
session_co_author$Title_with_nr <- substr(session_co_author$Title_with_nr, 1, 100)
session_co_author$Title_with_nr <- str_trim(session_co_author$Title_with_nr, "right") # remove trailing space
session_scc$Title_with_nr <- substr(session_scc$Title_with_nr, 1, 100)
session_scc$Title_with_nr <- str_trim(session_scc$Title_with_nr, "right") # remove trailing space


session_all <- session %>% 
  select(Title_with_nr, "Corresponding session organiser email address") %>%
  rename(email = "Corresponding session organiser email address") %>%
  bind_rows(session_co_author) %>%
  filter(!is.na(email)) %>%
  bind_rows(session_scc) 

papers_metareviewer <- paper %>% 
  inner_join(session_all, by = c("Primary Subject Area" = "Title_with_nr")) 



export_table <- papers_metareviewer %>% select("Paper ID", "email")


for (i in 1:nrow(export_table)){
  if (i==1) {cat(paste0("<assignments>","\n"), file ="export/MetaAssignments.xml")}
  cat(paste0("\t", "<submission submissionId=\"", export_table$"Paper ID"[i], "\">"), file ="export/MetaAssignments.xml", sep = "\n", append = TRUE)
  cat(paste0("\t\t","<user email=\"",  export_table$email[i],  "\" />"), file ="export/MetaAssignments.xml", sep = "\n", append = TRUE)
  cat(paste0("\t", "</submission>"), file ="export/MetaAssignments.xml", sep = "\n", append = TRUE)
  if (i==nrow(export_table)) {cat("</assignments>", file ="export/MetaAssignments.xml", append = TRUE)}
}

# use xml to Import Meta-Reviewer Assignments in Submissions in CMT
file.rename("data/Papers.xlsx", paste0("data/Papers", format(Sys.Date(), "%Y%m%d"), ".xlsx"))
file.rename("data/Papers.xls", paste0("data/Papers", format(Sys.Date(), "%Y%m%d"), ".xls"))
