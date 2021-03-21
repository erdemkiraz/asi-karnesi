import React from 'react';
import axios from 'axios'

import {BASE_URL, HEADER, BUILD_HEADER, getEmail} from "../../services/base_service";

// import {clientId} from "../../services/base_service";
import {Button} from "primereact/button";
import {put_storage, get_storage} from "../../services/StorageUtil";
import {TreeTable} from "primereact/treetable";
import {Column} from "primereact/column";
import {DataTable} from "primereact/datatable";
import QRCode from "qrcode.react"
import {TabPanel} from "primereact/tabview";
import {Panel} from "primereact/panel";


// import '../App.css';

export class MyCodes extends React.Component {

    constructor() {
        super();

        this.state = {

            my_vaccines: [],
            selected_vaccines: [],
            qr_hidden: true,
            qr_value: "",
            panelCollapsed : false,

            // login : new Login(),

        };

        this.componentDidMount = this.componentDidMount.bind(this);
        this.generateQRCode = this.generateQRCode.bind(this);
        this.fetchData = this.fetchData.bind(this);

    }


    componentDidMount() {
        let google_user = get_storage("google_user");
        let email = getEmail(google_user)

        console.log(google_user)
        // let data = {
        //     "my_vaccines": [
        //         {
        //             "id": 0,
        //             "name": "COVID-19",
        //             "date": "15.02.2019",
        //             "dose": "1",
        //             "vaccine_point": "Ankara Merkez",
        //             "expires_in": "364"
        //         },
        //         {
        //             "id": 1,
        //             "name": "COVID-20",
        //             "date": "15.02.2020",
        //             "dose": "1",
        //             "vaccine_point": "Istranbul Merkez",
        //             "expires_in": "255"
        //         },
        //         {
        //             "id": 2,
        //             "name": "COVID-21",
        //             "date": "15.02.2021",
        //             "dose": "1",
        //             "vaccine_point": "Eskisehir Merkez",
        //             "expires_in": "321"
        //         },
        //         {
        //             "id": 3,
        //             "name": "COVID-22",
        //             "date": "15.02.2022",
        //             "dose": "1",
        //             "vaccine_point": "Adana Merkez",
        //             "expires_in": "0"
        //         },
        //     ]
        // };


        // let test_data = {
        //     "root": [
        //         {
        //             "key": "0",
        //             "data": {"name": "Applications", "size": "100kb", "type": "Folder"},
        //             "children": [{
        //                 "key": "0-0",
        //                 "data": {"name": "React", "size": "25kb", "type": "Folder"},
        //                 "children": [{
        //                     "key": "0-0-0",
        //                     "data": {"name": "react.app", "size": "10kb", "type": "Application"}
        //                 }, {
        //                     "key": "0-0-1",
        //                     "data": {"name": "native.app", "size": "10kb", "type": "Application"}
        //                 }, {"key": "0-0-2", "data": {"name": "mobile.app", "size": "5kb", "type": "Application"}}]
        //             }, {"key": "0-1", "data": {"name": "editor.app", "size": "25kb", "type": "Application"}}, {
        //                 "key": "0-2",
        //                 "data": {"name": "settings.app", "size": "50kb", "type": "Application"}
        //             }]
        //         },
        //         {
        //             "key": "1",
        //             "data": {"name": "Cloud", "size": "20kb", "type": "Folder"},
        //             "children": [{
        //                 "key": "1-0",
        //                 "data": {"name": "backup-1.zip", "size": "10kb", "type": "Zip"}
        //             }, {"key": "1-1", "data": {"name": "backup-2.zip", "size": "10kb", "type": "Zip"}}]
        //         },
        //         {
        //             "key": "2",
        //             "data": {"name": "Desktop", "size": "150kb", "type": "Folder"},
        //             "children": [{
        //                 "key": "2-0",
        //                 "data": {"name": "note-meeting.txt", "size": "50kb", "type": "Text"}
        //             }, {"key": "2-1", "data": {"name": "note-todo.txt", "size": "100kb", "type": "Text"}}]
        //         },
        //         {
        //             "key": "3",
        //             "data": {"name": "Documents", "size": "75kb", "type": "Folder"},
        //             "children": [{
        //                 "key": "3-0",
        //                 "data": {"name": "Work", "size": "55kb", "type": "Folder"},
        //                 "children": [{
        //                     "key": "3-0-0",
        //                     "data": {"name": "Expenses.doc", "size": "30kb", "type": "Document"}
        //                 }, {"key": "3-0-1", "data": {"name": "Resume.doc", "size": "25kb", "type": "Resume"}}]
        //             }, {
        //                 "key": "3-1",
        //                 "data": {"name": "Home", "size": "20kb", "type": "Folder"},
        //                 "children": [{"key": "3-1-0", "data": {"name": "Invoices", "size": "20kb", "type": "Text"}}]
        //             }]
        //         },
        //         {
        //             "key": "4",
        //             "data": {"name": "Downloads", "size": "25kb", "type": "Folder"},
        //             "children": [{
        //                 "key": "4-0",
        //                 "data": {"name": "Spanish", "size": "10kb", "type": "Folder"},
        //                 "children": [{
        //                     "key": "4-0-0",
        //                     "data": {"name": "tutorial-a1.txt", "size": "5kb", "type": "Text"}
        //                 }, {"key": "4-0-1", "data": {"name": "tutorial-a2.txt", "size": "5kb", "type": "Text"}}]
        //             }, {
        //                 "key": "4-1",
        //                 "data": {"name": "Travel", "size": "15kb", "type": "Text"},
        //                 "children": [{
        //                     "key": "4-1-0",
        //                     "data": {"name": "Hotel.pdf", "size": "10kb", "type": "PDF"}
        //                 }, {"key": "4-1-1", "data": {"name": "Flight.pdf", "size": "5kb", "type": "PDF"}}]
        //             }]
        //         },
        //         {
        //             "key": "5",
        //             "data": {"name": "Main", "size": "50kb", "type": "Folder"},
        //             "children": [{"key": "5-0", "data": {"name": "bin", "size": "50kb", "type": "Link"}}, {
        //                 "key": "5-1",
        //                 "data": {"name": "etc", "size": "100kb", "type": "Link"}
        //             }, {"key": "5-2", "data": {"name": "var", "size": "100kb", "type": "Link"}}]
        //         },
        //         {
        //             "key": "6",
        //             "data": {"name": "Other", "size": "5kb", "type": "Folder"},
        //             "children": [{"key": "6-0", "data": {"name": "todo.txt", "size": "3kb", "type": "Text"}}, {
        //                 "key": "6-1",
        //                 "data": {"name": "logo.png", "size": "2kb", "type": "Picture"}
        //             }]
        //         },
        //         {
        //             "key": "7",
        //             "data": {"name": "Pictures", "size": "150kb", "type": "Folder"},
        //             "children": [{
        //                 "key": "7-0",
        //                 "data": {"name": "barcelona.jpg", "size": "90kb", "type": "Picture"}
        //             }, {"key": "7-1", "data": {"name": "primeng.png", "size": "30kb", "type": "Picture"}}, {
        //                 "key": "7-2",
        //                 "data": {"name": "prime.jpg", "size": "30kb", "type": "Picture"}
        //             }]
        //         },
        //         {
        //             "key": "8",
        //             "data": {"name": "Videos", "size": "1500kb", "type": "Folder"},
        //             "children": [{
        //                 "key": "8-0",
        //                 "data": {"name": "primefaces.mkv", "size": "1000kb", "type": "Video"}
        //             }, {"key": "8-1", "data": {"name": "intro.avi", "size": "500kb", "type": "Video"}}]
        //         }
        //     ]
        // }


        // this.setState({my_vaccines: data["my_vaccines"]});

        // let friend = {  "name": "Ayberk", "surname" : "Uslu", "Age": 22, "withFriendsSince" : "15.02.2021", "vaccines" : [ "covid19", "asi1", "asi2", "asi3"]
        //              }

        this.fetchData(email).then(user_codes => this.setState({my_vaccines: user_codes}))


    }


