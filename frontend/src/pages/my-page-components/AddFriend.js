import React from 'react';
import {InputText} from "primereact/inputtext";
import {Button} from "primereact/button";
import axios from "axios";
import {BASE_URL, BUILD_HEADER, getEmail} from "../../services/base_service";
import {get_storage} from "../../services/StorageUtil";
import {Panel} from "primereact/panel";


export class AddFriend extends React.Component {

    constructor() {
        super();

        this.state = {

            // login : new Login(),
            logged_in_email: null,
            new_friend_email: "",
            new_friend_tckn: "",
            friend_requests: [],

        };

        this.componentDidMount = this.componentDidMount.bind(this);
        this.fetch_friend_requests = this.fetch_friend_requests.bind(this);


        this.addFriend = this.addFriend.bind(this);
        this.accept_friend_request = this.accept_friend_request.bind(this);
        this.decline_friend_request = this.decline_friend_request.bind(this);


        this.sendData = this.sendData.bind(this);
        this.reset_state = this.reset_state.bind(this);


    }


    async componentDidMount() {
        let google_user = await get_storage("google_user");
        let email = getEmail(google_user)

        this.setState({logged_in_email: email});
        console.log("Logged in email is : ", email);

        await this.fetch_friend_requests();

    }

    async addFriend(e) {
        await this.sendData(e)
    }

    async sendData(e) {
        console.log("sendData")
        let data = await axios.post(BASE_URL + "/add-new-friend", {"data": this.state}) // TODO : add user email to send
        console.log(data)
        if (data.data.status !== 200) {
            // this.messages.show({severity: 'error', summary: 'ERROR', detail: 'NOT ADDED'});
            console.log("Error! not added")
        } else {
            // this.messages.show({severity: 'success', summary: 'Success', detail: 'add submitted'});
            console.log("Add submitted")
        }
        console.log(data.data.status)
        this.reset_state()
    }

    async fetch_friend_requests() {
        let data = await axios.get(BASE_URL + "/get-friend-requests", {headers: BUILD_HEADER("API_TOKEN", this.state.logged_in_email)})
        console.log("Data : ", data);
        let requests = data.data["requests"]
        this.setState({friend_requests: requests});
        console.log(requests)
    }

    accept_friend_request(email) {

    }

    decline_friend_request(email) {

    }

    reset_state() {
        this.setState({
            email: null,
            tckn: null
        })
    }


    render() {


        const dynamicFriendRequests = this.state.friend_requests.map((col, i) => {

            console.log("col", col)
            console.log("i", i)

            // return <div key={i} ></div>;

            let acceptButton = <Button label="Accept" icon="pi pi-check" className="p-button-success"
                                       onClick={this.accept_friend_request(col["email"])}/>;
            let declineButton = <Button label="Decline" icon="pi pi-check" className="p-button-danger"
                                        onClick={this.accept_friend_request(col["email"])}/>;

            return (
                <div key={i} className="p-fluid p-formgrid p-grid">
                    <div className="p-field p-col">
                        <label>{col["email"]}</label><br/>
                    </div>
                    <div className="p-field p-col">
                        {acceptButton}<br/>
                    </div>
                    <div className="p-field p-col">
                        {declineButton}<br/>
                    </div>
                </div>
            )
                ;
        });


        return (<div>

                <div style={{'height': '300px', 'margin': '10px'}}>

                    <div className="p-grid p-fluid">
                        <div className="p-col-12 p-md-6">
                            <div className="p-field p-grid">
                                <label className="p-col-fixed"
                                       style={{width: '100px'}}>Email</label>
                                <div className="p-col">
                                    <InputText value={this.state.new_friend_email}
                                               onChange={(e) => this.setState({new_friend_email: e.target.value})}/>
                                </div>
                            </div>
                            or <br/><br/>
                            <div className="p-field p-grid">
                                <label className="p-col-fixed"
                                       style={{width: '100px'}}>TCKN</label>
                                <div className="p-col">
                                    <InputText value={this.state.new_friend_tckn}
                                               onChange={(e) => this.setState({new_friend_tckn: e.target.value})}/>
                                </div>
                            </div>
                            <Button label="Add"  onClick={(e) => this.addFriend(e)}/>
                        </div>
                        <div className="p-col-12 p-md-6">
                            <Panel header="Friend Requests" toggleable>
                                {dynamicFriendRequests}
                            </Panel></div>
                    </div>
                </div>
                This is Add friend page!!
            </div>
        );
    }
}

export default AddFriend;
