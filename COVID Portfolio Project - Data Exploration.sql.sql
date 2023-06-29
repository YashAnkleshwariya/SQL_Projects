--Select Data that we are going to using

Select Location, date, total_cases, new_cases, total_deaths, population
FROM PoartfolioProject1..CovidDeath
order by 1,2

--Looking at the Total Cases Vs Total Deaths

Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM PoartfolioProject1..CovidDeath
where location like '%state%'
order by 1,2

--Looking at Total Cases Vs Population
--Shows what % of people got covid

Select Location, date, population,total_cases,(total_cases/population)*100 as PercentPopulationInfected
FROM PoartfolioProject1..CovidDeath
--where location like '%state%'
order by 1,2

--Looking at Countries with Highest Infection Rate compared to Population.
SELECT Location, population, MAX(total_cases) as HighestInfectionCount,MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PoartfolioProject1..CovidDeath
Group by [location],population
order by PercentPopulationInfected desc

--Showing Countries with Highest Death Count Per Population

SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PoartfolioProject1..CovidDeath
WHERE continent is not NULL
Group by [location]
order by TotalDeathCount desc

--Let's Break things down by continent
--Showing continents with the Highest death count per population
SELECT [continent], MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PoartfolioProject1..CovidDeath
WHERE continent is not NULL
Group by [continent]
order by TotalDeathCount desc

-- Looking at Total Population VS Vaccination
select dea.continent , dea.location,dea.[date], dea.population , vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location order by dea.Location, dea.DATE) as RollingPeopleVaccinated
FROM PoartfolioProject1..CovidDeath dea
JOIN PoartfolioProject1..CovidVaccination vac
    on dea.location = vac.[location]
    and dea.[date] = vac.[date]
Where dea.continent is not NULL
order by 2,3

--USE CTE
with PopvsVac (continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as (
select dea.continent , dea.location,dea.[date], dea.population , vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location order by dea.Location, dea.DATE) as RollingPeopleVaccinated
FROM PoartfolioProject1..CovidDeath dea
JOIN PoartfolioProject1..CovidVaccination vac
    on dea.location = vac.[location]
    and dea.[date] = vac.[date]
Where dea.continent is not NULL
--order by 2,3
)
Select * , (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
from PopvsVac

--Creating View to store data for later Viz
CREATE VIEW PercentPeopleVaccinated AS
select dea.continent , dea.location,dea.[date], dea.population , vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location order by dea.Location, dea.DATE) as RollingPeopleVaccinated
FROM PoartfolioProject1..CovidDeath dea
JOIN PoartfolioProject1..CovidVaccination vac
    on dea.location = vac.[location]
    and dea.[date] = vac.[date]
Where dea.continent is not NULL
--order by 2,3
