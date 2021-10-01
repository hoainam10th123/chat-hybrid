import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from 'src/environments/environment';
import { Member } from '../models/user';

@Injectable({
  providedIn: 'root'
})
export class UserService {
  baseUrl = environment.apiUrl;
  
  constructor(private http: HttpClient) { }

  getUsers(){
    return this.http.get<Member[]>(this.baseUrl+'User');
  }
}
