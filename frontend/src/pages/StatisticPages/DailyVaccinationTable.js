import React from "react";

import {Chart} from "primereact/chart";
import axios from "axios";
import {BASE_URL, BUILD_HEADER} from "../../services/base_service";

export class DailyVaccinationTable extends React.Component {
    constructor() {
        super();

        this.state = {
            basicData: {},
            is_fetched: false,
            date : Date.now(),

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
        await this.fetchData();
    }

    async fetchData() {
        let response = await axios.get(
            BASE_URL + "/daily-vaccination-table",
            {headers: BUILD_HEADER()}
        );

        let response_data = response.data;

        let data_array = response_data["daily_vaccinations"]

        let labels = [];
        let datasets = [];
        let vaccination_numbers = [];
        let covid_numbers = [];
        let weekly_covid_numbers = [];

        let current_basic_data = this.state.basicData;

        for (let i = 0; i < data_array.length; i++) {
            labels[i] = data_array[i]["day"]
            vaccination_numbers[i] = data_array[i]["vaccination_count"] * 10
            covid_numbers[i] = data_array[i]["covid_statistics"]["covid_count"];
            weekly_covid_numbers[i] = data_array[i]["covid_statistics"]["weekly_avarage_count"];
        }

        datasets[0] = {
            type: 'line',
            label: 'COVID-19 Numbers',
            data: covid_numbers,
            fill: false,
            borderColor: '#323232',
            borderWidth: 2,
        }
        datasets[1] = {
            type: 'line',
            label: 'Weekly COVID-19 Numbers',
            data: weekly_covid_numbers,
            fill: false,
            borderColor: '#2196F3',
            borderWidth: 2,
        }
        datasets[2] = {
            type: 'bar',
            label: 'Vaccinated Population',
            data: vaccination_numbers,
            fill: true,
            backgroundColor: '#689F38',
        }

        current_basic_data["labels"] = labels
        current_basic_data["datasets"] = datasets

        this.setState({basicData: current_basic_data})
        this.setState({is_fetched: true})
        this.setState({date : Date.now})
    }


    render() {

        return (
            <div style={{height: "700px"}}>
                {
                    this.state.is_fetched &&
                    <div className="card">
                        <h5>Daily Vaccination Statistics</h5>
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


export default DailyVaccinationTable;
