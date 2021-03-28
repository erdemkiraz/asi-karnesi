import React from 'react';
// import GoogleLogin from "react-google-login";
import {BASE_URL, BUILD_HEADER, getEmail} from "../../services/base_service";
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
    let email = getEmail(google_user)

    console.log(google_user)

    this.fetchData(email).then(user_friends => this.setState({friends: user_friends}))


    }


   async fetchData(email){

        let data = await axios.get(BASE_URL+"/user/friends", {headers: BUILD_HEADER("API_TOKEN",email)})
        console.log("Data : ",data);
        console.log("email :",email )
        let user_friends = data.data["friends"]
        console.log("User Friends ", user_friends)
        return user_friends;
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
                    <Column field="surname" header="Surname" filter filterPlaceholder="Search by surname" filterMatchMode="contains"></Column>
                    {/*<Column field="type" header="Type"></Column>*/}
                </DataTable>
            {/*</div>*/}



            </div>
        );
    }
}

export default MyFriends;
