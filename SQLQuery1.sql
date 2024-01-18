SELECT *
FROM PortfolioProject.DBO.CovidDeaths
where continent is not null
ORDER BY 3,4
 
 --SELECT *
 --FROM PortfolioProject.DBO.CovidVaccinations
 --ORDER BY 3,4

--Select Data that we Are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

--Looking at Total Case vs Total Deaths
--show Likelihood of deaths if you contract covid in your country 

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2

--Looking at Total Case vs Total Deaths
--Shows that percentage of poplation got Covid

Select location, date, population,total_cases, (total_cases/population)*100 as Deathpercentage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2

--Looking at Countries with Highest Infection Rate compared population

Select location, population,MAX(total_cases) as HighestInfectionCount, MAX ((total_cases/population))*100 as percentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%sudan%'
Group by location, population
order by percentPopulationInfected desc

--Showing Counttries with Highest death count pre Population 

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not Null
Group by location
order by TotalDeathCount


--GLOBAL NUMBERS 


SELECT date, SUM(new_cases)as total_cases , SUM(cast(new_deaths as int ))as total_deaths, SUM(cast(new_deaths as int))/SUM (new_cases)*100 as Deathprecentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date 
order by 1,2

with popvsvac (Continent, Location, Date, Population, New_Vaccinations, RollingpeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.Date) as RollingPeopleVaccinated 
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
   where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100
from popvsvac

--TEMP TABLE
DROP Table if exists #PercentPoplationVaccinated
create Table #PercentPoplationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rollingpeoplevaccinated numeric
)

insert into #PercentPoplationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations))
OVER(partition by dea.location order by dea.location,dea.Date)asRollingpeoplevaccinated
From portfolioproject..CovidDeaths dea
join portfolioproject..Covidvaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 Select *, (RollingPeopleVaccinated/Population)*100
from #PercentPoplationVaccinated 

