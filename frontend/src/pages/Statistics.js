import React, { useEffect, useState } from "react";
import axios from "axios";
import Chart from "../components/Chart";
import Styles from "../css/statistics.module.css";
import { Dropdown } from "primereact/dropdown";
import { InputNumber } from "primereact/inputnumber";
import {BASE_URL} from "../services/base_service";



const url = BASE_URL+"/get-vaccine-statistics";
const countriesUrl = BASE_URL+"/get-countries";
const vaccinesUrl = BASE_URL+"/get-vaccines";

const defaultChoice = { label: "All", value: "" };

const Statistics = () => {
	const [vaccineData, setVaccineData] = useState([]);
	const [vaccineId, setVaccineId] = useState("");
	const [countryId, setCountryId] = useState("");
	const [ageTo, setAgeTo] = useState();
	const [ageFrom, setAgeFrom] = useState();
	const [countries, setCountries] = useState([defaultChoice]);
	const [isLoading, setIsLoading] = useState(true);
	const [vaccines, setVaccines] = useState([defaultChoice]);

	useEffect(() => {
		async function getCountries() {
			const { status, data } = await axios.get(countriesUrl);
			if (status === 200) {
				let fetchedCountries = [{ label: "All", value: "" }]
				let arrayLength = data["countries"].length;
				for (let i = 0; i < arrayLength; i++) {
					fetchedCountries.push({
						label: data["countries"][i]["name"].toString(),
						value: data["countries"][i]["id"].toString()
					})
				}
				setCountries(fetchedCountries);
			}
		}
		async function getVaccines() {
			const { status, data } = await axios.get(vaccinesUrl);
			if (status === 200) {
				console.log(data)
				let fetchedVaccines = [{ label: "All", value: "" }]
				let arrayLength = data["vaccines"].length;
				for (let i = 0; i < arrayLength; i++) {
					console.log(data["vaccines"][i]);
					fetchedVaccines.push({
						label: data["vaccines"][i]["name"].toString(),
						value: data["vaccines"][i]["id"].toString()
					})
				}
				setVaccines(fetchedVaccines);
			}
		}
        getCountries();
        getVaccines();
	}, []);

	useEffect(() => {
		const params = {};
		if (vaccineId) {
			params.vaccine_id = vaccineId;
		}
		if (countryId) {
			params.country_id = countryId;
		}
		if (ageTo) {
			params.age_to = ageTo;
		}

		if (ageFrom) {
			params.age_from = ageFrom;
		}

		async function getData() {
			const { data } = await axios.get(url, { params });
			setVaccineData(data.vaccines);
		}
		getData();
	}, [vaccineId, countryId, ageTo, ageFrom]);
	return (
		<div className={Styles.container}>
			<div className={Styles.inputs}>
				<div className={Styles.formGroup}>
					<label className={Styles.label}>Country</label>
                    <Dropdown
                        className={Styles.dropdown}
						value={countryId}
						options={countries}
						onChange={(e) => setCountryId(e.value)}
					/>
				</div>
				<div className={Styles.formGroup}>
					<label className={Styles.label}>Vaccine</label>
                    <Dropdown
                        className={Styles.dropdown}
						value={vaccineId}
						options={vaccines}
						onChange={(e) => setVaccineId(e.value)}
					/>
				</div>
			</div>
			<div className={Styles.inputs}>
				<div className={Styles.formGroup}>
					<label className={Styles.label}>Age From</label>
					<InputNumber
                        className={Styles.input}
						value={ageFrom}
						placeholder="Age From"
						onChange={(e) => setAgeFrom(e.value)}
					/>
				</div>
				<div className={Styles.formGroup}>
					<label className={Styles.label}>Age To</label>
					<InputNumber
                        className={Styles.input}
						value={ageTo}
						placeholder="Age To"
						onChange={(e) => setAgeTo(e.value)}
					/>
				</div>
			</div>
			<div className="stats" style={{ width: "70%" }}>
				<Chart vaccineData={vaccineData} />
			</div>
		</div>
	);
};

export default Statistics;
