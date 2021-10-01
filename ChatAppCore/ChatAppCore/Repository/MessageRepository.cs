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
    public class MessageRepository : IMessageRepository
    {
        DataContext _context;
        IMapper _mapper;
        public MessageRepository(DataContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public void AddGroup(Group group)
        {
            _context.Groups.Add(group);
        }

        public void AddMessage(Message message)
        {
            _context.Messages.Add(message);
        }

        public void DeleteMessage(Message message)
        {
            throw new NotImplementedException();
        }

        public async Task<Connection> GetConnection(string connectionId)
        {
            return await _context.Connections.FindAsync(connectionId);
        }

        public async Task<Group> GetGroupForConnection(string connectionId)
        {
            return await _context.Groups.Include(x => x.Connections)
                .Where(x => x.Connections.Any(c => c.ConnectionId == connectionId))
                .FirstOrDefaultAsync();
        }

        public Task<Message> GetMessage(int id)
        {
            throw new NotImplementedException();
        }

        public async Task<Group> GetMessageGroup(string groupName)
        {
            return await _context.Groups.Include(x => x.Connections).FirstOrDefaultAsync(x => x.Name == groupName);
        }

        public async Task<IEnumerable<MessageDto>> GetMessageThread(string currentUsername, string recipientUsername)
        {
            var messages = await _context.Messages
                //.Include(u => u.Sender).ThenInclude(p => p.Photos)//get photo of sender
                //.Include(u => u.Recipient).ThenInclude(p => p.Photos)//get photo Recipient
                .Where(m => m.Recipient.UserName == currentUsername && m.Sender.UserName == recipientUsername || m.Recipient.UserName == recipientUsername && m.Sender.UserName == currentUsername)
                .OrderBy(m => m.MessageSent)
                .ProjectTo<MessageDto>(_mapper.ConfigurationProvider)//khi co include thi ko can cai nay. toi uu query
                .ToListAsync();

            var unreadMessages = messages.Where(m => m.DateRead == null && m.RecipientUsername == currentUsername).ToList();
            if (unreadMessages.Any())
            {
                foreach (var mess in unreadMessages)
                {
                    mess.DateRead = DateTime.Now;
                }
            }
            //return _mapper.Map<IEnumerable<MessageDto>>(messages); khi co Include
            return messages;
        }

        public void RemoveConnection(Connection connection)
        {
            _context.Connections.Remove(connection);
        }
    }
}
