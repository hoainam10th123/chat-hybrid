using AutoMapper;
using AutoMapper.QueryableExtensions;
using ChatAppCore.Data;
using ChatAppCore.DTOs;
using ChatAppCore.Entities;
using ChatAppCore.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ChatAppCore.Repository
{
    public class UserRepository : IUserRepository
    {
        private readonly DataContext _context;
        private readonly IMapper _mapper;
        public UserRepository(DataContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task<AppUser> GetUserByIdAsync(int id)
        {
            return await _context.Users.FindAsync(id);
        }

        public async Task<AppUser> GetUserByUsernameAsync(string username)
        {
            return await _context.Users
                .Include(p => p.Photos)//get photo qua bang quan he xem cau hinh AutoMapperProfiles o Helpers
                .SingleOrDefaultAsync(x => x.UserName == username);
        }

        public async Task<MemberDto> GetMemberAsync(string username)
        {
            return await _context.Users.Where(x => x.UserName == username)
                .ProjectTo<MemberDto>(_mapper.ConfigurationProvider)//add CreateMap<AppUser, MemberDto>(); in AutoMapperProfiles
                .SingleOrDefaultAsync();
        }

        public async Task<IEnumerable<MemberDto>> GetMembersAsync(string username)
        {
            return await _context.Users
                .Where(x=>x.UserName != username)
                .ProjectTo<MemberDto>(_mapper.ConfigurationProvider)
                .ToListAsync();
        }
    }
}
