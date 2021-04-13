import React from "react";
import {TabPanel, TabView} from "primereact/tabview";
import MyFriends from "./my-page-components/MyFriends";
import MyCodes from "./my-page-components/MyCodes";
import AddFriend from "./my-page-components/AddFriend";
import UpdateMyInfo from "./my-page-components/UpdateMyInfo";

// import '../App.css';

export class MyPage extends React.Component {
    constructor() {
        super();

        this.state = {
            // login : new Login(),
        };
    }

    async componentDidMount() {
    }

    render() {
        const baseStyle = {width: "100%"}
        return (
            <div style={baseStyle}>
                <div className="card" style={baseStyle}>
                    <TabView className="tabview-custom">
                        <TabPanel header="Update My Information" leftIcon="pi pi-user">
                            <UpdateMyInfo/>
                        </TabPanel>

                        <TabPanel header="My Friends" leftIcon="pi pi-user">
                            <MyFriends/>
                        </TabPanel>
                        <TabPanel
                            header="My Vaccines"
                            leftIcon="pi pi-table"
                            rightIcon="pi pi-user"
                        >
                            <MyCodes/>
                        </TabPanel>
                        <TabPanel
                            header="Add New Friend"
                            leftIcon="pi pi-users"
                            rightIcon="pi pi-user-plus"
                        >
                            <AddFriend/>
                        </TabPanel>
                    </TabView>
                </div>
            </div>
        );
    }
}

export default MyPage;
