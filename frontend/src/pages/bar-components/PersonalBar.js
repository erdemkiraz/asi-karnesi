import React from "react";
import { connect } from "react-redux";
import { Link } from "react-router-dom";
import GoogleLogin from "react-google-login";
import { clientId, BASE_URL } from "../../services/base_service";
import { get_storage, remove_key, put_storage} from "../../services/StorageUtil";
import { Button } from "primereact/button";
import "../../css/divs.css";
import { SET_UNAUTHENTICATED, SET_USER, STOP_LOADING_UI } from "../../redux/types";
// import axios from "axios";

class PersonalBar extends React.Component {
	constructor() {
		super();
		this.state = {
			name: null,
			email: null,
			image: null,
		};

		this.componentDidMount = this.componentDidMount.bind(this);
		this.onSignIn = this.onSignIn.bind(this);
		this.handleLogout = this.handleLogout.bind(this);
		this.loadUserFromLocalStorage = this.loadUserFromLocalStorage.bind(this);
	}

	async componentDidMount() {
		this.loadUserFromLocalStorage()
	}

	loadUserFromLocalStorage() {
		const dispatch = this.props.dispatch;
		let user;
		user = get_storage("user");
		console.log(user)
		if (user) {
			dispatch({
				type: SET_USER,
				payload: user,
			});
		}
		dispatch({ type: STOP_LOADING_UI });
	};

	// a function to logout the user
	handleLogout() {
		const dispatch = this.props.dispatch;
		dispatch({
			type: SET_UNAUTHENTICATED,
		});
		// remove the user from local storage
		remove_key('user');
	}

	getPersonalInformation() {}

	onSignIn(googleUser) {
		console.log("googleUser");
		console.log(googleUser);

		put_storage("google_user", googleUser);

		// console.log("From storage : ")
		// console.log(get_storage("google_user"))
		//
		var profile = googleUser.getBasicProfile();

		let g_name = profile.getName();
		this.setState({ name: g_name });
		let g_email = profile.getEmail();
		this.setState({ email: g_email });
		this.setState({ image: profile.getImageUrl() });

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

		return (
			<div className="navbar">
				<div className="logo">
					<h1>Asi Karnesi</h1>
				</div>
				<div className="nav-right">
					{user.isAuthenticated ? (
						<>
							<img
								style={{ height: "7vh", borderRadius: "55%" }}
								alt={user.credentials.fullname}
								className="user-img"
								src={user.credentials.image}
							/>
							<Button onClick={this.handleLogout}>Logout</Button>
						</>
					) : (
						<Link to="/login">
							<Button>Login</Button>
						</Link>
					)}
				</div>
			</div>
		);

		// return (
		//     <div style={styles.personalbar}>

		//         <div className="p-grid">
		//             <div className="p-col-2">

		//                 {this.state.name}

		//             </div>
		//             <div className="p-col-5">

		//                 This area can include some information about logged in user!! like name picture etc...

		//             </div>
		//             <div className="p-col-3">

		//                 {this.state.email}
		//             </div>
		//             <div className="p-col-2">
		//                 <div className="p-grid">
		//                     <div className="p-col-6">

		//                         <img
		//                             style={{height: "7vh", borderRadius: "55%"}}
		//                             src={this.state.image}
		//                             alt="new"
		//                         />
		//                     </div>
		//                     <div className="p-col-6">
		//                         <GoogleLogin
		//                             clientId={clientId}
		//                             buttonText="Login"
		//                             onSuccess={this.onSignIn}
		//                             // onFailure={onFailure}
		//                             cookiePolicy={'single_host_origin'}
		//                             style={{height: "7vh", margin: '10px'}}
		//                             isSignedIn={true}
		//                         />
		//                     </div>
		//                 </div>
		//             </div>
		//         </div>

		//         <br/>

		//         {/*<Button label="Test button" onClick={this.testButton}/>*/}

		//     </div>

		// )
	}
}

const mapStateToProps = (state) => ({
	user: state.user,
});

export default connect(mapStateToProps)(PersonalBar);
