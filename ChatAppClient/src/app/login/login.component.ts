import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { AccountService } from '../services/account.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
  loginForm: FormGroup;

  constructor(private fb: FormBuilder, public accountService: AccountService, private router: Router, private toastr: ToastrService) { }

  khoiTaoForm(){
    this.loginForm = this.fb.group({
      userName: ['', Validators.required],            
      password: ['', [Validators.required, Validators.minLength(6), Validators.maxLength(20)]]     
    })
  }

  ngOnInit(): void {
    this.khoiTaoForm();
  }

  login(){
    this.accountService.login(this.loginForm.value).subscribe(res=>{
      this.toastr.success('Login success');
      this.router.navigateByUrl('/');
    }, error=>{
      console.log(error);
      this.toastr.error(error.error);
    })
  }

  logout(){
    this.accountService.logout();
    this.router.navigateByUrl('/');
  }

}
