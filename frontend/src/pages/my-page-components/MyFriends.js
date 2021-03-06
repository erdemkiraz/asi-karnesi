import React from 'react';
// import GoogleLogin from "react-google-login";
// import {clientId} from "../../services/base_service";
import {Button} from "primereact/button";
import {put_storage, get_storage} from "../../services/StorageUtil";
import {TreeTable} from "primereact/treetable";
import {Column} from "primereact/column";
import {DataTable} from "primereact/datatable";


// import '../App.css';

export class MyFriends extends React.Component {

    constructor() {
        super();

        this.state = {

            friends : [],
            selected_friends : [],
            expanded_friends_row: null,

            // login : new Login(),

        };

        this.componentDidMount = this.componentDidMount.bind(this);

    }


     componentDidMount() {
    let google_user = get_storage("google_user");

    console.log(google_user)
        let data = {
            // "name" : "Ayberk Uslu",
            // "my_infos" : "asda",
                "friends":[
                    {  "id" : 0,"name": "Ayberk", "surname" : "Uslu", "Age": 22, "withFriendsSince" : "15.02.2021", "vaccines" : [{"vaccine": "covid19"}, {"vaccine": "asi1"}, {"vaccine": "asi2"}, {"vaccine": "asi3"}]} ,
                    {  "id" : 1, "name": "Ayberk2", "surname" : "Uslu2", "Age": 22, "withFriendsSince" :"15.02.2021", "vaccines" : [{"vaccine": "covid19"}, {"vaccine": "asi1"}, {"vaccine": "asi2"}, {"vaccine": "asi3"}]} ,
                    {  "id" : 2, "name": "Ayberk3", "surname" : "Uslu3", "Age": 22, "withFriendsSince" :"15.02.2021", "vaccines" : [{"vaccine": "covid19"}, {"vaccine": "asi1"}, {"vaccine": "asi2"}, {"vaccine": "asi3"}]} ,
                    {  "id" : 3, "name": "Ayberk4", "surname" : "Uslu4", "Age": 22, "withFriendsSince" :"15.02.2021", "vaccines" : [{"vaccine": "covid19"}, {"vaccine": "asi1"}, {"vaccine": "asi2"}, {"vaccine": "asi3"}]} ,
                    {  "id" : 3, "name": "Ayberk5", "surname" : "Uslu5", "Age": 22, "withFriendsSince" :"15.02.2021", "vaccines" : [{"vaccine": "covid19"}, {"vaccine": "asi1"}, {"vaccine": "asi2"}, {"vaccine": "asi3"}]} ,
                    {  "id" : 3, "name": "Ayberk6", "surname" : "Uslu6", "Age": 22, "withFriendsSince" :"15.02.2021", "vaccines" : [{"vaccine": "covid19"}, {"vaccine": "asi1"}, {"vaccine": "asi2"}, {"vaccine": "asi3"}]} ,
                    {  "id" : 3, "name": "Ayberk7", "surname" : "Uslu7", "Age": 22, "withFriendsSince" :"15.02.2021", "vaccines" : [{"vaccine": "covid19"}, {"vaccine": "asi1"}, {"vaccine": "asi2"}, {"vaccine": "asi3"}]} ,
                ]
        };




    this.setState({friends : data["friends"]});

    // let friend = {  "name": "Ayberk", "surname" : "Uslu", "Age": 22, "withFriendsSince" : "15.02.2021", "vaccines" : [ "covid19", "asi1", "asi2", "asi3"]
    //              }

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




    render() {
        return (<div>



               My Friends
            {/*<div className="card">*/}
                {/*<h5>Multiple with MetaKey</h5>*/}
                <DataTable
                    value={this.state.friends}
                    selectionMode="multiple"
                    // selectionKeys={this.state.selected_friends}
                    selection={this.state.selected_friends}
                    onSelectionChange={e => this.setState({selected_friends : e.value})}
                    metaKeySelection={false}
                    // metaKeySelection
                    paginator={true}
                    // paginatorLeft={paginatorLeft}
                    // header={submissionsHeader}
                    paginatorTemplate="FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink CurrentPageReport RowsPerPageDropdown"
                    currentPageReportTemplate="Showing {first} to {last} of {totalRecords} friends"
                    rows={10}
                    rowsPerPageOptions={[5, 10, 20]} style={{margin: "10px"}}
                    dataKey="id"
                    rowExpansionTemplate={this.formSubmissionsTemplate}
                    expandedRows={this.state.expanded_friends_row}
                    onRowToggle={(e) => this.setState({expanded_friends_row: e.data})}
                    onRowExpand={this.onRowExpand} onRowCollapse={this.onRowCollapse}
                    emptyMessage="There is no friends yet!"
                >
                    <Column  expander></Column>
                    <Column field="id" header="ID" ></Column>
                    <Column field="name" header="Name" filter filterPlaceholder="Search by name" filterMatchMode="contains"></Column>
                    <Column field="surname" header="Size"></Column>
                    {/*<Column field="type" header="Type"></Column>*/}
                </DataTable>
            {/*</div>*/}



            </div>
        );
    }
}

export default MyFriends;
