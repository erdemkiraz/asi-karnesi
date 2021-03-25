import React from "react";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";
import { Provider } from "react-redux";
import store from "./redux/store";
import "./css/custom.css";
// import axios from "axios";
// import {BASE_URL, BUILD_HEADER} from "./services/base_service";
// import PersonalBar from "./pages/bar-components/PersonalBar";

// pages
import HomePage from "./pages/Home";
import LoginPage from "./pages/auth/LoginPage";
import MePage from "./pages/MyPage";
import Page2 from "./pages/Page2";
import NavBar from "./pages/bar-components/PersonalBar";

// Routes
import PrivateRoute from "./routes/PrivateRoute";

class App extends React.Component {
	constructor() {
		super();
		this.state = {
			isAuthenticated: false,
			credentials: {},
		};
		this.componentDidMount = this.componentDidMount.bind(this);
	}

	async componentDidMount() {}

	render() {
		return (
			<Provider store={store}>
				<Router>
					<NavBar />
					<div className="container" style={{
						display: "flex",
						flexDirection: "column",
						justifyContent: "center",
						alignItems: "center"
					}}>
						<Switch>
							<Route path="/" exact component={HomePage} />
							<PrivateRoute path="/me" exact component={MePage} />
							<PrivateRoute path="/page-2" exact component={Page2} />
							<Route path="/login" exact component={LoginPage} />
						</Switch>
					</div>
				</Router>
			</Provider>
		);
	}
}

export default App;
