import React from 'react';
// import GoogleLogin from "react-google-login";
import {BASE_URL, BUILD_HEADER, getGoogleId} from "../../services/base_service";
import {Button} from "primereact/button";
import {put_storage, get_storage} from "../../services/StorageUtil";
import {TreeTable} from "primereact/treetable";
import {Column} from "primereact/column";
import {DataTable} from "primereact/datatable";
import axios from "axios";


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
        this.fetchData = this.fetchData.bind(this);

    }


     async componentDidMount() {
    let google_user = await get_storage("google_user");

    let google_id = getGoogleId(google_user)

    console.log(google_user)

    this.fetchData(google_id).then(user_friends => this.setState({friends: user_friends}))


    }


   async fetchData(google_id){

        let data = await axios.get(BASE_URL+"/user/friends?google_id="+google_id, {headers: BUILD_HEADER()})
        console.log("Data : ",data);
        console.log("UserId :",google_id )
        let user_friends = data.data["friends"]
        console.log("User Friends ", user_friends)
        return user_friends;
    }



        formSubmissionsTemplate(data) {
        // let values = Object.values(data["vaccines"]);
        let values = data["vaccines"]
        // console.log(data["vaccines"])
                // console.log("Values : ", values)

        return (
            <div className="orders-subtable">
                {/*<h5>Submissions for {data.form_id}</h5>*/}
                <DataTable value={values}>
                    <Column field="vaccine_id" header="Vaccine ID" sortable filter filterPlaceholder="Search by vaccine ID" filterMatchMode="contains"/>
                    <Column field="name" header="Vaccine Name" sortable filter filterPlaceholder="Search by name" filterMatchMode="contains"/>
                    <Column field="dose" header="Vaccine Dose" sortable filter filterPlaceholder="" filterMatchMode="contains"/>
                    <Column field="vaccine_point" header="Vaccine Point" sortable filter filterPlaceholder="Search by location" filterMatchMode="contains"/>
                    <Column field="date" header="Vaccine Date" sortable filter filterPlaceholder="Search by date" filterMatchMode="contains"/>
                    <Column field="valid_until" header="Validation Time" sortable filter filterPlaceholder="" filterMatchMode="contains"/>
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
                    selectionMode="single"
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
                    {/*<Column field="id" header="ID" ></Column>*/}
                    <Column field="name" header="Name" filter filterPlaceholder="Search by name" filterMatchMode="contains"></Column>
                    <Column field="age" header="Age" filter filterPlaceholder="Age" filterMatchMode="contains"></Column>
                    <Column field="country_name" header="Country" filter filterPlaceholder="Search by country name" filterMatchMode="contains"></Column>
                    {/*<Column field="surname" header="Surname" filter filterPlaceholder="Search by surname" filterMatchMode="contains"></Column>*/}
                    <Column field="with_friends_since" header="Friends with Since" ></Column>
                    {/*<Column field="type" header="Type"></Column>*/}
                </DataTable>
            {/*</div>*/}



            </div>
        );
    }
}

export default MyFriends;
