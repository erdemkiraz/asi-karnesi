import React from 'react';
import axios from "axios";
import {BASE_URL, BUILD_HEADER} from "../../services/base_service";
import {Button} from "primereact/button";
import {Panel} from "primereact/panel";
import {Messages} from "primereact/messages";
import {Toast} from "primereact/toast";
import {InputText} from "primereact/inputtext";


class EditPrivacy extends React.Component {
    constructor(props) {
        super(props);

        this.state = {

            vaccine_id: this.props.vaccine_id

        };


        this.componentDidMount = this.componentDidMount.bind(this);


        this.changePrivacySetting = this.changePrivacySetting.bind(this);
        this.showSuccess = this.showSuccess.bind(this);


    }


    async componentDidMount() {

        // await this.fetchData("");
    }

    async fetchData(vaccine_id) {
        let url = BASE_URL + "/get/privacy/" + vaccine_id;
        let data = await axios.get(url, {headers: BUILD_HEADER("", "")});


        this.setState({answers: ""});
        this.setState({questions: ""});

    }


    printState() {
        console.log("State :", this.state);
    }


    async changePrivacySetting() {

        // let answers = this.state.answers;

        console.log("Privacy setting is changed");
        console.log(this.state.vaccine_id);

        // let url = BASE_URL+"/edit/new_submission/" + this.state.vaccine_id;
        //  const options = {
        //      method: 'POST',
        //      headers: {  'APIKEY' : "" },
        //      // data: data,
        //      // data: answers,
        //      // data: qs.stringify(answers),
        //      url,
        //  };
        //
        //  let response = await axios(options);
        //  console.log("POST RESPONSE", response.data);
        //
        //  if(response.data["responseCode"] === 200){
        //      this.showSuccess();
        //  }
        //  else{
        //      this.showGenericError("Privacy settting is NOT changed!")
        //  }
    }

    showSuccess() {
        this.messages.show({severity: 'success', summary: 'Editing is Success!', detail: ' Privacy data has changed'});
        // this.toast.show({severity: 'success', summary: 'Editing is Success', detail: 'Privacy data has changed'});

    }


    showError() {
        this.messages.show({severity: 'error', summary: 'Need to authorize first!', detail: 'Validation failed'});
        // this.toast.show({ severity: 'error', summary: 'Need to authorize first!', detail: 'Validation failed' });
    }


    showGenericError(msg) {
        this.messages.show({severity: 'error', summary: 'Error!', detail: msg});
        // this.toast.show({ severity: 'error', summary: 'Error!', detail: msg });
    }

    submissionOnChange(key, value) {

        // let temp = this.state.answers;
        //
        // temp[key] = value;
        // this.setState({answers : temp});

    }

    render() {


        let header = <div>
        </div>;


        return (

            <div>


                <Messages ref={(el) => this.messages = el}/>
                <Toast ref={(el) => this.toast = el}/>

                <div style={{'height': '300px', 'margin': '10px'}}>

                    <div className="p-grid p-fluid" style={{'height': '300px', 'margin': '10px'}}>
                        <div className="p-col-12 p-md-4">
                            BOX1
                        </div>

                        <div className="p-col-12 p-md-4">
                            <div className="p-field p-grid">
                                box2
                            </div>
                            <Button  label="Change privacy setting!" style={{"margin":"10px"}} onClick={this.changePrivacySetting}/>
                        </div>
                        <div className="p-col-12 p-md-4">
                            Box3
                        </div>
                    </div>
                </div>


            </div>
        );
    }
}

export default EditPrivacy;
