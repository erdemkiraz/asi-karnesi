import React from "react";
import {Chart} from "primereact/chart";
import axios from "axios";
import {BASE_URL, BUILD_HEADER} from "../../services/base_service";

export class VirusVaccineTable extends React.Component {

    constructor() {
        super();

        this.state = {
            basicData: {},
            is_fetched: false,

        };

        this.lightOptions = {
            legend: {
                labels: {
                    fontColor: '#495057'
                }
            }
        };

    }

    async componentDidMount() {
        this.fetchData();
    }

    async fetchData() {

        console.log("Basic Data First : ", this.state.basicData)

        let response = await axios.get(
            BASE_URL + "/covid-vaccine-table",
            {headers: BUILD_HEADER()}
        );

        let response_data = response.data;

        let data_array = response_data["vaccine_table"]

        let labels = [];
        let datasets = [];
        let data_from_db = [];

        let current_basic_data = this.state.basicData;

        for (let i = 0; i < data_array.length; i++) {
            labels[i] = data_array[i]["name"]
            data_from_db[i] = data_array[i]["count"]

        }

        // labels = ["Covid-19 Biontech",
        //     "Covid-19 Moderna",
        //     "Covid-19 Pfizer",
        //     "Covid-19 CoronaVac",
        //     "Covid-19 SputnikV",
        // ]
        //
        // data_from_db = [8, 7, 5, 6, 2];

        datasets[0] = {
            label: 'Types of COVID-19 Vaccines',
            data: data_from_db,
            backgroundColor: this.getBackgroundColor(data_array.length),
            hoverBackgroundColor: this.getHoverBackgroundColor(data_array.length)
            // backgroundColor: this.getBackgroundColor(5),
            // hoverBackgroundColor: this.getHoverBackgroundColor(5)
        }

        current_basic_data["labels"] = labels
        current_basic_data["datasets"] = datasets

        this.setState({basicData: current_basic_data})
        this.setState({is_fetched: true})

    }

    getBackgroundColor(length) {
        let backgroundColor = [
            "#8E44AD",
            "#105D97",
            "#F09440",
            "#42A5F5",
            "#66bb6a",
            "#7F8C8D",
            "#FFA726"
        ]

        return backgroundColor.slice(0, length)
    }

    getHoverBackgroundColor(length) {
        let hoverBackgroundColor = [
            "#9B59B6",
            "#0591AF",
            "#F0B36A",
            "#64B5F6",
            "#81C784",
            "#BDC3C7",
            "#FFB74D"
        ]

        return hoverBackgroundColor.slice(0, length)
    }


    render() {

        return (
            <div style={{height: "700px"}}>
                {this.state.is_fetched &&
                <div className="card">
                    <h5>Types of COVID-19 Vaccines</h5>
                    <Chart type="pie" data={this.state.basicData} options={this.lightOptions}/>
                </div>
                }
            </div>
        );
    }

}

export default VirusVaccineTable;
