using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ChatAppCore.DTOs
{
    public class MemberDto
    {
        public string UserName { get; set; }
        public string DisplayName { get; set; }
        public DateTime LastActive { get; set; }
        public DateTime DayOfBirth { get; set; }
        public string PhotoUrl { get; set; }
        public ICollection<PhotoDto> Photos { get; set; }
        public int UnReadMessageCount { get; set; }
    }
}
