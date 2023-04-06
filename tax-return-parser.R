# Load the required libraries
library(XML)
library(plyr)
library(dplyr)

# Set the path to the folder containing XML files
path <- "./Source/tax-return-parser/xml"

# Get a list of all XML files in the folder
files <- list.files(path, pattern = ".xml$", full.names = TRUE)

# Specify the fields that should be read from the 990 document.
columns_990 <<- list(
  "GrossReceiptsAmt"="GrossReceiptsAmt",
  "NetIncomeFromGamingGrp"="NetIncomeFromGamingGrp"
)

read_xml_to_df2 <- function(file_path) {
  doc <- xmlParse(file_path)

  xml_990 <- xmlToDataFrame(nodes=getNodeSet(doc, "//doc:IRS990",namespaces = c(doc="http://www.irs.gov/efile")))
  
  # Uncomment this line to print all the columns available in the 990
  # print(names(xml_990))
  
  # The 990 has lots of properties and several repeatable nodes which leads to problems converting to a datatable.
  # So reading the entire node, but then removing every column except for those defined in columns_990 before combining all the dataframes together.
  selected_columns <- intersect(names(xml_990), names(columns_990))
  df_990 <- xml_990 %>% select(all_of(selected_columns))

  df_filer <- xmlToDataFrame(nodes=getNodeSet(doc, "//doc:Filer",namespaces =
                                               c(doc="http://www.irs.gov/efile")))
  df_taxYr <- xmlToDataFrame(nodes=getNodeSet(doc, "//doc:TaxYr", namespaces =
                                               c(doc="http://www.irs.gov/efile")))
  
  df_taxYr$taxyr <- df_taxYr$text
  #remove the text column
  df_taxYr$text <- NULL
  
  df_taxPeriodEndDt <- xmlToDataFrame(nodes=getNodeSet(doc, "//doc:TaxPeriodEndDt", namespaces =
                                               c(doc="http://www.irs.gov/efile")))
  
  df_taxPeriodEndDt$taxperiod_end <- df_taxPeriodEndDt$text
  #remove the text column
  df_taxPeriodEndDt$text <- NULL
  
  combined <- cbind(df_filer, df_taxYr, df_taxPeriodEndDt, df_990)
  
  return(combined)
}

# Read each file in to a list of dataframes
df_list <- list()
for (i in seq_along(files)) {
  df <- read_xml_to_df2(files[i])
  df_list[[i]] <- df
}

# Unions each dataframe and matches on the column names to output a datatable.
df_table <- bind_rows(df_list)
