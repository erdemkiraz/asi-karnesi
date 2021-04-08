import React, { Component } from "react";
import { connect } from "react-redux";
import GoogleLogin from "react-google-login";
import {BASE_URL, BUILD_HEADER, clientId} from "../services/base_service";
import { SET_USER } from "../redux/types";
import {remove_key, put_storage} from "../services/StorageUtil";
import axios from "axios";

class GoogleAuth extends Component {
    state = {
        fullname: "",
        email: "",
        image: "",
    }
    onSignIn = (googleUser) => {

        put_storage("google_user",googleUser);
        console.log("googleUser loged in ")
        console.log(googleUser)
        const profile = googleUser.getBasicProfile();
        this.setState({
            fullname: profile.getName(),
            email: profile.getEmail(),
            image: profile.getImageUrl(),
            google_id: profile.getId()
        });
        // Update the State
        this.props.dispatch({
            type: SET_USER,
            payload: this.state
        })

        // Send request to backend to add user
        let data_to_send = {
            data: this.state
        };
        let url = "https://asi-karnesi-development.herokuapp.com/add_user";
        const options = {
            method: "POST",
            headers: BUILD_HEADER("", ""),
            data: data_to_send,
            url,
        };
        let response = axios(options);
        console.log("response: ", response);
        // save the user to the local storage
        put_storage('user', this.state)
        // Redirect to the Homepage
        this.props.history.push("/")
    }
	render() {
		return (
            <GoogleLogin
				clientId={clientId}
				buttonText="Login"
				onSuccess={this.onSignIn}
				// onFailure={onFailure}
				cookiePolicy={"single_host_origin"}
                style={{ height: "7vh", margin: "10px" }}
				isSignedIn={false} // auto load
			/>
		);
	}
}

export default connect()(GoogleAuth);