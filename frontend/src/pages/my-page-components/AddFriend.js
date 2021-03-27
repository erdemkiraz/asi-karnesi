import React from 'react';
import {InputText} from "primereact/inputtext";
import {Button} from "primereact/button";
import axios from "axios";
import {BASE_URL, BUILD_HEADER, getEmail} from "../../services/base_service";
import {get_storage} from "../../services/StorageUtil";


export class AddFriend extends React.Component {

    constructor() {
        super();

        this.state = {

            // login : new Login(),
            logged_in_email: null,
            new_friend_email: "",
            new_friend_tckn: "",

        };

        this.componentDidMount = this.componentDidMount.bind(this);


        this.addFriend = this.addFriend.bind(this);
        this.sendData = this.sendData.bind(this);
        this.reset_state = this.reset_state.bind(this);


    }


    async componentDidMount() {
        let google_user = await get_storage("google_user");
        let email = getEmail(google_user)

        this.setState({logged_in_email: email});
        console.log("Logged in email is : " , email);

    }

    async addFriend(e) {
        await this.sendData(e)
    }

    async sendData(e) {
        let data = await axios.post(BASE_URL + "/add", {"data": this.state}) // TODO : add user email to send
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

    reset_state() {
        this.setState({
            email: null,
            tckn: null
        })
    }


    render() {


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
                            <Button label="Add"/>
                        </div>
                        <div className="p-col-12 p-md-6">
                            Box2
                        </div>
                    </div>
                </div>
                This is Add friend page!!
            </div>
        );
    }
}

export default AddFriend;
