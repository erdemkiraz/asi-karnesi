import React from "react";
import {InputText} from "primereact/inputtext";
import {Button} from "primereact/button";
import axios from "axios";
import {BASE_URL, BUILD_HEADER, getGoogleId} from "../../services/base_service";
import {get_storage} from "../../services/StorageUtil";
import {Panel} from "primereact/panel";
import {Messages} from "primereact/messages";
import {Toast} from "primereact/toast";

export class AddFriend extends React.Component {
    constructor() {
        super();

        this.state = {
            // login : new Login(),
            logged_in_google_id: null,
            new_friend_email: "",
            new_friend_tckn: "",
            friend_requests: [],
            answered_request_ids: [],
        };

        this.componentDidMount = this.componentDidMount.bind(this);
        this.fetch_friend_requests = this.fetch_friend_requests.bind(this);

        this.addFriend = this.addFriend.bind(this);
        this.accept_friend_request = this.accept_friend_request.bind(this);
        this.decline_friend_request = this.decline_friend_request.bind(this);
        this.hideRepliedFriendRequest = this.hideRepliedFriendRequest.bind(this);

        this.sendDataForNewFriendRequest = this.sendDataForNewFriendRequest.bind(
            this
        );
        this.reset_state = this.reset_state.bind(this);
    }

    async componentDidMount() {
        let google_user = await get_storage("google_user");
        let google_id = getGoogleId(google_user);

        this.setState({logged_in_google_id: google_id});
        console.log("Logged in email is : ", google_id);

        await this.fetch_friend_requests();
    }

    async addFriend(e) {
        await this.sendDataForNewFriendRequest(e);
    }

    async sendDataForNewFriendRequest(e) {
        console.log("sendData");

        let data_to_send = {
            google_id: this.state.logged_in_google_id,
            friend_email: this.state.new_friend_email,
        };

        let url = BASE_URL + "/friend-request";
        const options = {
            method: "POST",
            headers: BUILD_HEADER(),
            data: data_to_send,
            url,
        };
        let data = await axios(options);
        console.log(data);
        // if (data.data.status !== 200) {
        // 	// this.messages.show({severity: 'error', summary: 'ERROR', detail: 'NOT ADDED'});
        // 	console.log("Error! not added");
        // } else {
        // 	// this.messages.show({severity: 'success', summary: 'Success', detail: 'add submitted'});
        // 	console.log("Add submitted");
        // }
        console.log(data.data.status);
        if (data.data.status === 200) {
            this.showSuccessAddFriend();
        } else {
            this.showErrorAddFriend(data.data["error"]);
        }
        // this.reset_state()
    }

    async fetch_friend_requests() {
        let data = await axios.get(
            BASE_URL + "/friend-requests?google_id=" + this.state.logged_in_google_id,
            {headers: BUILD_HEADER()}
        );

        // console.log("Data : ", data);
        let requests = data.data["friend_requests"];
        this.setState({friend_requests: requests});
        console.log("requests");
        console.log(requests);
    }

    hideRepliedFriendRequest(request_id) {

        let answered_ids_new = this.state.answered_request_ids;

        answered_ids_new.push(request_id)
        this.setState({answered_request_ids: answered_ids_new})

    }

    async accept_friend_request(request_id) {
        let data_to_send = {
            request_id: request_id,
        };


        let url = BASE_URL + "/accept-friend-request";
        const options = {
            method: "POST",
            headers: BUILD_HEADER(),
            data: data_to_send,
            url,
        };


        let response = await axios(options);
        console.log("POST RESPONSE", response.data);
        if (response.data["status"] === 200) {
            this.showSuccessApproved();
            this.hideRepliedFriendRequest(request_id)

        } else {
            this.showError();
        }
    }

