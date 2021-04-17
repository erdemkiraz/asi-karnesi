import React from 'react';
import {Panel} from "primereact/panel";
import {InputText} from "primereact/inputtext";
import {DataTable} from "primereact/datatable";
import {Column} from "primereact/column";
import {Button} from "primereact/button";
import axios from "axios";
import {BASE_URL, BUILD_HEADER, getGoogleId} from "../../services/base_service";
import {get_storage} from "../../services/StorageUtil";
import {Dialog} from "primereact/dialog";
import {Messages} from "primereact/messages";


export class MyGoogleFriends extends React.Component {

    constructor() {
        super();

        this.state = {

            logged_in_google_id: null,
            google_friends: [],
            can_fetch_my_contacts: false,
            auth_url: "",
            api_token: "",
            auth_icon: "pi pi-lock"
        };
        this.componentDidMount = this.componentDidMount.bind(this);
        this.addFriendOrInviteMailButton = this.addFriendOrInviteMailButton.bind(this);


        this.inviteMailButton = this.inviteMailButton.bind(this);
        this.sendSMSInviteButton = this.sendSMSInviteButton.bind(this);
        this.sendAuthCode = this.sendAuthCode.bind(this);
        this.sendDataForNewFriendRequest = this.sendDataForNewFriendRequest.bind(this);
        this.sendEmailInvite = this.sendEmailInvite.bind(this);
        this.sendSMSInvite = this.sendSMSInvite.bind(this);

        this.onHide = this.onHide.bind(this);
        this.onClick = this.onClick.bind(this);


    }


    async componentDidMount() {
        let google_user = await get_storage("google_user");
        let google_id = getGoogleId(google_user);

        this.setState({logged_in_google_id: google_id});
        this.fetchInitialData();
    }

