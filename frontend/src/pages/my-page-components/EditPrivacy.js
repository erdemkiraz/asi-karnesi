import React from 'react';
import axios from "axios";
import {BASE_URL, BUILD_HEADER, getEmail} from "../../services/base_service";
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

            vaccine_id: this.props.vaccine_id,
            privacy_setting: "",
            user_email:"",

        };


        this.componentDidMount = this.componentDidMount.bind(this);


        this.changePrivacySetting = this.changePrivacySetting.bind(this);
        this.showSuccess = this.showSuccess.bind(this);


    }


    async componentDidMount() {

        this.setState({privacy_setting: "2"})
        let google_user = await get_storage("google_user");
        let email = getEmail(google_user)
        this.setState({user_email:email})
        await this.fetchData(this.state.vaccine_id);
    }

    async fetchData(vaccine_id) {
        let url = BASE_URL + "/get-privacy?vaccine_id=" + vaccine_id;
        let data = await axios.get(url, {headers: BUILD_HEADER("", this.state.user_email)});
        console.log(data)
        let payload = data.data;
        let vaccine_current_privacy = payload["privacy_setting"];
        this.setState({privacy_setting:vaccine_current_privacy})

        // this.setState({answers: ""});
        // this.setState({questions: ""});

    }


    printState() {
        console.log("State :", this.state);
    }


    async changePrivacySetting() {

        // let answers = this.state.answers;

        console.log("Privacy setting is changed");
        console.log(this.state.vaccine_id);
        console.log("New privacy : ", this.state.privacy_setting)

        let payload = {
            "vaccine_id" : this.state.vaccine_id,
            "setting" :this.state.privacy_setting
        }

        console.log("Payload : ", qs.stringify(payload))
        let url = BASE_URL + "/set-privacy";
        const options = {
            method: 'POST',
            headers: BUILD_HEADER("", this.state.user_email),
            data: qs.stringify(payload),
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
            {label: 'Just Friends', value: '1'},
            {label: 'Everybody (Public)', value: '2'},
            {label: 'Nobody', value: '0'}

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