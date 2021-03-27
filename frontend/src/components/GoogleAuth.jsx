import React, { Component } from "react";
import { connect } from "react-redux";
import GoogleLogin from "react-google-login";
import { clientId } from "../services/base_service";
import { SET_USER } from "../redux/types";

class GoogleAuth extends Component {
    state = {
        fullname: "",
        email: "",
        image: "",
    }
    onSignIn = (googleUser) => {
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
				// isSignedIn={true} // auto load
			/>
		);
	}
}

export default connect()(GoogleAuth);