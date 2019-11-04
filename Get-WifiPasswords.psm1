function Get-WifiPasswords
{
   netsh wlan show profiles | sls ":" | % {
      
      $ssid = ([string]$_).Split(":")[1].Trim()
      
      if ($ssid -ne "")
      {
         $key = netsh wlan show profile name="$ssid" key=clear | sls "Key Content"
         
         if ($key -ne $null) 
         { 
            $ssid + ": " +([string]$key).Split(":")[1] 
         }
      }
   }
}
