import React from 'react';
import axios from 'axios'

import {BASE_URL, BUILD_HEADER, getGoogleId} from "../../services/base_service";

import {Button} from "primereact/button";
import {get_storage} from "../../services/StorageUtil";
import {Column} from "primereact/column";
import {DataTable} from "primereact/datatable";
import QRCode from "qrcode.react"
import {Panel} from "primereact/panel";
import {Dialog} from "primereact/dialog";
import EditPrivacy from "./EditPrivacy";


export class MyCodes extends React.Component {

    constructor() {
        super();

        this.state = {


            logged_in_google_id : "",
            my_vaccines: [],
            selected_vaccines: [],
            qr_hidden: true,
            qr_value: "",
            panelCollapsed: false,
            displayEditPrivacy: false,
            vaccine_id_to_be_changed: null,


            // login : new Login(),

        };

        this.componentDidMount = this.componentDidMount.bind(this);
        this.generateQRCode = this.generateQRCode.bind(this);
        this.fetchData = this.fetchData.bind(this);


        this.onHide = this.onHide.bind(this);


        this.editButton = this.editButton.bind(this);
        this.editPrivacy = this.editPrivacy.bind(this);

    }


    componentDidMount() {
        let google_user = get_storage("google_user");

        // con


        let google_id = getGoogleId(google_user)

        this.setState({logged_in_google_id : google_id})
        console.log("google_user id : ", google_id)
        console.log(google_user)

        this.fetchData(google_id).then(user_codes => this.setState({my_vaccines: user_codes}))
    }


    async fetchData(google_id) {

        let data = await axios.get(BASE_URL + "/user/codes?google_id=" + google_id, {headers: BUILD_HEADER()})
        console.log("Data : ", data);
        let user_codes = data.data["my_vaccines"]
        console.log("User Friends ", user_codes)
        return user_codes;
    }

    onHide(name) {
        this.setState({
            [`${name}`]: false
        });
    }

    async editPrivacy(row) {

        await this.setState({vaccine_id_to_be_changed: row["vaccination_id"] ?? "error"});
        //
        await this.setState({displayEditPrivacy: true});
    }

    editButton(row) {
        return (
            <div>
                <Button type="button" onClick={() => this.editPrivacy(row)} label="Privacy" icon="pi pi-users"
                        className="p-button-secondary"/>
            </div>);
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


    async generateQRCode() {

        let vaccines = [];
        for(let i = 0; i < this.state.selected_vaccines.length ; i++){
            vaccines.push(this.state.selected_vaccines[i]["vaccination_id"]);
        }
        // let vaccines = this.state.selected_vaccines
        let payload = {
            "google_id": this.state.logged_in_google_id,
            "vaccination_ids": vaccines,
        }

        console.log("Payload : ", payload)
        let url = BASE_URL + "/create-link";
        const options = {
            method: 'POST',
            headers: BUILD_HEADER(),
            data: payload,
            url,
        };

        let response = await axios(options);

        // console.log("Generated QR Code !!!");
        this.setState({qr_hidden: false});
        let qr_new = response.data["link"]
        // console.log("QR : ", qr_new);
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

                <Dialog header="Edit Privacy Settings" visible={this.state.displayEditPrivacy} style={{width: '50vw'}}
                        onHide={() => this.onHide('displayEditPrivacy')}>

                    <EditPrivacy
                        vaccination_id={this.state.vaccine_id_to_be_changed}
                    />
                </Dialog>

                <div className="card">
                    {/*<h5>Checkbox</h5>*/}
                    <Panel header="My Vaccines" toggleable collapsed={this.state.panelCollapsed}
                           onToggle={(e) => this.setState({panelCollapsed: e.value})}
                    >
                        <DataTable value={this.state.my_vaccines}
                                   selection={this.state.selected_vaccines}
                                   onSelectionChange={e => this.setState({selected_vaccines: e.value})}
                                   dataKey="vaccination_id"
                                   footer={footer_my_vaccines}>
                            <Column selectionMode="multiple" headerStyle={{width: '3em'}}></Column>
                            {/*<Column field="vaccination_id" header="Code"  ></Column>*/}
                            {/*<Column field="vaccine_id" header="Vaccine ID" sortable filter*/}
                            {/*        filterPlaceholder="Search by vaccine ID" filterMatchMode="contains"/>*/}
                            <Column field="name" header="Vaccine Name" sortable filter
                                    filterPlaceholder="Search by name" filterMatchMode="contains"/>
                            <Column field="dose" header="Vaccine Dose" sortable filter filterPlaceholder="Search by dose"
                                    filterMatchMode="contains"/>
                            <Column field="vaccine_point" header="Vaccine Point" sortable filter
                                    filterPlaceholder="Search by location" filterMatchMode="contains"/>
                            <Column field="date" header="Vaccine Date" sortable filter
                                    filterPlaceholder="Search by date" filterMatchMode="contains"/>
                            <Column field="valid_until" header="Validation Time" sortable filter filterPlaceholder="Search by expire date"
                                    filterMatchMode="contains"/>
                            <Column body={this.editButton} headerStyle={{width: '8em', textAlign: 'center'}}
                                    bodyStyle={{textAlign: 'center', overflow: 'visible'}}/>

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