    async sendDataForNewFriendRequest(email) {
        console.log("sendData");

        let data_to_send = {
            google_id: this.state.logged_in_google_id,
            friend_email: email,
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

        console.log(data.data.status);
        try {
            if (data.data.status === 200) {
                this.showSuccessAddFriend();
            } else {
                this.showErrorAddFriend(data.data["error"]);
            }
        } catch (e) {
        }
    }

    showSuccessAddFriend() {
        this.messages.show({
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

    }


    async fetchInitialData() {
        let response = await axios.get(BASE_URL + "/google/my-friends?google_id=" + this.state.logged_in_google_id, BUILD_HEADER())
        let data = response.data;

        let is_auth = data["is_auth"]
        // let is_auth = false;
        console.log(data);

        if (is_auth) {
            this.setState({auth_icon: "pi pi-unlock"})
            this.setState({google_friends: data["friends"]})
            this.showSuccess()

        } else {
            // pop up shows
            this.showWarn();
            this.setState({auth_url: data["auth_url"]})
            this.onClick('displayModal');
        }

    }

    showSuccess() {
        try {
            this.messages.show({severity: 'success', summary: '', detail: 'Authorize Success! Access token acquired'});

        } catch (e) {

        }
    }

    showWarn() {
        try {
            this.messages.show({
                severity: 'warn',
                summary: 'Authorize Needed',
                detail: 'Access token could not acquired'
            });

        } catch (e) {

        }
    }

    addFriendOrInviteMailButton(row) {
        console.log("Add Frient or Invite Mail Row", row)

        let bool = row["is_user"]
        if (bool) {
            return (
                <div>
                    <Button type="button" onClick={() => this.sendDataForNewFriendRequest(row["email"])}
                            label="Add Friend" icon="pi pi-user-plus" className="p-button-secondary"/>
                </div>);
        } else
            return <div></div>;


    }

    inviteMailButton(row) {

        let bool = !row["email"]
        let bool2 = row["is_user"]
        return (
            <div>
                <Button type="button" onClick={() => this.sendEmailInvite(row["email"], row["name"])}
                        label="Invite" disabled={bool | bool2}
                        icon="pi pi-inbox" className="p-button-secondary"/>
            </div>
        )
            ;

    }


    sendSMSInviteButton(row) {
        // console.log("Text Invite Row", row)

        let bool = row["phone"].length <= 0 || row["is_user"];
        return (
            <div>
                <Button type="button" onClick={() => this.sendSMSInvite(row["phone"], row["name"])} label="Invite"
                        icon="pi pi-comment" className="p-button-secondary" disabled={bool}/>
            </div>);
        ;
    }

    async sendEmailInvite(email, name) {
        let data_to_send = {
            google_id: this.state.logged_in_google_id,
            friend_email: email,
            name: name,
        };

        let url = BASE_URL + "/invite-email";
        const options = {
            method: "POST",
            headers: BUILD_HEADER(),
            data: data_to_send,
            url,
        };
        let data = await axios(options);

        if (data.data.status === 200) {
            this.messages.show({
                severity: "success",
                summary: "",
                detail: "Invite request sent!",
            });

        } else {
            this.messages.show({
                severity: "error",
                summary: "",
                detail: data.data["error"],
            });

        }
    }


    async sendSMSInvite(phone, name) {

        console.log("SendSmsInmvite")
        let data_to_send = {
            google_id: this.state.logged_in_google_id,
            friend_phone: phone,
            name: name,
        };

        let url = BASE_URL + "/invite-sms";
        const options = {
            method: "POST",
            headers: BUILD_HEADER(),
            data: data_to_send,
            url,
        };
        let data = await axios(options);

        if (data.data.status === 200) {
            this.messages.show({
                severity: "success",
                summary: "",
                detail: "Invite request sent!",
            });

        } else {
            this.messages.show({
                severity: "error",
                summary: "",
                detail: data.data["error"],
            });

        }
    }

    onHide(name) {
        this.setState({
            [`${name}`]: false
        });
    }

    onClick(name, position) {
        let state = {
            [`${name}`]: true
        };

        if (position) {
            state = {
                ...state,
                position
            }
        }

        this.setState(state);
    }

    async sendAuthCode() {

        let payload = {
            "google_id": this.state.logged_in_google_id,
            "google_code": this.state.api_token
        }

        console.log("Payload : ", payload)
        let url = BASE_URL + "/google/auth-contact";
        const options = {
            method: 'POST',
            headers: BUILD_HEADER(),
            data: payload,
            url,
        };

        await axios(options);

        this.onHide("displayModal");
        await this.fetchInitialData();

    }


    render() {
        const myIcon = (
            <button className="p-dialog-titlebar-icon p-link">
                <span className={this.state.auth_icon}></span>
            </button>
        )

        return (<div>
                <Messages ref={(el) => (this.messages = el)}/>
                <div className="card">

                    <Panel header="Google Contacts" className="p-jc-start" toggleable>
                        <DataTable
                            value={this.state.google_friends}
                            paginator={true}
                            paginatorTemplate="FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink CurrentPageReport RowsPerPageDropdown"
                            currentPageReportTemplate="Showing {first} to {last} of {totalRecords} friends"
                            rows={10}
                            rowsPerPageOptions={[5, 10, 20]} style={{margin: "10px"}}
                            dataKey="id"
                            emptyMessage="There is no google friend yet!"
                        >
                            <Column field="name" header="Name" sortable filter filterPlaceholder="Search by name"
                                    filterMatchMode="contains"></Column>
                            <Column field="phone" header="Phone Number" sortable filter
                                    filterPlaceholder="Search by number"
                                    filterMatchMode="contains"></Column>
                            <Column header="" body={this.sendSMSInviteButton}/>
                            <Column field="email" header="Email" sortable filter
                                    filterPlaceholder="Search by email"
                                    filterMatchMode="contains"></Column>
                            <Column header="" body={this.inviteMailButton}/>
                            <Column header="" body={this.addFriendOrInviteMailButton}/>

                        </DataTable>

                    </Panel>


                    {/*<Button label="Add" onClick={(e) => this.addFriend(e)}/>*/}
                </div>
                {/*<div className="p-col-12 p-md-1">*/}
                {/*<Button label="Autherize" icon={this.state.auth_icon} onClick={this.authorize}/>*/}

                <Dialog header="Google Contact Auth." icons={myIcon} visible={this.state.displayModal} modal={false}
                        style={{width: '50vw'}} onHide={() => this.onHide('displayModal')}>

                    <h6>Your authentication has expired or you never did. Please confirm again.</h6>
                    <h5>Click to the link below and paste the Authentication Code. </h5>
                    <a href={this.state.auth_url} target="_blank" rel="noreferrer">
                        {" "}
                        {"Click Here"}
                    </a>

                    <span className="p-float-label" style={{margin: "15px"}}>
                        <InputText value={this.state.api_token}
                                   onChange={(e) => this.setState({api_token: e.target.value})}
                                   style={{width: "400px", margin: "5px"}}/>
                        <label>Api Token</label>

                    </span>
                    <Button label="Authenticate" onClick={this.sendAuthCode}/>

                </Dialog>

                {/*</div>*/}

            </div>
        );
    }
}

export default MyGoogleFriends;
