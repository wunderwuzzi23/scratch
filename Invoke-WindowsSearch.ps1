function Invoke-WindowsSearch {
    param (
        [Parameter()][string] $SearchString = "password",
        [Parameter()][string] $OutputPath = $null
    )
    $SearchString = $SearchString.Replace("'", "''")
    $query = "SELECT System.ItemName, System.ItemPathDisplay, System.DateModified, System.Size, System.Search.AutoSummary, System.Author, System.Title, System.Keywords, System.Subject, System.FileExtension FROM SystemIndex WHERE CONTAINS('$SearchString')"
    $provider = "Provider=Search.CollatorDSO.1;Extended Properties='Application=Windows'"
    $adapter = New-Object System.Data.OleDb.OleDbDataAdapter -ArgumentList $query, $provider
    $results = New-Object System.Data.DataSet

    try {
        $adapter.Fill($results)
        $table = $results.Tables[0]

        if ($table.Rows.Count -gt 0) {
            # Convert System.String[] to single strings
            foreach ($row in $table.Rows) {
                if ($row["System.Author"] -is [System.Array]) {
                    $row["System.Author"] = [string]::Join("; ", $row["System.Author"])
                }
                if ($row["System.Keywords"] -is [System.Array]) {
                    $row["System.Keywords"] = [string]::Join("; ", $row["System.Keywords"])
                }
            }

            if ($OutputPath) {
                # Export to CSV
                $table | Export-Csv -Path $OutputPath -NoTypeInformation
                Write-Output "Results exported to $OutputPath"
            } else {
                # Display to standard out
                $table #| Format-Table -AutoSize
            }
        } else {
            Write-Output "No results found for the search string '$SearchString'."
        }
    } catch {
        if ($_ -match "0x80004005") {
            Write-Output "No results found for the search string '$SearchString'."
        } else {
            Write-Output "An error occurred: $_"
        }
    }
}

# Example usage:
# To display the results to standard out
Invoke-WindowsSearch -SearchString "something"

# To save the results to a CSV file
Invoke-WindowsSearch -SearchString "something" -OutputPath "WindowsSearchResults.csv"