   async fetchData(email){

        let data = await axios.get(BASE_URL+"/user/codes", {headers: BUILD_HEADER("API_TOKEN",email)})
        console.log("Data : ",data);
        let user_codes = data.data["my_vaccines"]
        console.log("User Friends ", user_codes)
        return user_codes;
    }


    formSubmissionsTemplate(data) {
        // let values = Object.values(data["vaccines"]);
        let values = data["vaccines"];
        // console.log(data["vaccines"])
        // console.log("Values : ", values)
        return (
            <div className="orders-subtable">
                {/*<h5>Submissions for {data.form_id}</h5>*/}
                <DataTable value={values}>
                    <Column field="vaccine" header="Vaccine" sortable/>
                    {/*<Column field="prettyFormat" header="Answer" sortable/>*/}
                </DataTable>
            </div>
        );
    }

    onRowExpand(event) {
        // this.toast.show({severity: 'info', summary: 'Product Expanded', detail: event.data.name, life: 3000});
    }

    onRowCollapse(event) {
        // this.toast.show({severity: 'success', summary: 'Product Collapsed', detail: event.data.name, life: 3000});
    }


    generateQRCode() {
        console.log("Generate QR Code !!!");
        this.setState({qr_hidden: false});
        let qr_new = this.state.qr_value + "/TEST";
        this.setState({qr_value: qr_new})

         this.setState({panelCollapsed: true})
    }


