USE [Portfolio Project2];

-- Showing Countries with highest infection rate per population

Select Location, Population, Max(Total_Cases) as HighestInfectionCount, Max((total_cases/Population))*100 as PercentagePopulationInfected
From CovidDeaths
Group By Location, Population
Order By PercentagePopulationInfected desc

-- Showing Countries with total death count per population

Select Location, Population, MAX(cast(Total_Deaths as int)) as totaldeathCount, Max(cast(Total_Deaths as int)/Population)/100 as DeathsperPopulation
From CovidDeaths

-- Excluding the locations which signifies continents
Where continent is not null 
Group By Location, Population
Order By totaldeathCount desc

-- Total Deaths by continent
Select location, MAX(cast(total_deaths as int)) as Total_Deaths
From CovidDeaths
Where continent is null 
Group By location
Order By total_deaths desc


--Showing continents with total death count per population
Select continent, MAX(cast(Total_Deaths as int)) as totaldeathCount
From CovidDeaths
Where continent is not null 
Group By continent
Order By totaldeathCount desc

-- Global Numbers
Select sum(New_Cases) as NewCases, sum(cast(New_Deaths as int)) as NewDeaths, Sum(cast(New_Deaths as int))/sum(New_Cases)*100 as DeathPercentage
From CovidDeaths
Where Continent is not Null

--Looking at total population vs vaccination with rolling vaccination data by date 

Select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations, Sum(Convert(int,Vac.new_vaccinations)) over (Partition By dea.location order by Dea.Date) as RollingpeopleVac From
CovidDeaths Dea Join CovidVaccinations Vac
ON Dea.Location = Vac.Location
and Dea.Date = Vac.Date
Where Dea.Continent is not Null
Order by Dea.location, Dea.date

--Looking at total population vs vaccination with rolling vaccination data by date (Also, adding an aggregate function on RollingpeopleVac)
 

With PopVsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVac)
as(
Select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations, Sum(Convert(int,Vac.new_vaccinations)) over (Partition By dea.location order by Dea.Date) as RollingPeopleVac From
CovidDeaths Dea Join CovidVaccinations Vac
ON Dea.Location = Vac.Location
and Dea.Date = Vac.Date
Where Dea.Continent is not Null
--Order by Dea.location, Dea.date
 )

 
 Select *, (RollingPeopleVac/Population)*100 as DailyVacPerPopulation
 From PopVsVac

 -- Creating Views in SQL


 Create View PercentPopulationPopulationVaccinated as
Select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations, Sum(Convert(int,Vac.new_vaccinations)) over (Partition By dea.location order by Dea.Date) as RollingPeopleVac 
From CovidDeaths Dea Join CovidVaccinations Vac
ON Dea.Location = Vac.Location
and Dea.Date = Vac.Date
Where Dea.Continent is not Null
--Order by Dea.location, Dea.date


 




 












