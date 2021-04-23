import React from "react";
import {Chart} from "primereact/chart";
import axios from "axios";
import {BASE_URL, BUILD_HEADER} from "../../services/base_service";

export class RiskTable extends React.Component {
    constructor() {
        super();

        this.state = {
            basicData: {

            },
            is_fetched : false,

        };


        this.basicOptions = {
            legend: {
                labels: {
                    fontColor: '#495057'
                }
            },
            scales: {
                xAxes: [{
                    ticks: {
                        fontColor: '#495057'
                    }
                }],
                yAxes: [{
                    ticks: {
                        fontColor: '#495057'
                    }
                }]
            }
        };


    }

    async componentDidMount() {
        this.fetchData();
    }

    async fetchData() {

        console.log("Basic Data First : ", this.state.basicData)

        let response = await axios.get(
            BASE_URL + "/city-risk-table",
            {headers: BUILD_HEADER()}
        );

        let response_data = response.data;

        let data_array = response_data["city_table"]

        let labels = [];
        let datasets = [];
        let data_from_db = [];

        let current_basic_data = this.state.basicData;

        for (let i = 0; i < data_array.length; i++) {
            labels[i] = data_array[i]["name"]
            data_from_db[i] = data_array[i]["count"]*100

        }
        datasets[0] = {
            label: 'Risk Percentage %',
            backgroundColor: '#B00020',
            // backgroundColor: '#42A5F5',
            data: data_from_db
        }

        current_basic_data["labels"] = labels
        current_basic_data["datasets"] = datasets
        // console.log("-------------After > ")

        this.setState({basicData: current_basic_data})
        this.setState({is_fetched : true})



    }

    forceRender() {
        let i = this.state.force_render;
        this.setState({force_render: i + 1})
    }

    render() {

        return (
            <div style={{height: "700px" }}>
                {   this.state.is_fetched &&
                    <div className="card"  >
                        <h5>Risk Table</h5>
                        <Chart type="bar" data={this.state.basicData} options={this.basicOptions} style={{height : "900px !important", width:"2340px !important", display : "block !important"}} />
                    </div>

                }
            </div>
        );
    }


}

export default RiskTable;
