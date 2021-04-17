import React, { Component } from "react";
import GoogleAuth from "../../components/GoogleAuth";
import Styles from "./login.module.css";

class LoginPage extends Component {
	render() {
		return (
			<div className={Styles.container}>
				<div className={Styles.welcome}>
					<h1 className={Styles.h1}>We value your health</h1>
					<h3 className={Styles.h3}>Verify and share vacccines</h3>
				</div>
				<div className={Styles.login}>
					<GoogleAuth history={this.props.history} />
				</div>
			</div>
		);
	}
}
export default LoginPage;
