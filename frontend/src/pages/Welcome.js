import React from "react";
import { connect } from "react-redux";
import { put_storage, get_storage } from "../services/StorageUtil";

export class Welcome extends React.Component {
	constructor() {
		super();
		this.state = {
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
				<img src={image} alt="pp" />

			</div>
		);
	}
}

const mapStateToProps = (state) => ({
	user: state.user,
});

export default connect(mapStateToProps)(Welcome);
