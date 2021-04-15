import React from 'react';
import {Panel} from "primereact/panel";
import {InputText} from "primereact/inputtext";
import {DataTable} from "primereact/datatable";
import {Column} from "primereact/column";
import {Button} from "primereact/button";
import {AxiosInstance as axios} from "axios";
import {BASE_URL, BUILD_HEADER} from "../../services/base_service";
import {Dialog} from "primereact/dialog";
import {Toast} from "primereact/toast";

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
        this.takeActionButton = this.takeActionButton.bind(this);
        this.sendAuthCode = this.sendAuthCode.bind(this);

        this.onHide = this.onHide.bind(this);
        this.onClick = this.onClick.bind(this);


    }


    async componentDidMount() {
        this.fetchInitialData();

    }


    async fetchInitialData() {
        // let response = await axios.get(BASE_URL + "/google/my-friends" + "?google_id=" + this.state.logged_in_google_id, BUILD_HEADER())
        // let data = response.data;
        //
        // let is_auth = data["is_auth"]
        let is_auth = false;


        if (is_auth) {
            this.setState({auth_icon: "pi pi-unlock"})
            this.showSuccess()
        } else {
            // pop up shows
            this.showWarn();
            this.setState({auth_url: "Bu bir link!"})
            this.onClick('displayModal');
        }

    }

    showSuccess() {
        this.toast.show({severity: 'success', summary: 'Authorize Success', detail: 'Access token acquired'});
    }

    showWarn() {
        this.toast.show({severity: 'warn', summary: 'Authorize Needed', detail: 'Access token could not acquired'});
    }

    takeActionButton(row) {

        console.log("Row", row)

        // console.log(form["id"], bool)
        return (
            <div>
                <Button type="button" onClick={() => {
                }} label="Download" icon="pi pi-file-excel" className="p-button-secondary"/>
                {/*<Button type="button"   label="Excel" icon="pi pi-google" className="p-button-secondary"   />*/}
            </div>);

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
            "AuthCode": this.state.api_token
        }

        console.log("Payload : ", payload)
        // let url = BASE_URL + "/google/auth-code";
        // const options = {
        //     method: 'POST',
        //     headers: BUILD_HEADER(),
        //     data: payload,
        //     url,
        // };
        //
        // let response = await axios(options);

        this.onHide("displayModal");
        await this.fetchInitialData();
        //
        // let data = await axios.get(BASE_URL + "/google/authenticate", {
        //     headers: {
        //         "AuthCode": "",
        //         "FormId": this.state.form_id
        //     }
        // })

        // check wheter user is authenticated or not
        // if authenticated => do nothing
        // if not authenticated => ask for a auth code from url !
        // console.log(" Try Autherize : ", data.data);
        // data = data.data;
        // if (data["autherized"] === true) {
        //     let accessToken = data["accessToken"];
        //     this.setState({access_token: accessToken})
        //     // accesssTokenToExport = this.state.access_token;
        //     // console.log("Access Token : ", this.state.access_token);
        //     this.showSuccess();
        // } else {
        //     console.log("Autherize fail : ", data.data);
        //     this.showWarn();
        //     this.setState({url: data["authUrl"]})
        //     this.onClick('displayModal');
        // }
        // return data;
    }


    render() {
        const myIcon = (
            <button className="p-dialog-titlebar-icon p-link">
                <span className={this.state.auth_icon}></span>
            </button>
        )

        return (<div>


                <Toast ref={(el) => this.toast = el}/>

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
                            {/*<Column field="id" header="ID" ></Column>*/}
                            <Column field="name" header="Name" filter filterPlaceholder="Search by name"
                                    filterMatchMode="contains"></Column>
                            <Column field="phone_number" header="Phone Number" filter
                                    filterPlaceholder="Search by number"
                                    filterMatchMode="contains"></Column>
                            <Column field="email" header="Email" filter
                                    filterPlaceholder="Search by email"
                                    filterMatchMode="contains"></Column>
                            <Column header="Action" body={this.takeActionButton}/>


                        </DataTable>

                    </Panel>


                    {/*<Button label="Add" onClick={(e) => this.addFriend(e)}/>*/}
                </div>
                {/*<div className="p-col-12 p-md-1">*/}
                {/*<Button label="Autherize" icon={this.state.auth_icon} onClick={this.authorize}/>*/}

                <Dialog header="Google Contact Auth." icons={myIcon} visible={this.state.displayModal} modal={false}
                        style={{width: '50vw'}} onHide={() => this.onHide('displayModal')}>

                    <h6>Your authentication has expired or you never did. Please confirm again.</h6>
                    <h5>Click to the url and copy the Authentication Code to below. </h5>
                    <a href={this.state.auth_url} target="_blank" rel="noreferrer">
                        {" "}
                        {this.state.auth_url}
                    </a>

                    <span className="p-float-label" style={{margin: "15px"}}>
                        <InputText value={this.state.api_token}
                                   onChange={(e) => this.setState({api_token: e.target.value})}
                                   style={{width: "400px", margin: "5px"}}/>
                        <label>Api Token</label>

                    </span>
                    <Button label="Send Authentication Code" onClick={this.sendAuthCode}/>

                </Dialog>

                {/*</div>*/}

            </div>
        );
    }
}

export default MyGoogleFriends;