    render() {
        // let friends_header = <div className="p-clearfix" style={{'lineHeight': '1.87em'}}>
        //     Submissions for {(this.state.selectedFormDetail) ? this.state.selectedFormDetail : ""}
        // </div>;

        let vaccinesCount = this.state.my_vaccines ? this.state.my_vaccines.length : 0;
        let selectedVaccinesCount = this.state.selected_vaccines ? this.state.selected_vaccines.length : 0;

        let footer_my_vaccines =
            <div className="p-fluid p-formgrid p-grid">
                <div className="p-field p-col">
                    There are {selectedVaccinesCount} selected vaccine(s) out of {vaccinesCount} vaccine(s) <br/>
                    Select the vaccines then click the Generate button.
                </div>
                <div className="p-field p-col">
                    <Button label="Generate" onClick={this.generateQRCode}/>
                </div>
            </div>;

        return (<div>


                <div className="card">
                    {/*<h5>Checkbox</h5>*/}
                    <Panel header="My Vaccines" toggleable collapsed={this.state.panelCollapsed}
                           onToggle={(e) => this.setState({panelCollapsed: e.value})}
                           >
                        <DataTable value={this.state.my_vaccines}
                                   selection={this.state.selected_vaccines}
                                   onSelectionChange={e => this.setState({selected_vaccines: e.value})}
                                   dataKey="id"
                                   footer={footer_my_vaccines}>
                            <Column selectionMode="multiple" headerStyle={{width: '3em'}}></Column>
                            <Column field="id" header="Code"></Column>
                            <Column field="name" header="Name"></Column>
                            <Column field="date" header="Date"></Column>
                            <Column field="dose" header="Dose"></Column>
                            <Column field="vaccine_point" header="Vaccine Point"></Column>
                            <Column field="expires_in" header="Expires in"></Column>
                        </DataTable>

                    </Panel>

                </div>
                <div className="card" hidden={this.state.qr_hidden}>

                    <h2>QR-Code</h2>

                    <QRCode value={this.state.qr_value}/>

                </div>


                {/*<Button label="Test button"/>*/}

            </div>
        );
    }
}

export default MyCodes;
