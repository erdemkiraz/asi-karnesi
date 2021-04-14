import React, { Component } from 'react';
import { Link } from "react-router-dom";
import GoogleAuth from "../../components/GoogleAuth";

class LoginPage extends Component {
    render() {
        return (
            <div>
                <h1>Login Page</h1>
                <GoogleAuth history={this.props.history} />
                {/*<Link to="/">Home Page</Link>*/}
            </div>
        )
    }
}

export default LoginPage
