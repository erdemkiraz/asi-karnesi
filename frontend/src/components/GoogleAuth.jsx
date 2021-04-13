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

        let google_id = googleUser["googleId"]
        // axios.get(BASE_URL + "/user?google_id=" + google_id, {headers: BUILD_HEADER()}).then(data => {
        //
        //     console.log(google_id);
        //     console.log(data.data);
        //     console.log(data.data["status"]);
        //     if (data.data["status"] === 500) {
        //         console.log("Open new user pop up!")
        //     } else {
        //         console.log("Existing user!")
        //     }
        //
        // })
    // google_id = request.json["google_id"]
    // facebook_id = request.json.get("facebook_id")
    // email = request.json.get("email")
    // name = request.json.get("name")
    // age = request.json.get("age")
    // country_name = request.json.get("country_name")
        let payload = {
            "google_id": googleUser["googleId"],
            "email": googleUser["profileObj"]["email"],
            "name": googleUser["profileObj"]["name"],
            // "name": this.state.privacy_setting
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
        this.props.history.push("/")
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
                        style={{height: "7vh", margin: "10px"}}
                        isSignedIn={false} // auto load
                    />
                </div>
            )
        );
    }
}

export default connect()(GoogleAuth);