import { Component, EventEmitter, OnInit, Output } from '@angular/core';
import { AbstractControl, FormBuilder, FormGroup, ValidatorFn, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { AccountService } from '../services/account.service';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css']
})
export class RegisterComponent implements OnInit {
  registerForm: FormGroup;
  validationErrors: string[] = [];
  maxDate: Date;

  constructor(private toastr: ToastrService, private fb: FormBuilder, private router: Router, private accountService: AccountService) { }

  ngOnInit(): void {
    this.khoiTaoForm();
    this.maxDate = new Date();
    this.maxDate.setFullYear(this.maxDate.getFullYear() -18);
  }

  khoiTaoForm(){
    this.registerForm = this.fb.group({
      displayName: ['', Validators.required],
      userName: ['', Validators.required],            
      password: ['', [Validators.required, Validators.minLength(6), Validators.maxLength(20)]],
      confirmPassword: ['', [Validators.required, this.matchValues('password')]],
      dayOfBirth: [null, Validators.required]
    })
  }

  matchValues(matchTo: string): ValidatorFn {
    return (control: AbstractControl) => {
      return control?.value === control?.parent?.controls[matchTo].value 
        ? null : {isMatching: true}
    }
  }

  register(){
    this.accountService.register(this.registerForm.value).subscribe(response => {
      this.router.navigateByUrl('/');//home page
      this.toastr.success("Register success");
    }, error => {
      this.validationErrors = error;
      //this.toastr.error(error.error);
    })
  }
}
