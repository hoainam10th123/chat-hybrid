using ChatAppCore.DTOs;
using ChatAppCore.Extensions;
using ChatAppCore.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ChatAppCore.Controllers
{
    [Authorize]
    public class MessageController : BaseApiController
    {
        private readonly IUnitOfWork _unitOfWork;

        public MessageController(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        [HttpGet("{otherUserName}")]
        public async Task<ActionResult<IEnumerable<MessageDto>>> GetMessages(string otherUserName)
        {
            var messages = await _unitOfWork.MessageRepository.GetMessageThread(User.GetUsername(), otherUserName);
            return Ok(messages);
        }
    }
}
