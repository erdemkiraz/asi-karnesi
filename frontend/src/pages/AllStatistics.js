import React from "react";
import {TabPanel, TabView} from "primereact/tabview";
import Statistics from "./Statistics";
import RiskTable from "./StatisticPages/RiskTable";
import CityVaccinationTable from "./StatisticPages/CityVaccinationTable";
import VirusVaccineTable from "./StatisticPages/VirusVaccineTable";
import DailyVaccinationTable from "./StatisticPages/DailyVaccinationTable";


export class AllStatistics extends React.Component {
    constructor() {
        super();

        this.state = {};
    }

    async componentDidMount() {
    }

    render() {
        const baseStyle = {width: "100%"}
        return (
            <div style={baseStyle}>
                <div className="card" style={baseStyle}>
                    <TabView className="tabview-custom">

                        <TabPanel header="Risk Table"
                                  rightIcon="pi pi-chart-bar">
                            <RiskTable/>
                        </TabPanel>

                        <TabPanel
                            header="Country-Vaccine Statistics"
                            rightIcon="pi pi-chart-bar"
                        >
                            <CityVaccinationTable/>
                        </TabPanel>

                        <TabPanel
                            header="Virus-Vaccine Statistics"
                            rightIcon="pi pi-percentage"
                        >
                            <VirusVaccineTable/>
                        </TabPanel>
                        <TabPanel
                            header="Daily Vaccine Statistics"
                            rightIcon="pi pi-chart-bar"
                        >
                            <DailyVaccinationTable/>
                        </TabPanel>
                        <TabPanel
                            header="General Statistics"
                            rightIcon="pi pi-chart-line"
                        >
                            <Statistics/>
                        </TabPanel>

                    </TabView>
                </div>
            </div>
        );
    }
}

export default AllStatistics;
