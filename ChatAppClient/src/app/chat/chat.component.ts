import { ChangeDetectionStrategy, Component, ElementRef, OnInit, ViewChild } from '@angular/core';
import { NgForm } from '@angular/forms';
import { take } from 'rxjs/operators';
import { Message } from '../models/message';
import { Member, User } from '../models/user';
import { UserConnectToSignalR } from '../models/user-connect';
import { AccountService } from '../services/account.service';
import { MessageService } from '../services/message.service';
import { PresenceService } from '../services/presence.service';
import { UserService } from '../services/user.service';

@Component({
  selector: 'app-chat',
  templateUrl: './chat.component.html',
  styleUrls: ['./chat.component.css']
})
export class ChatComponent implements OnInit {
  messageContent: string;
  @ViewChild('messageForm') messageForm: NgForm;
  @ViewChild('scrollMe') private myScrollContainer: ElementRef;
  users: Member[] = [];
  userSelected: Member;
  userCurrent: User;
  _messages: Message[] = [];

  userConnects: UserConnectToSignalR[] = [];

  constructor(private userService: UserService, private messageService: MessageService, public accountService: AccountService, public presence: PresenceService) {
    this.accountService.currentUser$.pipe(take(1)).subscribe(user => this.userCurrent = user);
    
    this.messageService.messageThread$.subscribe(messages=>{
      this._messages = messages;
    })

    this.presence.message$.subscribe(message=>{
      this.updateUnreadMesageCount(message);
    })
  }

  ngOnInit(): void {
    this.getUsers();    
    this.scrollToBottom();   
  }

  ngAfterViewChecked() {
    this.scrollToBottom();
  }

  scrollToBottom(): void {
    try {
      this.myScrollContainer.nativeElement.scrollTop = this.myScrollContainer.nativeElement.scrollHeight;
    } catch (err) { }
  }

  getUsers() {
    this.userService.getUsers().subscribe(users => {
      this.users = users;
      this.selectedUserAndLoadMessages(users[0]);
    })
  }

  selectedUserAndLoadMessages(user: Member) {
    this.userSelected = user;
    var containUser = this.userConnects.find(u => u.userName === this.userSelected.userName);
    
    if (!containUser) {
      this.userConnects.push(new UserConnectToSignalR(user.userName));
      this.messageService.createHubConnection(this.userCurrent, this.userSelected.userName);            
    }else{
      this.messageService.loadMessages(this.userSelected.userName)
    }

    for(let u of this.users){
      if(u.userName === this.userSelected.userName){
        u.unReadMessageCount = 0;
        break;
      }
    }

  }

  sendMessage() {

    if(this.userSelected){
      let elem = {content: '', senderUsername:'', recipientUsername:''} as Message;
        elem.content = this.messageContent;
        elem.senderUsername = this.userCurrent.userName;
        elem.recipientUsername = this.userSelected.userName;
        elem.dateRead = new Date();
        elem.messageSent = new Date();

      this.messageService.sendMessage(this.userSelected.userName, this.messageContent).then(() => {        
        this._messages.push(elem);
        this.messageForm.reset();
      })
    }    
  }

  updateUnreadMesageCount(message: Message){
    if(message?.senderUsername === this.userSelected?.userName){
      this._messages.push(message);
    }else{
      for(let u of this.users){
        if(u.userName === message?.senderUsername){
          u.unReadMessageCount++;
          break;
        }
      }
    }
  }

}
