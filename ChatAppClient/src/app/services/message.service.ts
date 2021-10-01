import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { HubConnection, HubConnectionBuilder } from '@microsoft/signalr';
import { BehaviorSubject } from 'rxjs';
import { take } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { Group } from '../models/group';
import { Message } from '../models/message';
import { User } from '../models/user';

@Injectable({
  providedIn: 'root'
})
export class MessageService {
  baseUrl = environment.apiUrl;
  hubUrl = environment.hubUrl;
  private hubConnection: HubConnection;
  private messageThreadSource = new BehaviorSubject<Message[]>([]);
  messageThread$ = this.messageThreadSource.asObservable();
  
  constructor(private http: HttpClient) { }

  createHubConnection(user: User, otherUsername: string){
    
    this.hubConnection = new HubConnectionBuilder()
    .withUrl(this.hubUrl+ 'message?user=' + otherUsername, {
      accessTokenFactory: ()=> user.token
    }).withAutomaticReconnect().build()

    this.hubConnection.start().catch(err => console.log(err));

    this.hubConnection.on('ReceiveMessageThread', messages => {
      this.messageThreadSource.next(messages);
    })

    // this.hubConnection.on('UpdatedGroup', (group: Group) => {
    //   if(group.connections.some(x => x.userName === otherUsername)){
    //     this.messageThread$.pipe(take(1)).subscribe(messages => {
    //       messages.forEach(message=>{
    //         if(!message.dateRead){
    //           message.dateRead = new Date(Date.now())
    //         }
    //       })
    //       this.messageThreadSource.next([...messages]);
    //     })
    //   }
    // })
  }

  stopHubConnection(){
    if(this.hubConnection){
      this.hubConnection.stop();
    }
  }

  loadMessages(otherUserName: string){
    return this.http.get<Message[]>(this.baseUrl + 'Message/' + otherUserName).subscribe(messages=>{
      this.messageThreadSource.next(messages)
    })
  }

  async sendMessage(username: string, content: string){    
    return this.hubConnection.invoke('SendMessage', {recipientUsername: username, content})
      .catch(error => console.log(error));
  }
}
