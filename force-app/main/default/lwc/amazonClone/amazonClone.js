import { LightningElement } from 'lwc';
import loginuser from '@salesforce/apex/AmazonLoginController.login';
export default class AmazonClone extends LightningElement {

    username;
    password;
    iserror=false;
    errormessage;

    handleusername(event){
        this.username=event.target.value;
    }
    handleupassword(event){
        this.password=event.target.value;
    }
    handleLogin(){
        console.log('Button Clicked');
        console.log('username',this.username);
        console.log('Password',this.password);

        loginuser({Username:this.username,Password:this.password})
        .then((result) => {
            console.log('result',result)
        })
        .catch((error) =>{
            console.log('error',error);
            this.iserror=true;
            this.errormessage=error.body.message;

        })
    }
}