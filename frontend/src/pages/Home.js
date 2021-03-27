import React from "react";
// import GoogleLogin from "react-google-login";
import { Link } from "react-router-dom";
import { connect } from "react-redux";
import { clientId } from "../services/base_service";
import { Button } from "primereact/button";
import { put_storage, get_storage } from "../services/StorageUtil";

export class Home extends React.Component {
	constructor() {
		super();
		this.state = {
			// login : new Login(),
		};
		this.componentDidMount = this.componentDidMount.bind(this);
		this.onSignIn = this.onSignIn.bind(this);
		this.testButton = this.testButton.bind(this);
	}

	async componentDidMount() {}

	onSignIn(googleUser) {
		console.log("googleUser");
		console.log(googleUser);

		put_storage("google_user", googleUser);

		// console.log("From storage : ")
		// console.log(get_storage("google_user"))
		//
		// var profile = googleUser.getBasicProfile();
		// console.log('ID: ' + profile.getId()); // Do not send to your backend! Use an ID token instead.
		// put_storage('google_tokenId', googleUser.tokenId);
		// console.log('Name: ' + profile.getName());
		// console.log('Image URL: ' + profile.getImageUrl());
		// console.log('Email: ' + profile.getEmail()); // This is null if the 'email' scope is not present.
	}

	testButton() {
		// var google_tokenId = get_storage('google_tokenId');
		// window.localStorage.removeItem('googleProfile');
		console.log("google_tokenId from local Storage");
		console.log(get_storage("google_user"));

		// remove all
		// window.localStorage.clear();
	}

	render() {
		const { user } = this.props;
		const { fullname, email, image } = user.credentials;
		return (
			<div>
				<h1>Home Page</h1>
				<h2>{fullname}</h2>
				<h3>{email}</h3>
				<img src={image} />
				<div style={{ display: "flex", flexDirection: "column" }}>
					<Link to="/login">Login</Link>
					<Link to="/me">Me Page</Link>
					<Link to="/page-2">Page 2</Link>
				</div>
			</div>
		);
	}
}

const mapStateToProps = (state) => ({
	user: state.user,
});

export default connect(mapStateToProps)(Home);
