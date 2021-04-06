import React from 'react';
// import '../App.css';

export class Error401 extends React.Component {

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
                {/*<Login />*/}
                <h1>401 Unauthorized</h1>
            </div>
        );
    }
}
export default Error401;
