import React from "react";
import {TabPanel, TabView} from "primereact/tabview";
import Statistics from "./Statistics";



export class AllStatistics extends React.Component {
    constructor() {
        super();

        this.state = {
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
                        <TabPanel header="My Friends" leftIcon="pi pi-user">
                        </TabPanel>
                        <TabPanel
                            header="My Vaccines"
                            leftIcon="pi pi-table"
                            rightIcon="pi pi-user"
                        >
                            <Statistics/>
                        </TabPanel>
                        <TabPanel
                            header="Add New Friend"
                            leftIcon="pi pi-users"
                            rightIcon="pi pi-user-plus"
                        >
                        </TabPanel>

                        <TabPanel
                            header="oogle Friends"
                            leftIcon="pi pi-google"
                        >
                        </TabPanel>

                    </TabView>
                </div>
            </div>
        );
    }
}

export default AllStatistics;
