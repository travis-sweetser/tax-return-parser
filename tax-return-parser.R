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
  "PrincipalOfficerNm"="PrincipalOfficerNm",
  "GrossReceiptsAmt"="GrossReceiptsAmt",
  "GroupReturnForAffiliatesInd"="GroupReturnForAffiliatesInd",
  "Organization501c3Ind"="Organization501c3Ind",
  "WebsiteAddressTxt"="WebsiteAddressTxt",
  "TypeOfOrganizationCorpInd"="TypeOfOrganizationCorpInd",
  "FormationYr"="FormationYr",
  "LegalDomicileStateCd"="LegalDomicileStateCd",
  "ActivityOrMissionDesc"="ActivityOrMissionDesc",
  "VotingMembersGoverningBodyCnt"="VotingMembersGoverningBodyCnt",
  "VotingMembersIndependentCnt"="VotingMembersIndependentCnt",
  "TotalEmployeeCnt"="TotalEmployeeCnt",
  "TotalVolunteersCnt"="TotalVolunteersCnt",
  "TotalGrossUBIAmt"="TotalGrossUBIAmt",
  "NetUnrelatedBusTxblIncmAmt"="NetUnrelatedBusTxblIncmAmt",
  "PYContributionsGrantsAmt"="PYContributionsGrantsAmt",
  "CYContributionsGrantsAmt"="CYContributionsGrantsAmt",
  "PYProgramServiceRevenueAmt"="PYProgramServiceRevenueAmt",
  "CYProgramServiceRevenueAmt"="CYProgramServiceRevenueAmt",
  "PYInvestmentIncomeAmt"="PYInvestmentIncomeAmt",
  "CYInvestmentIncomeAmt"="CYInvestmentIncomeAmt",
  "PYOtherRevenueAmt"="PYOtherRevenueAmt",
  "CYOtherRevenueAmt"="CYOtherRevenueAmt",
  "PYTotalRevenueAmt"="PYTotalRevenueAmt",
  "CYTotalRevenueAmt"="CYTotalRevenueAmt",
  "PYGrantsAndSimilarPaidAmt"="PYGrantsAndSimilarPaidAmt",
  "CYGrantsAndSimilarPaidAmt"="CYGrantsAndSimilarPaidAmt",
  "PYBenefitsPaidToMembersAmt"="PYBenefitsPaidToMembersAmt",
  "CYBenefitsPaidToMembersAmt"="CYBenefitsPaidToMembersAmt",
  "PYSalariesCompEmpBnftPaidAmt"="PYSalariesCompEmpBnftPaidAmt",
  "CYSalariesCompEmpBnftPaidAmt"="CYSalariesCompEmpBnftPaidAmt",
  "PYTotalProfFndrsngExpnsAmt"="PYTotalProfFndrsngExpnsAmt",
  "CYTotalProfFndrsngExpnsAmt"="CYTotalProfFndrsngExpnsAmt",
  "CYTotalFundraisingExpenseAmt"="CYTotalFundraisingExpenseAmt",
  "PYOtherExpensesAmt"="PYOtherExpensesAmt",
  "CYOtherExpensesAmt"="CYOtherExpensesAmt",
  "PYTotalExpensesAmt"="PYTotalExpensesAmt",
  "CYTotalExpensesAmt"="CYTotalExpensesAmt",
  "PYRevenuesLessExpensesAmt"="PYRevenuesLessExpensesAmt",
  "CYRevenuesLessExpensesAmt"="CYRevenuesLessExpensesAmt",
  "TotalAssetsBOYAmt"="TotalAssetsBOYAmt",
  "TotalAssetsEOYAmt"="TotalAssetsEOYAmt",
  "TotalLiabilitiesBOYAmt"="TotalLiabilitiesBOYAmt",
  "TotalLiabilitiesEOYAmt"="TotalLiabilitiesEOYAmt",
  "NetAssetsOrFundBalancesBOYAmt"="NetAssetsOrFundBalancesBOYAmt",
  "NetAssetsOrFundBalancesEOYAmt"="NetAssetsOrFundBalancesEOYAmt",
  "InfoInScheduleOPartIIIInd"="InfoInScheduleOPartIIIInd",
  "MissionDesc"="MissionDesc",
  "SignificantNewProgramSrvcInd"="SignificantNewProgramSrvcInd",
  "SignificantChangeInd"="SignificantChangeInd",
  "ProgSrvcAccomActy2Grp"="ProgSrvcAccomActy2Grp",
  "ProgSrvcAccomActy3Grp"="ProgSrvcAccomActy3Grp",
  "ProgSrvcAccomActyOtherGrp"="ProgSrvcAccomActyOtherGrp",
  "TotalOtherProgSrvcExpenseAmt"="TotalOtherProgSrvcExpenseAmt",
  "TotalOtherProgSrvcGrantAmt"="TotalOtherProgSrvcGrantAmt",
  "TotalOtherProgSrvcRevenueAmt"="TotalOtherProgSrvcRevenueAmt",
  "TotalProgramServiceExpensesAmt"="TotalProgramServiceExpensesAmt",
  "DescribedInSection501c3Ind"="DescribedInSection501c3Ind",
  "ScheduleBRequiredInd"="ScheduleBRequiredInd",
  "PoliticalCampaignActyInd"="PoliticalCampaignActyInd",
  "LobbyingActivitiesInd"="LobbyingActivitiesInd",
  "SubjectToProxyTaxInd"="SubjectToProxyTaxInd",
  "DonorAdvisedFundInd"="DonorAdvisedFundInd",
  "ConservationEasementsInd"="ConservationEasementsInd",
  "CollectionsOfArtInd"="CollectionsOfArtInd",
  "CreditCounselingInd"="CreditCounselingInd",
  "TempOrPermanentEndowmentsInd"="TempOrPermanentEndowmentsInd",
  "ReportLandBuildingEquipmentInd"="ReportLandBuildingEquipmentInd",
  "ReportInvestmentsOtherSecInd"="ReportInvestmentsOtherSecInd",
  "ReportProgramRelatedInvstInd"="ReportProgramRelatedInvstInd",
  "ReportOtherAssetsInd"="ReportOtherAssetsInd",
  "ReportOtherLiabilitiesInd"="ReportOtherLiabilitiesInd",
  "IncludeFIN48FootnoteInd"="IncludeFIN48FootnoteInd",
  "IndependentAuditFinclStmtInd"="IndependentAuditFinclStmtInd",
  "ConsolidatedAuditFinclStmtInd"="ConsolidatedAuditFinclStmtInd",
  "SchoolOperatingInd"="SchoolOperatingInd",
  "ForeignOfficeInd"="ForeignOfficeInd",
  "ForeignActivitiesInd"="ForeignActivitiesInd",
  "MoreThan5000KToOrgInd"="MoreThan5000KToOrgInd",
  "MoreThan5000KToIndividualsInd"="MoreThan5000KToIndividualsInd",
  "ProfessionalFundraisingInd"="ProfessionalFundraisingInd",
  "FundraisingActivitiesInd"="FundraisingActivitiesInd",
  "GamingActivitiesInd"="GamingActivitiesInd",
  "OperateHospitalInd"="OperateHospitalInd",
  "AuditedFinancialStmtAttInd"="AuditedFinancialStmtAttInd",
  "GrantsToOrganizationsInd"="GrantsToOrganizationsInd",
  "GrantsToIndividualsInd"="GrantsToIndividualsInd",
  "ScheduleJRequiredInd"="ScheduleJRequiredInd",
  "TaxExemptBondsInd"="TaxExemptBondsInd",
  "InvestTaxExemptBondsInd"="InvestTaxExemptBondsInd",
  "EscrowAccountInd"="EscrowAccountInd",
  "OnBehalfOfIssuerInd"="OnBehalfOfIssuerInd",
  "EngagedInExcessBenefitTransInd"="EngagedInExcessBenefitTransInd",
  "PYExcessBenefitTransInd"="PYExcessBenefitTransInd",
  "LoanOutstandingInd"="LoanOutstandingInd",
  "GrantToRelatedPersonInd"="GrantToRelatedPersonInd",
  "BusinessRlnWithOrgMemInd"="BusinessRlnWithOrgMemInd",
  "BusinessRlnWithFamMemInd"="BusinessRlnWithFamMemInd",
  "BusinessRlnWithOfficerEntInd"="BusinessRlnWithOfficerEntInd",
  "DeductibleNonCashContriInd"="DeductibleNonCashContriInd",
  "DeductibleArtContributionInd"="DeductibleArtContributionInd",
  "TerminateOperationsInd"="TerminateOperationsInd",
  "PartialLiquidationInd"="PartialLiquidationInd",
  "DisregardedEntityInd"="DisregardedEntityInd",
  "RelatedEntityInd"="RelatedEntityInd",
  "RelatedOrganizationCtrlEntInd"="RelatedOrganizationCtrlEntInd",
  "TransactionWithControlEntInd"="TransactionWithControlEntInd",
  "TrnsfrExmptNonChrtblRltdOrgInd"="TrnsfrExmptNonChrtblRltdOrgInd",
  "ActivitiesConductedPrtshpInd"="ActivitiesConductedPrtshpInd",
  "ScheduleORequiredInd"="ScheduleORequiredInd",
  "InfoInScheduleOPartVInd"="InfoInScheduleOPartVInd",
  "IRPDocumentCnt"="IRPDocumentCnt",
  "IRPDocumentW2GCnt"="IRPDocumentW2GCnt",
  "BackupWthldComplianceInd"="BackupWthldComplianceInd",
  "EmployeeCnt"="EmployeeCnt",
  "EmploymentTaxReturnsFiledInd"="EmploymentTaxReturnsFiledInd",
  "UnrelatedBusIncmOverLimitInd"="UnrelatedBusIncmOverLimitInd",
  "Form990TFiledInd"="Form990TFiledInd",
  "ForeignFinancialAccountInd"="ForeignFinancialAccountInd",
  "ProhibitedTaxShelterTransInd"="ProhibitedTaxShelterTransInd",
  "TaxablePartyNotificationInd"="TaxablePartyNotificationInd",
  "NondeductibleContributionsInd"="NondeductibleContributionsInd",
  "QuidProQuoContributionsInd"="QuidProQuoContributionsInd",
  "Form8282PropertyDisposedOfInd"="Form8282PropertyDisposedOfInd",
  "RcvFndsToPayPrsnlBnftCntrctInd"="RcvFndsToPayPrsnlBnftCntrctInd",
  "PayPremiumsPrsnlBnftCntrctInd"="PayPremiumsPrsnlBnftCntrctInd",
  "IndoorTanningServicesInd"="IndoorTanningServicesInd",
  "InfoInScheduleOPartVIInd"="InfoInScheduleOPartVIInd",
  "GoverningBodyVotingMembersCnt"="GoverningBodyVotingMembersCnt",
  "IndependentVotingMemberCnt"="IndependentVotingMemberCnt",
  "FamilyOrBusinessRlnInd"="FamilyOrBusinessRlnInd",
  "DelegationOfMgmtDutiesInd"="DelegationOfMgmtDutiesInd",
  "ChangeToOrgDocumentsInd"="ChangeToOrgDocumentsInd",
  "MaterialDiversionOrMisuseInd"="MaterialDiversionOrMisuseInd",
  "MembersOrStockholdersInd"="MembersOrStockholdersInd",
  "ElectionOfBoardMembersInd"="ElectionOfBoardMembersInd",
  "DecisionsSubjectToApprovaInd"="DecisionsSubjectToApprovaInd",
  "MinutesOfGoverningBodyInd"="MinutesOfGoverningBodyInd",
  "MinutesOfCommitteesInd"="MinutesOfCommitteesInd",
  "OfficerMailingAddressInd"="OfficerMailingAddressInd",
  "LocalChaptersInd"="LocalChaptersInd",
  "Form990ProvidedToGvrnBodyInd"="Form990ProvidedToGvrnBodyInd",
  "ConflictOfInterestPolicyInd"="ConflictOfInterestPolicyInd",
  "AnnualDisclosureCoveredPrsnInd"="AnnualDisclosureCoveredPrsnInd",
  "RegularMonitoringEnfrcInd"="RegularMonitoringEnfrcInd",
  "WhistleblowerPolicyInd"="WhistleblowerPolicyInd",
  "DocumentRetentionPolicyInd"="DocumentRetentionPolicyInd",
  "CompensationProcessCEOInd"="CompensationProcessCEOInd",
  "CompensationProcessOtherInd"="CompensationProcessOtherInd",
  "InvestmentInJointVentureInd"="InvestmentInJointVentureInd",
  "UponRequestInd"="UponRequestInd",
  "OtherInd"="OtherInd",
  "BooksInCareOfDetail"="BooksInCareOfDetail",
  "InfoInScheduleOPartVIIInd"="InfoInScheduleOPartVIIInd"
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
