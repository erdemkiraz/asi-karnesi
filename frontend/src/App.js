import React from "react";
import {BrowserRouter as Router, Switch, Route} from "react-router-dom";
import {Provider} from "react-redux";
import store from "./redux/store";
import { SET_USER } from "./redux/types";
import "./css/custom.css";

import Welcome from "./pages/Welcome";
import Home from "./pages/Home";
import LoginPage from "./pages/auth/LoginPage";
import Statistics from "./pages/Statistics";

import UpdateMyInfo from "./pages/my-page-components/UpdateMyInfo";
import NavBar from "./pages/bar-components/PersonalBar";

// Routes
import PrivateRoute from "./routes/PrivateRoute";
import { TabMenu } from "primereact/tabmenu";

// services



class App extends React.Component {
    constructor() {
        super();
        this.state = {
            isAuthenticated: false,
            credentials: {},
        };
        this.componentDidMount = this.componentDidMount.bind(this);
    }

    async componentDidMount() {
    }

    render() {

        const items = [
            // {label: 'Home', icon: 'pi pi-fw pi-home', url: '/'},
            {label: 'Home', icon: 'pi pi-home', url: 'home'},
            {label: 'Statistics', icon: 'pi pi-table', url: 'statistics'},
            {label: 'My Profile', icon: 'pi pi-user-edit', url: 'me'},
            // {label: 'Page2', icon: 'pi pi-fw pi-pencil', url: 'page2'},
            // {label: 'Add Person', icon: 'pi pi-fw pi-pencil',url : 'AddPerson'},
        ]

        let activeItem = 1;

        return (
            <Provider store={store}>
                <Router>
                    <TabMenu model={items} activeItem={activeItem} onTabChange={(e) => activeItem = e}/>
                    <NavBar/>
                    <div className="container" style={{
                        display: "flex",
                        flexDirection: "column",
                        justifyContent: "center",
                        alignItems: "center"
                    }}>
                        <Switch>
                            <Route path="/" exact component={Welcome}/>
                            <PrivateRoute path="/home" exact component={Home}/>
                            <PrivateRoute path="/me" exact component={UpdateMyInfo}/>
                            <PrivateRoute path="/statistics" exact component={Statistics}/>
                            {/*<PrivateRoute path="/page-2" exact component={Page2}/>*/}
                            <Route path="/login" exact component={LoginPage}/>
                        </Switch>
                    </div>
                </Router>
            </Provider>
        );
    }
}

export default App;
