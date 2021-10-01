import { Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, Resolve } from '@angular/router';
import { Observable } from 'rxjs';
import { take } from 'rxjs/operators';
import { Member } from '../models/user';
import { AccountService } from '../services/account.service';

@Injectable({
    providedIn: 'root'
})
export class MemberPhotosResolver implements Resolve<Member> {
    username: string;

    constructor(private accountService: AccountService) {
        this.accountService.currentUser$.pipe(take(1)).subscribe(user => this.username = user.userName)
    }

    resolve(route: ActivatedRouteSnapshot): Observable<Member> {
        return this.accountService.getMember(this.username);
    }
}