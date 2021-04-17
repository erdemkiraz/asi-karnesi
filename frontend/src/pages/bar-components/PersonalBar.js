import React from "react";
import {connect} from "react-redux";
import {Link} from "react-router-dom";
import {BASE_URL, BUILD_HEADER, getGoogleId} from "../../services/base_service";
import {get_storage, remove_key, put_storage} from "../../services/StorageUtil";
import {Button} from "primereact/button";
import "../../css/divs.css";
import {SET_UNAUTHENTICATED, SET_USER, STOP_LOADING_UI} from "../../redux/types";
import axios from "axios";

import AppLogo from "../../imgs/vaccine_icon_64px.png"

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
        await this.loadUserFromLocalStorage()
    }

    capitalize(str) {
        if (str === null) {
            // console.log("Str is null")
            return "";
        }
        if (str.length < 1) {
            return ""
        } else if (str.length === 1) {
            return str.charAt(0).toUpperCase();
        }
        return str.charAt(0).toUpperCase() + str.slice(1);
    }

    async fetchUpdatedUsername(google_id) {

        let url = BASE_URL + "/user-info?google_id=" + google_id;
        let response = await axios.get(url, {headers: BUILD_HEADER()});

        let data = response.data["info"];
        // this.setState({name: data["name"]})
        return data["name"];
    }


    async loadUserFromLocalStorage() {
        const dispatch = this.props.dispatch;
        let user;
        user = get_storage("user");
        console.log("user")
        console.log(user)

        if (user) {
            dispatch({
                type: SET_USER,
                payload: user,
            });

            let google_id = getGoogleId(get_storage("google_user"));
            let name_from_db = await this.fetchUpdatedUsername(google_id)

            this.setState({name: name_from_db})
        }
        dispatch({type: STOP_LOADING_UI});
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

    getPersonalInformation() {
    }

    onSignIn(googleUser) {
        console.log("googleUser");
        console.log(googleUser);

        put_storage("google_user", googleUser);


        var profile = googleUser.getBasicProfile();

        let g_name = profile.getName();
        this.setState({name: g_name});
        let g_email = profile.getEmail();
        this.setState({email: g_email});
        this.setState({image: profile.getImageUrl()});

    }


    render() {
        const {user} = this.props;

        return (

            <div className="navbar">

                <div className="logo">
                    <div className="p-grid">
                        <div className="p-col-4">
                            <div className="p-field p-col">
                                <img src={AppLogo} alt="Logo" />
                            </div>
                        </div>
                        <div className="p-col-8">
                            <br/>
                            <h1>Asi Karnesi</h1>

                        </div>

                        {/*<div className="p-col-4">4</div>*/}
                    </div>


                </div>
                <div className="nav-right">
                    {user.isAuthenticated ? (
                        <>
                            {this.state.name}
                            {/*<Text style={{textTransform: 'capitalize'}}>test</Text>*/}
                            <img
                                style={{height: "7vh", borderRadius: "55%"}}
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

    }
}

const mapStateToProps = (state) => ({
    user: state.user,
});

export default connect(mapStateToProps)(PersonalBar);
