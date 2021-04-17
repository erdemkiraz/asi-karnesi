import React, {Component} from "react";
import {connect} from "react-redux";
import GoogleLogin from "react-google-login";
import {BASE_URL, BUILD_HEADER, clientId} from "../services/base_service";
import {SET_USER} from "../redux/types";
import {remove_key, put_storage} from "../services/StorageUtil";
import axios from "axios";

class GoogleAuth extends Component {
    state = {
        fullname: "",
        email: "",
        image: "",
    }

    checkNewUser = (googleUser) => {


        let payload = {
            "google_id": googleUser["googleId"],
            "email": googleUser["profileObj"]["email"],
            "name": googleUser["profileObj"]["name"],
        }
        console.log(payload)

        let url = BASE_URL + "/update-user-info";
        const options = {
            method: 'POST',
            headers: BUILD_HEADER(),
            data: payload,
            url,
        };

        axios(options).then(data => {
            console.log(data);
            if(data.data["new_user"]){
                this.props.history.push("/me")
            }
            else{
                this.props.history.push("/home")
            }
        })

    }


        onSignIn = (googleUser) => {

        put_storage("google_user", googleUser);
        console.log("googleUser loged in ")
        console.log(googleUser)

        // let google_id = googleUser["googleId"];
        // console.log("Google id before check : ", google_id)
        this.checkNewUser(googleUser);
        const profile = googleUser.getBasicProfile();
        this.setState({
            fullname: profile.getName(),
            email: profile.getEmail(),
            image: profile.getImageUrl()
        });
        // Update the State
        this.props.dispatch({
            type: SET_USER,
            payload: this.state
        })
        // save the user to the local storage
        put_storage('user', this.state)
        // Redirect to the Homepage
    }

    render() {
        return (
            (
                <div>
                    <GoogleLogin
                        clientId={clientId}
                        buttonText="Login"
                        onSuccess={this.onSignIn}
                        // onFailure={onFailure}
                        cookiePolicy={"single_host_origin"}
                        style={{ padding: 60 }}
                        isSignedIn={false} // auto load
                        scope="email profile"
                        //scope="email profile https://www.googleapis.com/auth/contacts"
                        buttonText="Login With Google"
                    />

                </div>
            )
        );
    }
}

export default connect()(GoogleAuth);