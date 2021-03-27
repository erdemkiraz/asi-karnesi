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
import {Dialog} from "primereact/dialog";
import EditPrivacy from "./EditPrivacy";


export class MyCodes extends React.Component {

    constructor() {
        super();

        this.state = {

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
        let email = getEmail(google_user)

        console.log(google_user)

        this.fetchData(email).then(user_codes => this.setState({my_vaccines: user_codes}))
    }


    async fetchData(email) {

        let data = await axios.get(BASE_URL + "/user/codes", {headers: BUILD_HEADER("API_TOKEN", email)})
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

        await this.setState({vaccine_id_to_be_changed: row["id"] ?? "error"});
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
        let values = data["vaccines"];

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
                        vaccine_id={this.state.vaccine_id_to_be_changed}
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
                                   dataKey="id"
                                   footer={footer_my_vaccines}>
                            <Column selectionMode="multiple" headerStyle={{width: '3em'}}></Column>
                            <Column field="id" header="Code"></Column>
                            <Column field="name" header="Name"></Column>
                            <Column field="date" header="Date"></Column>
                            <Column field="dose" header="Dose"></Column>
                            <Column field="vaccine_point" header="Vaccine Point"></Column>
                            <Column field="expires_in" header="Expires in"></Column>
                            <Column body={this.editButton} headerStyle={{width: '8em', textAlign: 'center'}}
                                    bodyStyle={{textAlign: 'center', overflow: 'visible'}}/>

                        </DataTable>

                    </Panel>

                </div>
                <div className="card" hidden={this.state.qr_hidden}>

                    <h2>QR-Code</h2>

                    <QRCode value={this.state.qr_value}/>

                </div>
                
            </div>
        );
    }
}

export default MyCodes;
