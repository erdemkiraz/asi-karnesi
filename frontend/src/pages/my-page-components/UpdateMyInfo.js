import React from "react";
import {InputText} from "primereact/inputtext";
import {Button} from "primereact/button";
import axios from "axios";
import {BASE_URL, BUILD_HEADER, getGoogleId} from "../../services/base_service";
import {get_storage} from "../../services/StorageUtil";
import {Panel} from "primereact/panel";
import {Messages} from "primereact/messages";
import {Toast} from "primereact/toast";
import {TabPanel, TabView} from "primereact/tabview";
import MyFriends from "./MyFriends";
import MyCodes from "./MyCodes";
import AddFriend from "./AddFriend";

export class UpdateMyInfo extends React.Component {
    constructor() {
        super();
        this.state = {
            logged_in_google_id: null,
            facebook_id: "",
            name: "",
            age: "",
            country_name: "",
        };

        this.componentDidMount = this.componentDidMount.bind(this);
        this.fetch_current_infos = this.fetch_current_infos.bind(this);

        this.sendUpdatedData = this.sendUpdatedData.bind(this);
    }

    async componentDidMount() {
        let google_user = await get_storage("google_user");
        let google_id = getGoogleId(google_user);

        this.setState({logged_in_google_id: google_id});
        console.log("Logged in email is : ", google_id);

        await this.fetch_current_infos();
    }

    async sendUpdatedData() {


        let payload = {
            "google_id": this.state.logged_in_google_id,
            "name": this.state.name,
            "facebook_id": this.state.facebook_id,
            "age": this.state.age,
            "country_name": this.state.country_name,
        }
        console.log(payload)

        let url = BASE_URL + "/update-user-info";
        const options = {
            method: 'POST',
            headers: BUILD_HEADER(),
            data: payload,
            url,
        };

        axios(options).then(data => {
            console.log(data);
            this.showSuccess();

        })

    }

    async fetch_current_infos() {
        let data = await axios.get(
            BASE_URL + "/friend-requests?google_id=" + this.state.logged_in_google_id,
            {headers: BUILD_HEADER()}
        );

        let requests = data.data["friend_requests"];
        this.setState({friend_requests: requests});
        console.log("requests");
        console.log(requests);
    }


    showSuccess() {
        this.messages.show({
            severity: "success",
            summary: "",
            detail: "Update info sent!",
        });
        this.toast.show({
            severity: "success",
            summary: "",
            detail: "Update info sent!",
        });
    }

    showError() {
        this.messages.show({
            severity: "error",
            summary: "",
            detail: "Update info failed",
        });
        this.toast.show({
            severity: "error",
            summary: "",
            detail: "Update info failed",
        });
    }


    render() {

        const baseStyle = {width: "100%"}
        return (
            <div style={baseStyle}>
                <div className="card" style={baseStyle}>
                    <TabView className="tabview-custom">
                        <TabPanel header="Update My Information" leftIcon="pi pi-user">

                            <div className="p-grid p-fluid">
                                <div className="p-col-12 p-md-6">
                                    <div className="p-field p-grid">
                                        <label className="p-col-fixed" style={{width: "100px"}}>
                                            Facebook ID
                                        </label>
                                        <div className="p-col">
                                            <InputText
                                                value={this.state.facebook_id}
                                                onChange={(e) =>
                                                    this.setState({facebook_id: e.target.value})
                                                }
                                            />
                                        </div>
                                    </div>
                                    <div className="p-field p-grid">
                                        <label className="p-col-fixed" style={{width: "100px"}}>
                                            Name
                                        </label>
                                        <div className="p-col">
                                            <InputText
                                                value={this.state.name}
                                                onChange={(e) =>
                                                    this.setState({name: e.target.value})
                                                }
                                            />
                                        </div>
                                    </div>
                                    <div className="p-field p-grid">
                                        <label className="p-col-fixed" style={{width: "100px"}}>
                                            Age
                                        </label>
                                        <div className="p-col">
                                            <InputText
                                                value={this.state.age}
                                                onChange={(e) =>
                                                    this.setState({age: e.target.value})
                                                }
                                            />
                                        </div>
                                    </div>

                                    <div className="p-field p-grid">
                                        <label className="p-col-fixed" style={{width: "100px"}}>
                                            Country Name
                                        </label>
                                        <div className="p-col">
                                            <InputText
                                                value={this.state.country_name}
                                                onChange={(e) =>
                                                    this.setState({country_name: e.target.value})
                                                }
                                            />
                                        </div>
                                    </div>


                                    <Button label="Update" onClick={() => this.sendUpdatedData()}/>
                                </div>
                                <div className="p-col-12 p-md-6">
                                </div>
                            </div>


                        </TabPanel>
                    </TabView>
                </div>
            </div>
        );
        //
        // return (
        //     <div>
        //         <Messages ref={(el) => (this.messages = el)}/>
        //         <Toast ref={(el) => (this.toast = el)}/>
        //         <TabView className="tabview-custom">
        //             <TabPanel header="My Friends" leftIcon="pi pi-user">
        //                 <div style={{height: "300px", margin: "10px"}}>
        //                 </div>
        //             </TabPanel>
        //         </TabView>
        //     </div>
        // );
    }
}

export default UpdateMyInfo;
