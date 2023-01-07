CREATE TABLE coviddeaths (
	`_record_number` int AUTO_INCREMENT NOT NULL,
	`iso_code` varchar(8),
	`continent` varchar(13),
	`location` varchar(32),
	`date` datetime,
	`population` integer,
	`total_cases` integer,
	`new_cases` integer,
	`new_cases_smoothed` numeric(11,3),
	`total_deaths` integer,
	`new_deaths` integer,
	`new_deaths_smoothed` numeric(9,3),
	`total_cases_per_million` numeric(10,3),
	`new_cases_per_million` numeric(10,3),
	`new_cases_smoothed_per_million` numeric(9,3),
	`total_deaths_per_million` numeric(8,3),
	`new_deaths_per_million` numeric(7,3),
	`new_deaths_smoothed_per_million` numeric(7,3),
	`reproduction_rate` numeric(5,2),
	`icu_patients` integer,
	`icu_patients_per_million` numeric(7,3),
	`hosp_patients` integer,
	`hosp_patients_per_million` numeric(8,3),
	`weekly_icu_admissions` integer,
	`weekly_icu_admissions_per_million` numeric(7,3),
	`weekly_hosp_admissions` integer,
	`weekly_hosp_admissions_per_million` numeric(7,3),
	primary key(`_record_number`)
);

LOAD DATA INFILE 'CovidDeath.csv'
INTO TABLE coviddeaths
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES

