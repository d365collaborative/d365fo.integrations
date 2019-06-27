
<#
    .SYNOPSIS
        Get mandatory field(s) from Data Entity
        
    .DESCRIPTION
        Get the mandatory field(s) from a Data Entity and its meta data
        
    .PARAMETER Name
        Name of the Data Entity
        
    .PARAMETER Properties
        The properties value from the meta data object
        
    .EXAMPLE
        PS C:\> Get-D365ODataPublicEntity -EntityName CustomersV3 | Get-D365ODataEntityMandatoryFields | Format-List
        
        This will extract all the relevant mandatory fields from the Data Entity.
        The "CustomersV3" value is used to get the desired Data Entity.
        The output from Get-D365ODataPublicEntity is piped into Get-D365ODataEntityMandatoryFields.
        All mandatory fields will be extracted and displayed.
        The output will be formatted as a list.
        
    .LINK
        Get-D365ODataEntityMandatoryFields
        
    .NOTES
        Tags: OData, Data, Entity, MetaData, Meta, Mandatory
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Get-D365ODataEntityMandatoryFields {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string] $Name,
        
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [PSCustomObject] $Properties
    )

    process {
        $filteredRes = $Properties | Where-Object IsMandatory -eq $true

        $formattedRes = $filteredRes | Select-PSFObject "Name as FieldName", DataType
        
        [PSCustomObject]@{
            Name = $Name
            Keys = $formattedRes
        }
    }
}