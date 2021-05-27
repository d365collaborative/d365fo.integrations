
<#
    .SYNOPSIS
        Get mandatory field(s) from Data Entity
        
    .DESCRIPTION
        Get the mandatory field(s) from a Data Entity and its meta data
        
    .PARAMETER Name
        Name of the Data Entity
        
    .PARAMETER Properties
        The properties value from the meta data object
        
    .PARAMETER OutputSample
        Instruct the cmdlet to output a sample of the mandatory fields/properties
        
    .EXAMPLE
        PS C:\> Get-D365ODataPublicEntity -EntityName CustomersV3 | Get-D365ODataEntityMandatoryField | Format-List
        
        This will extract all the relevant mandatory fields from the Data Entity.
        The "CustomersV3" value is used to get the desired Data Entity.
        The output from Get-D365ODataPublicEntity is piped into Get-D365ODataEntityMandatoryFields.
        All mandatory fields will be extracted and displayed.
        The output will be formatted as a list.
        
    .EXAMPLE
        PS C:\> Get-D365ODataPublicEntity -EntityName CustomersV3 | Get-D365ODataEntityMandatoryField -OutputSample
        
        This will extract all the relevant mandatory fields from the Data Entity.
        The "CustomersV3" value is used to get the desired Data Entity.
        The output from Get-D365ODataPublicEntity is piped into Get-D365ODataEntityMandatoryFields.
        All mandatory fields will be extracted and displayed as a JSON sample.
        
    .LINK
        Get-D365ODataPublicEntity
        
    .NOTES
        Tags: OData, Data, Entity, MetaData, Meta, Mandatory
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Get-D365ODataEntityMandatoryField {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string] $Name,
        
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [PSCustomObject] $Properties,

        [switch] $OutputSample
    )

    process {
        $filteredRes = $Properties | Where-Object IsMandatory -eq $true

        $formattedRes = $filteredRes | Select-PSFObject "Name as FieldName", DataType
        
        if (-not $OutputSample) {
            [PSCustomObject]@{
                Name = $Name
                Keys = $formattedRes
            }
        }
        else {
            [System.Collections.ArrayList] $res = New-Object -TypeName "System.Collections.ArrayList"

            foreach ($item in $filteredRes) {
                
                if ($item.DataType -eq "String") {
                    $res.Add("$($item.Name)=''") > $null
                }
                else {
                    $res.Add("$($item.Name)=''") > $null
                }
            }

            "{`r`n" + $($res.ToArray() -join ",`r`n") + "`r`n}"
        }
    }
}