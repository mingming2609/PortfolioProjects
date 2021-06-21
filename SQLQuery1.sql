select *
from PortafolioProject..CovidDeath
order by 3, 4

select *
from PortafolioProject..CovidVac
order by 3, 4

select location, date, total_cases, new_cases, total_deaths, population
from PortafolioProject..CovidDeath
order by 1, 2

-- Total Cases vs Total Deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortafolioProject..CovidDeath
where location like '%states%'
order by 1, 2

-- Total Cases vs Population
select location, date, total_cases, population, (total_cases/population)*100 as casePercentage
from PortafolioProject..CovidDeath
where location like '%states%'
order by 1, 2

--Which country has the highest infection rate
select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from PortafolioProject..CovidDeath
where continent is not null
Group by Location, population
order by PercentPopulationInfected desc

--Total cases by date
select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
from PortafolioProject..CovidDeath
where continent is not null
Group by date
order by 1,2


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortafolioProject..CovidDeath dea
join PortafolioProject..CovidVac vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3

-- Total population vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (Partition by dea.Location Order by dea.location, dea.DATE) as Rvaccinated 
from PortafolioProject..CovidDeath dea
join PortafolioProject..CovidVac vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3

-- Creating view to store data for later visualizations
create view #populationvsvaccinations
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric, 
RollingPeopleVaccinated numeric )

Insert into #populationvsvaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (Partition by dea.Location Order by dea.location, dea.DATE) as Rvaccinated 
from PortafolioProject..CovidDeath dea
join PortafolioProject..CovidVac vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3

