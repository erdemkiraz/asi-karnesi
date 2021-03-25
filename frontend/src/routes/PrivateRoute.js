import React from "react";
import { Redirect, Route } from "react-router-dom";
import { connect } from "react-redux";

class PrivateRoute extends React.Component {
	render() {
		const {
			isAuthenticated,
			component: PrivateComponent,
			...rest
		} = this.props;
		// Check if the user is authenticated
		// If they are not authenticated redirect them to the login page
		return (
			<Route
				{...rest}
				render={(props) =>
					isAuthenticated ? <PrivateComponent /> : <Redirect to="/login" />
				}
			/>
		);
	}
}

const mapStateToProps = (state) => ({
	isAuthenticated: state.user.isAuthenticated,
});

export default connect(mapStateToProps)(PrivateRoute);
