import React from "react";
import { Line } from "react-chartjs-2";


export default function Chart(props) {
    const { vaccineData } = props;
    // if (vaccines.length <= 1) {
    //     return <p>Loading</p>
    // }
    return (
			<Line
				data={{
					labels: vaccineData.map((vaccine) => vaccine.month),
					datasets: [
						{
							data: vaccineData.map((vaccine) => vaccine.total),
							label: "Vaccines",
							fill: true,
							borderColor: "#673AB7",
							backgroundColor: "#c8c1d4",
						},
					],
				}}
			/>
		);
}
