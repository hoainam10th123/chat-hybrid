using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ChatAppCore.Entities
{
    public class AppUser : IdentityUser<int>
    {
        public DateTime LastActive { get; set; } = DateTime.Now;
        public DateTime DayOfBirth { get; set; }
        public string DisplayName { get; set; }
        public ICollection<Photo> Photos { get; set; }
        public ICollection<Message> MessagesSent { get; set; }
        public ICollection<Message> MessagesReceived { get; set; }
        public ICollection<AppUserRole> UserRoles { get; set; }
    }
}
