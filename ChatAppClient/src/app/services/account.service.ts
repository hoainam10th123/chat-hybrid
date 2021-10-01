import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { ReplaySubject } from 'rxjs';
import { environment } from 'src/environments/environment';
import { Member, User } from '../models/user';
import {map} from 'rxjs/operators';// map
import { PresenceService } from './presence.service';

@Injectable({
  providedIn: 'root'
})
export class AccountService {
  baseUrl = environment.apiUrl;
  private currentUserSource = new ReplaySubject<User>(1);
  currentUser$ = this.currentUserSource.asObservable();
  
  constructor(private http: HttpClient, private presence: PresenceService) { }

  login(model: any){
    return this.http.post(this.baseUrl+'Account/login', model).pipe(
      map((res:User)=>{
        const user = res;
        if(user){
          this.setCurrentUser(user);
          this.presence.createHubConnection(user);
        }
      })
    )
  }

  setCurrentUser(user: User){
    if(user){
      user.roles = [];
      const roles = this.getDecodedToken(user.token).role;//copy token to jwt.io see .role   
      Array.isArray(roles) ? user.roles = roles : user.roles.push(roles);
      localStorage.setItem('user', JSON.stringify(user));
      this.currentUserSource.next(user); 
    }      
  }

  logout(){
    localStorage.removeItem('user');
    this.currentUserSource.next(null);
    this.presence.stopHubConnection();
  }

  register(model:any){
    return this.http.post(this.baseUrl+'Account/register', model).pipe(
      map((res:User)=>{
        if(res){
          this.setCurrentUser(res);
          this.presence.createHubConnection(res);
        }
        return res;
      })
    )
  }

  getDecodedToken(token: string) {
    return JSON.parse(atob(token.split('.')[1]));
  }

  getMember(username:string){//token duoc goi trong jwt.interceptor    
    return this.http.get<Member>(this.baseUrl+'user/' + username);
  }

  setMainPhoto(photoId: number){
    return this.http.put(this.baseUrl + 'user/set-main-photo/' + photoId, {});
  }

  deletePhoto(photoId: number){
    return this.http.delete(this.baseUrl + 'user/delete-photo/' + photoId);
  }
}
