import React from 'react';
import axios from "axios";
import {BASE_URL,BUILD_HEADER} from "../../services/base_service";
import {Button} from "primereact/button";
import {Panel} from "primereact/panel";
import {Messages} from "primereact/messages";
import {Toast} from "primereact/toast";



class EditPrivacy extends React.Component {
    constructor(props) {
        super(props);

        this.state = {

            vaccine_id : this.props.vaccine_id

        };


        this.componentDidMount = this.componentDidMount.bind(this);




        this.changePrivacySetting = this.changePrivacySetting.bind(this);
        this.showSuccess = this.showSuccess.bind(this);




    }




    async componentDidMount() {

        // await this.fetchData("");
    }

    async fetchData(vaccine_id){
        let url = BASE_URL+"/get/privacy/" + vaccine_id ;
        let data = await axios.get(url, {headers: BUILD_HEADER("","")});



        this.setState({answers : ""});
        this.setState({questions : ""});

    }










    printState(){
        console.log("State :", this.state);
    }


    async changePrivacySetting(){

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
        this.messages.show({ severity: 'success', summary: 'Editing is Success!', detail: ' Privacy data has changed' });
        // this.toast.show({severity: 'success', summary: 'Editing is Success', detail: 'Privacy data has changed'});

    }


    showError() {
        this.messages.show({ severity: 'error', summary: 'Need to authorize first!', detail: 'Validation failed' });
        // this.toast.show({ severity: 'error', summary: 'Need to authorize first!', detail: 'Validation failed' });
    }


    showGenericError(msg) {
        this.messages.show({ severity: 'error', summary: 'Error!', detail: msg });
        // this.toast.show({ severity: 'error', summary: 'Error!', detail: msg });
    }

    submissionOnChange(key,value){

        // let temp = this.state.answers;
        //
        // temp[key] = value;
        // this.setState({answers : temp});

    }

    render() {


        let header = <div>
            <Button label="Change privacy setting!" onClick={this.changePrivacySetting}  />
        </div>;


        return (

            <div>


                <Messages ref={(el) => this.messages = el}/>
                <Toast ref={(el) => this.toast = el} />

                <Panel style={{"margin" : "5px"}} header={header} maximizable modal >
                    {/*{mappingColumns}*/}
                </Panel>

            </div>
        );
    }
}

export default EditPrivacy;
