using AutoMapper;
using ChatAppCore.DTOs;
using ChatAppCore.Entities;
using ChatAppCore.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ChatAppCore.Controllers
{

    public class AccountController : BaseApiController
    {
        private readonly ITokenService _tokenService;
        private IMapper _mapper;
        UserManager<AppUser> _userManager;
        SignInManager<AppUser> _signInManager;

        public AccountController(UserManager<AppUser> userManager, SignInManager<AppUser> signInManager, ITokenService tokenService, IMapper mapper)
        {
            _tokenService = tokenService;
            _mapper = mapper;
            _userManager = userManager;
            _signInManager = signInManager;
        }

        [HttpPost("register")]
        //api/account/register?username=Test&password=hoainam10th with Register(string username, string password)
        public async Task<ActionResult<UserDto>> Register(RegisterDto register)
        {
            if (await UserExists(register.UserName))
                return BadRequest("Username is taken");

            var user = _mapper.Map<AppUser>(register);

            user.UserName = register.UserName.ToLower();

            var result = await _userManager.CreateAsync(user, register.Password);
            if (!result.Succeeded) return BadRequest(result.Errors);

            var roleResult = await _userManager.AddToRoleAsync(user, "user");
            if (!roleResult.Succeeded) return BadRequest(roleResult.Errors);

            return new UserDto
            {
                UserName = user.UserName,
                DisplayName = user.DisplayName,
                DayOfBirth = user.DayOfBirth,
                LastActive = user.LastActive,
                Token = await _tokenService.CreateTokenAsync(user)             
            };
        }

        [HttpPost("login")]
        public async Task<ActionResult<UserDto>> Login(LoginDto loginDto)
        {
            var user = await _userManager.Users
                .Include(p => p.Photos)
                .SingleOrDefaultAsync(x => x.UserName == loginDto.UserName.ToLower());

            if (user == null)
                return Unauthorized("Invalid Username");

            var result = await _signInManager.CheckPasswordSignInAsync(user, loginDto.Password, false);

            if (!result.Succeeded) return Unauthorized("Invalid password");

            return new UserDto
            {
                UserName = user.UserName,
                DisplayName = user.DisplayName,
                DayOfBirth = user.DayOfBirth,
                LastActive = user.LastActive,
                Token = await _tokenService.CreateTokenAsync(user),
                PhotoUrl = user.Photos.FirstOrDefault(x => x.IsMain)?.Url             
            };
        }

        private async Task<bool> UserExists(string username)
        {
            return await _userManager.Users.AnyAsync(x => x.UserName == username.ToLower());
        }
    }
}
