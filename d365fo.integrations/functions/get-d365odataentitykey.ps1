
<#
    .SYNOPSIS
        Get key field(s) from Data Entity
        
    .DESCRIPTION
        Get the key field(s) from a Data Entity and its meta data
        
    .PARAMETER Name
        Name of the Data Entity
        
    .PARAMETER Properties
        The properties value from the meta data object
        
    .EXAMPLE
        PS C:\> Get-D365ODataPublicEntity -EntityName CustomersV3 | Get-D365ODataEntityKey | Format-List
        
        This will extract all the relevant key fields from the Data Entity.
        The "CustomersV3" value is used to get the desired Data Entity.
        The output from Get-D365ODataPublicEntity is piped into Get-D365ODataEntityKey.
        All key fields will be extracted and displayed.
        The output will be formatted as a list.
        
    .LINK
        Get-D365ODataPublicEntity
        
    .NOTES
        Tags: OData, Data, Entity, MetaData, Meta, Key, Keys
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Get-D365ODataEntityKey {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string] $Name,
        
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [PSCustomObject] $Properties
    )

    process {
        $filteredRes = $Properties | Where-Object IsKey -eq $true

        $formattedRes = $filteredRes | Select-PSFObject "Name as FieldName", DataType
        
        [PSCustomObject]@{
            Name = $Name
            Keys = $formattedRes
        }
    }
}