    async decline_friend_request(request_id) {
        let data_to_send = {
            request_id: request_id,
        };

        let url = BASE_URL + "/reject-friend-request";
        const options = {
            method: "POST",
            headers: BUILD_HEADER(),
            data: data_to_send,
            url,
        };

        let response = await axios(options);
        console.log("POST RESPONSE", response.data);
        if (response.data["status"] === 200) {
            this.showSuccessRejected();
            this.hideRepliedFriendRequest(request_id)
        } else {
            this.showError();
        }
    }

    reset_state() {
        this.setState({
            email: null,
            tckn: null,
        });
    }

    showSuccessAddFriend() {
        this.messages.show({
            severity: "success",
            summary: "",
            detail: "Friend request sent!",
        });
        this.toast.show({
            severity: "success",
            summary: "",
            detail: "Friend request sent!",
        });
    }


    showErrorAddFriend(msg) {
        this.messages.show({
            severity: "error",
            summary: "",
            detail: msg,
        });
        this.toast.show({
            severity: "error",
            summary: "",
            detail: msg,
        });
    }

    showSuccessApproved() {
        this.messages.show({
            severity: "success",
            summary: "",
            detail: "Friend request approved",
        });
        this.toast.show({
            severity: "success",
            summary: "",
            detail: "Friend request approved",
        });
    }

    showSuccessRejected() {
        this.messages.show({
            severity: "success",
            summary: "",
            detail: "Friend request rejected",
        });
        this.toast.show({
            severity: "success",
            summary: "",
            detail: "Friend request rejected",
        });
    }

    showError() {
        this.messages.show({
            severity: "error",
            summary: "",
            detail: "Friend request failed",
        });
        this.toast.show({
            severity: "error",
            summary: "",
            detail: "Friend request failed",
        });
    }


    render() {
        const dynamicFriendRequests = this.state.friend_requests.map((col, i) => {
            // return <div key={i} ></div>;
            let request_id = col["request_id"];

            if (this.state.answered_request_ids.indexOf(request_id) > -1) {
                return (
                    <div key={i}/>
                );
            }

            let acceptButton = (
                <Button
                    label="Accept"
                    icon="pi pi-check"
                    className="p-button-success"
                    onClick={() => this.accept_friend_request(request_id)}
                />
            );
            let declineButton = (
                <Button
                    label="Decline"
                    icon="pi pi-times"
                    className="p-button-danger"
                    onClick={() => this.decline_friend_request(request_id)}
                />
            );

            return (
                <div key={i} className="p-fluid p-formgrid p-grid">
                    <div className="p-field p-col">
                        <label>{col["requester_name"]}</label>
                        <br/>
                    </div>
                    <div className="p-field p-col">
                        <label>{col["requester_email"]}</label>
                        <br/>
                    </div>
                    <div className="p-field p-col">
                        {acceptButton}
                        <br/>
                    </div>
                    <div className="p-field p-col">
                        {declineButton}
                        <br/>
                    </div>
                </div>
            );
        });

        return (
            <div>
                <Messages ref={(el) => (this.messages = el)}/>
                <Toast ref={(el) => (this.toast = el)}/>
                <div style={{height: "300px", margin: "10px"}}>
                    <div className="p-grid p-fluid">
                        <div className="p-col-12 p-md-6">
                            <Panel header="Add new Friend" className="p-jc-start" toggleable>

                                <div className="p-field p-grid">
                                    <label className="p-col-fixed" style={{width: "100px"}}>
                                        Email
                                    </label>
                                    <div className="p-col">
                                        <InputText
                                            value={this.state.new_friend_email}
                                            onChange={(e) =>
                                                this.setState({new_friend_email: e.target.value})
                                            }
                                        />
                                    </div>
                                </div>
                                <br/>
                            </Panel>


                            <Button label="Add" onClick={(e) => this.addFriend(e)}/>
                        </div>
                        <div className="p-col-12 p-md-6">
                            <Panel header="Friend Requests" className="p-jc-start" toggleable>
                                {dynamicFriendRequests}
                            </Panel>
                        </div>
                    </div>
                </div>
            </div>
        );
    }
}

export default AddFriend;
