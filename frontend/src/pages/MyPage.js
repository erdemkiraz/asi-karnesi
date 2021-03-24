import React from 'react';
import {TabPanel, TabView} from "primereact/tabview";
import MyFriends from "./my-page-components/MyFriends";
import MyCodes from "./my-page-components/MyCodes";

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


        return (<div>

                <div className="card">
                    <TabView className="tabview-custom">
                        <TabPanel header="My Friends" leftIcon="pi pi-user">

                            <MyFriends/>

                        </TabPanel>
                        <TabPanel header="My Vaccines" rightIcon="pi pi-user">
                            <p>Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque
                                laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi
                                architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas
                                sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione
                                voluptatem sequi nesciunt. Consectetur, adipisci velit, sed quia non numquam eius
                                modi.</p>
                        </TabPanel>
                        <TabPanel header="My Vaccines" leftIcon="pi pi-table" rightIcon="pi pi-user">
                            <MyCodes/>
                        </TabPanel>
                    </TabView>
                </div>

            </div>
        );
    }
}

export default MyPage;
