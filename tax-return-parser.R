###### This section works, but the loop doesn't work with 990s with different paths..
# Load the required libraries
library(XML)
library(plyr)
library(dplyr)

# Set the path to the folder containing XML files
path <- "~/Documents/tyler/xml"

# Get a list of all XML files in the folder
files <- list.files(path, pattern = ".xml$", full.names = TRUE)

# Define a function to read an XML file and convert it to a data frame
read_xml_to_df <- function(file_path) {
  doc <- xmlParse(file_path)
  xml_df <- xmlToDataFrame(nodes=getNodeSet(doc, "//doc:Filer",namespaces =
                                              c(doc="http://www.irs.gov/efile")))
  return(xml_df)
}

# Apply the function to each XML file and combine the results into a single data frame
df_filer <- ldply(files, read_xml_to_df)

# create an empty dictionary
columns990 <<- list()

read_xml_to_df2 <- function(file_path) {
  doc <- xmlParse(file_path)
  
  xml_990 <- xmlToDataFrame(nodes=getNodeSet(doc, "//doc:IRS990",namespaces = c(doc="http://www.irs.gov/efile")))
  
  if (length(columns990) == 0) {
    # fill the dictionary with column names
    columns990 <<- setNames(as.list(names(xml_990)), names(xml_990))
    columns990 <<- columns990[which(names(columns990) != "NA")]
  }
  
  same_columns <- intersect(names(xml_990), names(columns990))
  
  # select only the columns that are in the dictionary
  common_xml_990 <- xml_990 %>% select(same_columns)
  
  xml_df2 <- xmlToDataFrame(nodes=getNodeSet(doc, "//doc:Filer",namespaces =
                                               c(doc="http://www.irs.gov/efile")))
  xml_df3 <- xmlToDataFrame(nodes=getNodeSet(doc, "//doc:TaxYr", namespaces =
                                               c(doc="http://www.irs.gov/efile")))
  
  xml_df3$taxyr <- xml_df3$text
  xml_df4 <- xmlToDataFrame(nodes=getNodeSet(doc, "//doc:TaxPeriodEndDt", namespaces =
                                               c(doc="http://www.irs.gov/efile")))
  xml_df4$taxperiod_end <- xml_df4$text
  combined <- cbind(xml_df2, xml_df3, xml_df4, common_xml_990)
  return(combined)
}

# Apply the function to each XML file and combine the results into a single data frame
df <- ldply(files, read_xml_to_df2)