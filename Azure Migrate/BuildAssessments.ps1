#Connect to Azure 
Connect-AzAccount
#Import Module 
Import-Module .\AzureMigrateAssessmentCreationUtility.psm1
# Declare variables
$subscriptionId = "<Your Azure Subscription ID>"
$resourceGroupName = "<The name of the resource group where your Azure Migrate project resides>"
#Query the name of your Azure Migrate project
Get-AzureMigrateAssessmentProject -subscriptionId $subscriptionId -resourceGroupName $resourceGroupName


#Declare Variables
$subscriptionId = "<Your Azure Subscription ID>"
$resourceGroupName = "<The name of the resource group where your Azure Migrate project resides>"
$assessmentProjectName = "Demo-Assessment55a4project"
$discoverySource = "Import"

New-AssessmentCreation -subscriptionId $subscriptionID -resourceGroupName $resourceGroupName -assessmentProjectName $assessmentProjectName -discoverySource $discoverySource -
