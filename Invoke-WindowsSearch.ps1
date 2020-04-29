function Invoke-WindowsSearch
{
    param
    (
     [Parameter()][string] $SearchString = "password"
    )
    $SearchString = $SearchString.Replace("'","''")
    $query   = "select system.itemname, system.itempathdisplay from systemindex where contains('$SearchString')"
    $provider = "Provider=Search.CollatorDSO.1;Extended?PROPERTIES='Application=Windows'"
    $adapter  = new-object System.Data.OleDb.OleDBDataAdapter -Argument $query, $provider
    $results = new-object System.Data.DataSet

    $adapter.Fill($results)
    $results.Tables[0]
}
