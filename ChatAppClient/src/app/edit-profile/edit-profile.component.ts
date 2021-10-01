import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { FileUploader } from 'ng2-file-upload';
import { take } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { Photo } from '../models/photo';
import { Member, User } from '../models/user';
import { AccountService } from '../services/account.service';

@Component({
  selector: 'app-edit-profile',
  templateUrl: './edit-profile.component.html',
  styleUrls: ['./edit-profile.component.css']
})
export class EditProfileComponent implements OnInit {
  user: User;
  uploader: FileUploader;
  hasBaseDropzoneOver = false;
  baseUrl = environment.apiUrl;
  member: Member;

  constructor(private accountService: AccountService, private route: ActivatedRoute) { 
    this.accountService.currentUser$.pipe(take(1)).subscribe(user=> this.user = user);
  }
  ngOnInit(): void {
    this.initializeUploader();
    //fix error photo undefine (vong for member.photos ngoai edit-profile.component.html)
    this.route.data.subscribe(data=>{
      this.member = data.member;
      //them dong nay ngoai app-routing.module.ts: resolve:{member: MemberPhotosResolver}
    })
  }

  fileOverBase(e: any) {
    this.hasBaseDropzoneOver = e;
  }

  setMainPhoto(photo: Photo) {
    this.accountService.setMainPhoto(photo.id).subscribe(() => {
      this.user.photoUrl = photo.url;
      this.accountService.setCurrentUser(this.user);
      this.member.photos.forEach(p => {
        if (p.isMain) p.isMain = false;
        if (p.id === photo.id) p.isMain = true;
      })
    })
  } 

  deletePhoto(photoId: number) {
    this.accountService.deletePhoto(photoId).subscribe(() => {
      this.member.photos = this.member.photos.filter(x => x.id !== photoId);
    })
  }

  initializeUploader() {
    this.uploader = new FileUploader({
      url: this.baseUrl + 'user/add-photo',
      authToken: 'Bearer ' + this.user.token,
      isHTML5: true,
      allowedFileType: ['image'],
      removeAfterUpload: true,
      autoUpload: false,
      maxFileSize: 10 * 1024 * 1024
    });

    this.uploader.onAfterAddingFile = (file) => {
      file.withCredentials = false;
    }

    this.uploader.onSuccessItem = (item, response, status, headers) => {
      if (response) {
        const photo: Photo = JSON.parse(response);
        this.member.photos.push(photo);
         if (photo.isMain) {
           this.user.photoUrl = photo.url;
           this.accountService.setCurrentUser(this.user);
         }
      }
    }
  }
}
