import React from "react";
import { Redirect, Route } from "react-router-dom";
import { connect } from "react-redux";
import Loading from "../components/Loading";

class PrivateRoute extends React.Component {
	render() {
		const {
			isAuthenticated,
			isLoading,
			component: PrivateComponent,
			...rest
		} = this.props;
		// Check if the user is authenticated
		// If they are not authenticated redirect them to the login page
		return (
			<Route
				{...rest}
				render={(props) =>
					isLoading ? <Loading /> :  isAuthenticated ? <PrivateComponent /> : <Redirect to="/login" />
				}
			/>
		);
	}
}

const mapStateToProps = (state) => ({
	isAuthenticated: state.user.isAuthenticated,
	isLoading: state.ui.isLoading,
});

export default connect(mapStateToProps)(PrivateRoute);
