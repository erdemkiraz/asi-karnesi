import React from 'react';
import axios from "axios";
import {BASE_URL, BUILD_HEADER, getGoogleId} from "../../services/base_service";
import {Button} from "primereact/button";
import {Messages} from "primereact/messages";
import {Toast} from "primereact/toast";
import qs from 'qs';
import {Dropdown} from "primereact/dropdown";
import {get_storage} from "../../services/StorageUtil";


class EditPrivacy extends React.Component {
    constructor(props) {
        super(props);

        this.state = {

            vaccination_id: this.props.vaccination_id,
            privacy_setting: "",
            google_id:"",

        };


        this.componentDidMount = this.componentDidMount.bind(this);


        this.changePrivacySetting = this.changePrivacySetting.bind(this);
        this.showSuccess = this.showSuccess.bind(this);


    }


    async componentDidMount() {

        this.setState({privacy_setting: "2"})
        let google_user = await get_storage("google_user");
        let google_id = getGoogleId(google_user)
        this.setState({google_id:google_id})
        await this.fetchData(this.state.vaccination_id);
    }

    async fetchData(vaccination_id) {
        let url = BASE_URL + "/get-privacy?vaccination_id=" + vaccination_id;
        let data = await axios.get(url, {headers: BUILD_HEADER()});
        console.log(data)
        let payload = data.data;
        let vaccine_current_privacy = payload["privacy_setting"];
        console.log("vaccine_current_privacy")
        console.log(vaccine_current_privacy)
        this.setState({privacy_setting:vaccine_current_privacy})


    }

    printState() {
        console.log("State :", this.state);
    }


    async changePrivacySetting() {


        console.log("Privacy setting is changed");
        console.log(this.state.vaccination_id);
        console.log("New privacy : ", this.state.privacy_setting)

        let payload = {
            "google_id" : this.state.google_id,
            "vaccination_id" : this.state.vaccination_id,
            "new_privacy" : this.state.privacy_setting
        }

        console.log("Payload : ", payload)
        let url = BASE_URL + "/set-privacy";
        const options = {
            method: 'POST',
            headers: BUILD_HEADER(),
            data: payload,
            url,
        };

        let response = await axios(options);
        console.log("POST RESPONSE", response.data);

        if (response.data["status"] === 200) {
            this.showSuccess();
        } else {
            this.showGenericError("Privacy settting is NOT changed!")
        }
    }

    showSuccess() {
        this.messages.show({severity: 'success', summary: '', detail: 'Success! Privacy data has changed'});
        // this.toast.show({severity: 'success', summary: 'Editing is Success', detail: 'Privacy data has changed'});

    }


    showError() {
        this.messages.show({severity: 'error', summary: '', detail: 'Need to authorize first! Validation failed'});
        // this.toast.show({ severity: 'error', summary: 'Need to authorize first!', detail: 'Validation failed' });
    }


    showGenericError(msg) {
        this.messages.show({severity: 'error', summary: '', detail: "Error!" + msg});
        // this.toast.show({ severity: 'error', summary: 'Error!', detail: msg });
    }

    submissionOnChange(key, value) {


    }

    render() {

        const privacySettings = [
            {label: 'Public', value: 5},
            {label: 'Fb friends', value: 4},
            {label: 'Friends', value: 3},
            {label: 'Permitted Users', value: 2},
            {label: 'All Admins', value: 1},
            {label: 'Private', value: 0}

        ];


        return (

            <div>


                <Messages ref={(el) => this.messages = el}/>
                <Toast ref={(el) => this.toast = el}/>

                <div style={{'height': '300px', 'margin': '10px'}}>

                    <div className="p-grid p-fluid" style={{'height': '300px', 'margin': '10px'}}>
                        <div className="p-col-12 p-md-2">
                        </div>

                        <div className="p-col-12 p-md-8">
                            <div className="p-field p-grid">
                                <h4>Change the selected vaccine's privacy setting : </h4> <br/>
                                <Dropdown value={this.state.privacy_setting} options={privacySettings}
                                          onChange={(e) => this.setState({privacy_setting: e.value})}
                                          placeholder="Select a privacy setting"/>
                            </div>
                            <Button label="Change privacy setting!" style={{"margin": "10px"}}
                                    onClick={this.changePrivacySetting}/>
                        </div>
                        <div className="p-col-12 p-md-2">
                        </div>
                    </div>
                </div>


            </div>
        );
    }
}

export default EditPrivacy;