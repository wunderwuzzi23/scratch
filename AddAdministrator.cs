### Update username and password fields
###
### Compile using:
### csc /r:System.DirectoryServices.AccountManagement.dll /out:AddAdministrator.exe AddAdministrator.cs
###

using System.DirectoryServices.AccountManagement;
using System.Security.Principal;

namespace AddAdministrator
{
    class Program
    {
        static void Main(string[] args)
        {
            string username = "<compile error here>"
            string password = "<compile error here>"

            using (var context = new PrincipalContext(ContextType.Machine))
            {
                using (var user = new UserPrincipal(context, username, password, true))
                {
                    user.DisplayName = "IT Backup Account";
                    user.Description = "";
                    user.PasswordNeverExpires = true;
                    user.UserCannotChangePassword = false;
                    user.Save();

                    var adminSID = new SecurityIdentifier(WellKnownSidType.BuiltinAdministratorsSid, null)
                        .Translate(typeof(NTAccount)).Value;
                    using (var group = GroupPrincipal.FindByIdentity(context, IdentityType.Name, adminSID.ToString()))
                    {
                        group.Members.Add(user);
                        group.Save();
                    }
                }
            }
        }
    }
}
