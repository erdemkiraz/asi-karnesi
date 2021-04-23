import React from "react";

import {Chart} from "primereact/chart";
import axios from "axios";
import {BASE_URL, BUILD_HEADER} from "../../services/base_service";

export class CityVaccinationTable extends React.Component {
    constructor() {
        super();

        this.state = {
            basicData: {},
            is_fetched: false,

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
            BASE_URL + "/city-vaccination-table",
            {headers: BUILD_HEADER()}
        );

        let response_data = response.data;

        let data_array = response_data["city_table"]

        let labels = [];
        let datasets = [];
        let vaccination_numbers = [];
        let populations = [];

        let current_basic_data = this.state.basicData;

        for (let i = 0; i < data_array.length; i++) {
            labels[i] = data_array[i]["name"]
            vaccination_numbers[i] = data_array[i]["count"]
            populations[i] = data_array[i]["population"]

        }
        datasets[0] = {
            label: 'Vaccinated Population',
            backgroundColor: '#689F38',
            // backgroundColor: '#42A5F5',
            data: vaccination_numbers
        }

        datasets[1] = {
            label: 'Populations',
            backgroundColor: '#01579B',
            // backgroundColor: '#42A5F5',
            data: populations
        }

        current_basic_data["labels"] = labels
        current_basic_data["datasets"] = datasets
        // console.log("-------------After > ")

        this.setState({basicData: current_basic_data})
        this.setState({is_fetched: true})


    }

    forceRender() {
        let i = this.state.force_render;
        this.setState({force_render: i + 1})
    }

    render() {

        return (
            <div style={{height: "700px"}}>
                {this.state.is_fetched &&
                <div className="card">
                    <h5>Population-Vaccinated Table</h5>
                    <Chart type="bar" data={this.state.basicData} options={this.basicOptions} style={{
                        height: "900px !important",
                        width: "2340px !important",
                        display: "block !important"
                    }}/>
                </div>

                }
            </div>
        );
    }


}


export default CityVaccinationTable;
