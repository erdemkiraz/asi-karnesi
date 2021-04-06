import React, { Component } from "react";
import { connect } from "react-redux";
import GoogleLogin from "react-google-login";
import { clientId } from "../services/base_service";
import { SET_USER } from "../redux/types";
import {remove_key, put_storage} from "../services/StorageUtil";

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