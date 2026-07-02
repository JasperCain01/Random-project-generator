list(
  `datasets` = list(
    list(
      `id` = "gapminder",
      `name` = "Gapminder — life expectancy, population & GDP",
      `description` = "Country-level life expectancy, population and GDP per capita for 142 countries, 1952-2007. The classic development dataset.\n",
      `themes` = c("health", "economics", "international-relations"),
      `shape_tags` = c("time_series", "panel", "multivariate_numeric", "country_level"),
      `size` = "small",
      `access` = list(
        `type` = "r_package",
        `hint` = "install.packages('gapminder'); library(gapminder)"
      ),
      `url` = "https://cran.r-project.org/package=gapminder",
      `license` = "CC BY 4.0"
    ),
    list(
      `id` = "owid-life-expectancy",
      `name` = "Our World in Data — life expectancy",
      `description` = "Long-run life expectancy at birth for every country, some series reaching back to the 1700s. Tidy CSV straight from the OWID grapher.\n",
      `themes` = c("health", "international-relations"),
      `shape_tags` = c("time_series", "panel", "country_level"),
      `size` = "medium",
      `access` = list(
        `type` = "csv_url",
        `hint` = "read.csv('https://ourworldindata.org/grapher/life-expectancy.csv?v=1&csvType=full')"
      ),
      `url` = "https://ourworldindata.org/life-expectancy",
      `license` = "CC BY 4.0"
    ),
    list(
      `id` = "owid-covid",
      `name` = "Our World in Data — COVID-19 dataset",
      `description` = "Daily cases, deaths, testing, hospitalisation and vaccination for every country over the whole pandemic. Large but tidy.\n",
      `themes` = c("health", "politics", "international-relations"),
      `shape_tags` = c("time_series", "panel", "country_level", "large"),
      `size` = "large",
      `access` = list(
        `type` = "csv_url",
        `hint` = "read.csv('https://covid.ourworldindata.org/data/owid-covid-data.csv')"
      ),
      `url` = "https://github.com/owid/covid-19-data",
      `license` = "CC BY 4.0"
    ),
    list(
      `id` = "nhanes",
      `name` = "NHANES — US national health & nutrition survey",
      `description` = "Individual-level body measurements, demographics, lifestyle and lab results from the CDC's national health examination survey.\n",
      `themes` = c("health"),
      `shape_tags` = c("multivariate_numeric", "individual_level", "survey", "categorical"),
      `size` = "medium",
      `access` = list(
        `type` = "r_package",
        `hint` = "install.packages('NHANES'); library(NHANES); data(NHANES)"
      ),
      `url` = "https://cran.r-project.org/package=NHANES",
      `license` = "Public domain (CDC)"
    ),
    list(
      `id` = "cdc-causes-of-death",
      `name` = "CDC — leading causes of death in the US",
      `description` = "Age-adjusted death rates for the ten leading causes of death, by US state and year, from the National Center for Health Statistics.\n",
      `themes` = c("health", "politics"),
      `shape_tags` = c("time_series", "categorical", "geographic", "panel"),
      `size` = "small",
      `access` = list(
        `type` = "csv_url",
        `hint` = "read.csv('https://data.cdc.gov/api/views/bi63-dtpu/rows.csv?accessType=DOWNLOAD')"
      ),
      `url` = "https://data.cdc.gov/NCHS/NCHS-Leading-Causes-of-Death-United-States/bi63-dtpu",
      `license` = "Public domain (US government)"
    ),
    list(
      `id` = "fred",
      `name` = "FRED — Federal Reserve economic data",
      `description` = "Hundreds of thousands of US and international macroeconomic time series: rates, inflation, employment, money supply. Pick any series that catches your eye.\n",
      `themes` = c("finance", "economics"),
      `shape_tags` = c("time_series"),
      `size` = "medium",
      `access` = list(
        `type` = "api",
        `hint` = "install.packages('fredr'); fredr::fredr('UNRATE')  # free API key, or CSV export from the site"
      ),
      `url` = "https://fred.stlouisfed.org",
      `license` = "Mostly public domain; per-series terms"
    ),
    list(
      `id` = "stock-prices",
      `name` = "Daily stock & index prices (Yahoo Finance)",
      `description` = "Open/high/low/close/volume for any listed ticker or index, decades deep, one function call away.\n",
      `themes` = c("finance"),
      `shape_tags` = c("time_series", "multivariate_numeric"),
      `size` = "medium",
      `access` = list(
        `type` = "r_package",
        `hint` = "install.packages('tidyquant'); tidyquant::tq_get(c('AAPL','^GSPC'), from='2015-01-01')"
      ),
      `url` = "https://business-science.github.io/tidyquant/",
      `license` = "Personal/research use (Yahoo terms)"
    ),
    list(
      `id` = "crypto-coingecko",
      `name` = "CoinGecko — cryptocurrency market histories",
      `description` = "Price, market cap and volume histories for thousands of cryptocurrencies via a free, keyless JSON API.\n",
      `themes` = c("finance"),
      `shape_tags` = c("time_series"),
      `size` = "small",
      `access` = list(
        `type` = "api",
        `hint` = "jsonlite::fromJSON('https://api.coingecko.com/api/v3/coins/bitcoin/market_chart?vs_currency=usd&days=365')"
      ),
      `url` = "https://www.coingecko.com/en/api",
      `license` = "Free tier, attribution required"
    ),
    list(
      `id` = "wdi",
      `name` = "World Bank — World Development Indicators",
      `description` = "1,400+ annual indicators (GDP, poverty, education, energy, trade) for every country since 1960, queryable from R.\n",
      `themes` = c("economics", "international-relations", "health", "environment"),
      `shape_tags` = c("time_series", "panel", "country_level", "multivariate_numeric"),
      `size` = "medium",
      `access` = list(
        `type` = "r_package",
        `hint` = "install.packages('WDI'); WDI::WDI(indicator='NY.GDP.PCAP.KD', start=1990)"
      ),
      `url` = "https://data.worldbank.org",
      `license` = "CC BY 4.0"
    ),
    list(
      `id` = "eurostat",
      `name` = "Eurostat — official EU statistics",
      `description` = "The EU's statistical office: demographics, economy, agriculture, tourism, transport and more, at country and regional (NUTS) level.\n",
      `themes` = c("economics", "politics", "international-relations", "commerce"),
      `shape_tags` = c("time_series", "panel", "geographic", "country_level"),
      `size` = "medium",
      `access` = list(
        `type` = "r_package",
        `hint` = "install.packages('eurostat'); eurostat::search_eurostat('unemployment')"
      ),
      `url` = "https://ec.europa.eu/eurostat",
      `license` = "CC BY 4.0"
    ),
    list(
      `id` = "online-retail-uci",
      `name` = "UCI — online retail transactions",
      `description` = "Half a million real transactions from a UK online giftware retailer over two years: invoices, products, quantities, prices, customer country.\n",
      `themes` = c("commerce"),
      `shape_tags` = c("transactions", "time_series", "categorical", "large"),
      `size` = "large",
      `access` = list(
        `type` = "download",
        `hint` = "Download the xlsx from the UCI repository, then readxl::read_excel()"
      ),
      `url` = "https://archive.ics.uci.edu/dataset/502/online+retail+ii",
      `license` = "CC BY 4.0"
    ),
    list(
      `id` = "olist-ecommerce",
      `name` = "Olist — Brazilian e-commerce orders",
      `description` = "100k orders from a Brazilian marketplace: order items, payments, reviews, sellers and customer geolocation across eight relational tables.\n",
      `themes` = c("commerce"),
      `shape_tags` = c("transactions", "categorical", "geographic", "relational", "large"),
      `size` = "large",
      `access` = list(
        `type` = "kaggle",
        `hint` = "Download from Kaggle (free account), then read the CSVs with readr"
      ),
      `url` = "https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce",
      `license` = "CC BY-NC-SA 4.0"
    ),
    list(
      `id` = "un-comtrade",
      `name` = "UN Comtrade — international trade flows",
      `description` = "Bilateral imports and exports by commodity between all countries — the canonical who-sells-what-to-whom dataset.\n",
      `themes` = c("commerce", "economics", "international-relations"),
      `shape_tags` = c("network", "country_level", "panel", "categorical"),
      `size` = "medium",
      `access` = list(
        `type` = "r_package",
        `hint` = "install.packages('comtradr'); comtradr::ct_get_data(reporter='GB', partner='all')  # free API key"
      ),
      `url` = "https://comtradeplus.un.org",
      `license` = "Free for research with registration"
    ),
    list(
      `id` = "unvotes",
      `name` = "UN General Assembly voting records",
      `description` = "Every UN General Assembly roll-call vote since 1946: country, vote, and issue classification. Great for alignment and bloc analysis.\n",
      `themes` = c("politics", "international-relations"),
      `shape_tags` = c("panel", "categorical", "country_level", "network", "time_series"),
      `size` = "medium",
      `access` = list(
        `type` = "r_package",
        `hint` = "install.packages('unvotes'); library(unvotes)"
      ),
      `url` = "https://cran.r-project.org/package=unvotes",
      `license` = "CC0 (Voeten et al.)"
    ),
    list(
      `id` = "mit-election-lab",
      `name` = "MIT Election Lab — US presidential returns by county",
      `description` = "County-level US presidential election results 2000-2020, with party and candidate vote counts.\n",
      `themes` = c("politics"),
      `shape_tags` = c("geographic", "categorical", "panel"),
      `size` = "medium",
      `access` = list(
        `type` = "download",
        `hint` = "Download CSV from the Harvard Dataverse, then readr::read_csv()"
      ),
      `url` = "https://electionlab.mit.edu/data",
      `license` = "CC0"
    ),
    list(
      `id` = "vdem",
      `name` = "V-Dem — Varieties of Democracy indices",
      `description` = "450+ expert-coded indicators of democracy (elections, civil liberties, media freedom) for nearly every country back to 1789.\n",
      `themes` = c("politics", "international-relations"),
      `shape_tags` = c("panel", "multivariate_numeric", "time_series", "country_level"),
      `size` = "large",
      `access` = list(
        `type` = "r_package",
        `hint` = "remotes::install_github('vdeminstitute/vdemdata'); library(vdemdata)"
      ),
      `url` = "https://v-dem.net",
      `license` = "Free for research, cite V-Dem"
    ),
    list(
      `id` = "ucdp-conflict",
      `name` = "UCDP/PRIO — armed conflict dataset",
      `description` = "Every armed conflict since 1946 with parties, location, intensity and year — the standard academic conflict dataset.\n",
      `themes` = c("international-relations", "politics"),
      `shape_tags` = c("events", "time_series", "geographic", "categorical"),
      `size` = "small",
      `access` = list(
        `type` = "download",
        `hint` = "Download CSV from ucdp.uu.se/downloads, then readr::read_csv()"
      ),
      `url` = "https://ucdp.uu.se/downloads/",
      `license` = "Free with citation"
    ),
    list(
      `id` = "unhcr-refugees",
      `name` = "UNHCR — refugee population statistics",
      `description` = "Refugees, asylum seekers and internally displaced people by origin and asylum country, yearly since 1951, via UNHCR's own R package.\n",
      `themes` = c("international-relations", "politics"),
      `shape_tags` = c("panel", "time_series", "country_level", "network"),
      `size` = "medium",
      `access` = list(
        `type` = "r_package",
        `hint` = "install.packages('refugees'); library(refugees); refugees::population"
      ),
      `url` = "https://www.unhcr.org/refugee-statistics/",
      `license` = "CC BY 4.0"
    ),
    list(
      `id` = "nasa-gistemp",
      `name` = "NASA GISTEMP — global temperature anomalies",
      `description` = "Monthly global and zonal surface temperature anomalies since 1880, maintained by NASA GISS.\n",
      `themes` = c("environment"),
      `shape_tags` = c("time_series"),
      `size` = "small",
      `access` = list(
        `type` = "csv_url",
        `hint` = "read.csv('https://data.giss.nasa.gov/gistemp/tabledata_v4/GLB.Ts+dSST.csv', skip=1)"
      ),
      `url` = "https://data.giss.nasa.gov/gistemp/",
      `license` = "Public domain (NASA)"
    ),
    list(
      `id` = "global-power-plants",
      `name` = "WRI — global power plant database",
      `description` = "~35,000 power plants worldwide with location, fuel type, capacity and estimated generation.\n",
      `themes` = c("environment", "economics"),
      `shape_tags` = c("geographic", "categorical", "cross_section"),
      `size` = "medium",
      `access` = list(
        `type` = "download",
        `hint` = "Download CSV from WRI / datasets.wri.org, then readr::read_csv()"
      ),
      `url` = "https://datasets.wri.org/dataset/globalpowerplantdatabase",
      `license` = "CC BY 4.0"
    ),
    list(
      `id` = "palmerpenguins",
      `name` = "Palmer Station penguins",
      `description` = "Body measurements for 344 penguins of three species from the Palmer Archipelago, Antarctica. The friendlier iris.\n",
      `themes` = c("science", "environment"),
      `shape_tags` = c("multivariate_numeric", "categorical", "cross_section", "individual_level"),
      `size` = "small",
      `access` = list(
        `type` = "r_package",
        `hint` = "install.packages('palmerpenguins'); library(palmerpenguins)"
      ),
      `url` = "https://allisonhorst.github.io/palmerpenguins/",
      `license` = "CC0"
    ),
    list(
      `id` = "nycflights13",
      `name` = "nycflights13 — every flight out of NYC in 2013",
      `description` = "336,776 flights from the three New York airports with delays, carriers, weather and plane metadata in five relational tables.\n",
      `themes` = c("transport", "commerce"),
      `shape_tags` = c("time_series", "categorical", "relational", "network", "large", "events"),
      `size` = "large",
      `access` = list(
        `type` = "r_package",
        `hint` = "install.packages('nycflights13'); library(nycflights13)"
      ),
      `url` = "https://cran.r-project.org/package=nycflights13",
      `license` = "CC0"
    ),
    list(
      `id` = "sotu-speeches",
      `name` = "State of the Union addresses (full text)",
      `description` = "The complete text of every US State of the Union address since 1790 — two centuries of political language in one package.\n",
      `themes` = c("politics", "culture"),
      `shape_tags` = c("text", "time_series"),
      `size` = "small",
      `access` = list(
        `type` = "r_package",
        `hint` = "install.packages('sotu'); library(sotu); sotu_text"
      ),
      `url` = "https://cran.r-project.org/package=sotu",
      `license` = "CC0"
    ),
    list(
      `id` = "spotify-songs",
      `name` = "Spotify songs — audio features of 30k tracks",
      `description` = "Danceability, energy, valence, tempo and popularity for ~30,000 songs across six genres (TidyTuesday, sourced from the Spotify API).\n",
      `themes` = c("culture", "commerce"),
      `shape_tags` = c("multivariate_numeric", "categorical", "cross_section"),
      `size` = "medium",
      `access` = list(
        `type` = "csv_url",
        `hint` = "read.csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-01-21/spotify_songs.csv')"
      ),
      `url` = "https://github.com/rfordatascience/tidytuesday/blob/master/data/2020/2020-01-21/readme.md",
      `license` = "CC0 (TidyTuesday)"
    ),
    list(
      `id` = "international-football",
      `name` = "International football results, 1872-present",
      `description` = "Every men's international football match since 1872: teams, score, tournament, venue. 47k+ matches, updated continuously.\n",
      `themes` = c("sport", "culture", "international-relations"),
      `shape_tags` = c("time_series", "events", "categorical", "network"),
      `size` = "medium",
      `access` = list(
        `type` = "csv_url",
        `hint` = "read.csv('https://raw.githubusercontent.com/martj42/international_results/master/results.csv')"
      ),
      `url` = "https://github.com/martj42/international_results",
      `license` = "CC0"
    ),
    list(
      `id` = "tidytuesday-lucky-dip",
      `name` = "TidyTuesday lucky dip",
      `description` = "Let fate go one level deeper: pick a random week from the TidyTuesday archive of 300+ curated, pre-cleaned datasets and use whatever you get.\n",
      `themes` = c("culture", "science", "commerce", "sport", "politics", "health", "environment"),
      `shape_tags` = c("time_series", "categorical", "multivariate_numeric", "cross_section"),
      `size` = "small",
      `access` = list(
        `type` = "r_package",
        `hint` = "install.packages('tidytuesdayR'); tidytuesdayR::tt_load(sample(2019:2024,1), week=sample(1:52,1))"
      ),
      `url` = "https://github.com/rfordatascience/tidytuesday",
      `license` = "Varies by week (documented per dataset)"
    )
  ),
  `questions` = list(
    list(
      `id` = "long-run-trend",
      `family` = "Trends",
      `requires_any` = c("time_series"),
      `template` = "What is the long-run trend in {dataset}? Decompose it: how much is secular drift, how much is seasonal or cyclical, and how much is noise?\n"
    ),
    list(
      `id` = "changepoint",
      `family` = "Trends",
      `requires_any` = c("time_series"),
      `template` = "Find the moment the story changed in {dataset}. Is there a structural break or regime change, and what real-world event coincides with it?\n"
    ),
    list(
      `id` = "forecast",
      `family` = "Forecasting",
      `requires_any` = c("time_series"),
      `template` = "Build a forecast from {dataset} for the next few periods. Compare a naive baseline against a proper model — how much does the model actually buy you?\n"
    ),
    list(
      `id` = "convergence-divergence",
      `family` = "Trends",
      `requires_all` = c("panel", "country_level"),
      `template` = "Are countries in {dataset} converging or diverging over time? Quantify the gap between the top and bottom groups and how it has moved.\n"
    ),
    list(
      `id` = "pca-structure",
      `family` = "Dimensionality",
      `requires_any` = c("multivariate_numeric"),
      `template` = "Run a PCA on {dataset}. What do the first two or three components mean in plain language, and which observations sit far from everyone else?\n"
    ),
    list(
      `id` = "clustering",
      `family` = "Dimensionality",
      `requires_any` = c("multivariate_numeric"),
      `template` = "Cluster the observations in {dataset}. How many natural groups are there, do they match any existing labels, and what defines each group?\n"
    ),
    list(
      `id` = "anomaly-hunt",
      `family` = "Anomalies",
      `requires_any` = c("time_series", "multivariate_numeric", "transactions"),
      `template` = "Hunt for anomalies in {dataset}. Define \"unusual\" quantitatively, flag the strangest observations, and investigate whether they are errors or stories.\n"
    ),
    list(
      `id` = "spatial-pattern",
      `family` = "Spatial",
      `requires_any` = c("geographic"),
      `template` = "Map {dataset}. Is the spatial pattern clustered, dispersed, or random — and can you back that judgement with a statistic rather than a glance?\n"
    ),
    list(
      `id` = "choropleth-story",
      `family` = "Spatial",
      `requires_any` = c("geographic"),
      `template` = "Build a choropleth (or point map) from {dataset} that tells one clear story, then write the three-sentence caption that a newspaper would print.\n"
    ),
    list(
      `id` = "network-centrality",
      `family` = "Networks",
      `requires_any` = c("network"),
      `template` = "Treat {dataset} as a network. Who are the most central nodes, does the network have communities, and how has its structure shifted over time?\n"
    ),
    list(
      `id` = "league-table",
      `family` = "Comparison",
      `requires_any` = c("categorical", "country_level"),
      `template` = "Build a defensible ranking from {dataset}. Who is top, who is bottom, how sensitive is the ordering to your methodological choices?\n"
    ),
    list(
      `id` = "correlation-vs-causation",
      `family` = "Relationships",
      `requires_any` = c("panel", "multivariate_numeric"),
      `template` = "Pick two variables in {dataset} that correlate strongly. Argue both sides: what would the causal story be, and what confounder could explain it away?\n"
    ),
    list(
      `id` = "distribution-inequality",
      `family` = "Distributions",
      `requires_any` = c("individual_level", "transactions", "country_level"),
      `template` = "Study the full distribution in {dataset}, not just the mean. How skewed or unequal is it (Gini, top-decile share), and is that concentration growing?\n"
    ),
    list(
      `id` = "simulation-uncertainty",
      `family` = "Simulation",
      `template` = "Take one headline number you can compute from {dataset} and put honest uncertainty around it using bootstrap or permutation methods. Does the headline survive?\n"
    ),
    list(
      `id` = "missingness",
      `family` = "Data quality",
      `requires_any` = c("survey", "panel", "individual_level"),
      `template` = "Profile the missing data in {dataset}. Is it missing at random? Who or what is systematically absent, and how would that bias a naive analysis?\n"
    ),
    list(
      `id` = "text-sentiment",
      `family` = "Text",
      `requires_any` = c("text"),
      `template` = "Track sentiment and emotional language across {dataset} over time. When was the tone darkest, and does it track historical events?\n"
    ),
    list(
      `id` = "text-topics",
      `family` = "Text",
      `requires_any` = c("text"),
      `template` = "Fit a topic model to {dataset}. What themes emerge, and how has their prominence risen and fallen across the corpus?\n"
    ),
    list(
      `id` = "seasonality",
      `family` = "Trends",
      `requires_any` = c("time_series"),
      `template` = "Isolate the seasonal or weekly rhythm in {dataset}. What repeats, how strong is the cycle, and is the rhythm itself changing?\n"
    ),
    list(
      `id` = "cohort-comparison",
      `family` = "Comparison",
      `requires_any` = c("categorical", "individual_level"),
      `template` = "Split {dataset} into meaningful cohorts and compare them. Which difference between groups is largest, and does it hold up after controlling for an obvious confounder?\n"
    ),
    list(
      `id` = "relational-join-insight",
      `family` = "Relationships",
      `requires_any` = c("relational"),
      `template` = "The interesting answer in {dataset} needs at least two of its tables. Find a question that only a join can answer, and answer it.\n"
    ),
    list(
      `id` = "lead-lag",
      `family` = "Relationships",
      `requires_any` = c("time_series"),
      `template` = "Pick two related series in {dataset} (or split one by group). Does one lead the other? Use cross-correlation at different lags to find out.\n"
    ),
    list(
      `id` = "volatility-regimes",
      `family` = "Trends",
      `requires_any` = c("time_series"),
      `template` = "Ignore the level of {dataset} and study its volatility instead. When was it calmest, when wildest, and does turbulence cluster in time?\n"
    ),
    list(
      `id` = "event-impact",
      `family` = "Trends",
      `requires_all` = c("events", "time_series"),
      `template` = "Choose one notable event in {dataset} and treat it as a natural experiment: compare before and after, against a sensible counterfactual.\n"
    ),
    list(
      `id` = "record-extremes",
      `family` = "Anomalies",
      `requires_any` = c("time_series"),
      `template` = "Study the records in {dataset}: how extreme is the most extreme value, how often are records broken, and is the rate of record-breaking itself speeding up or slowing down?\n"
    ),
    list(
      `id` = "rank-mobility",
      `family` = "Comparison",
      `requires_all` = c("panel"),
      `template` = "Build a league table from {dataset} at two points in time. Who climbed, who fell, and is the ordering becoming more frozen or more fluid?\n"
    ),
    list(
      `id` = "composition-shift",
      `family` = "Comparison",
      `requires_all` = c("categorical", "time_series"),
      `template` = "Look at shares, not totals, in {dataset}. How has the composition shifted over time, and which category's rise came at whose expense?\n"
    ),
    list(
      `id` = "simpsons-paradox",
      `family` = "Relationships",
      `requires_any` = c("categorical", "individual_level"),
      `template` = "Hunt for a Simpson's paradox in {dataset}: a relationship that weakens, vanishes or reverses once you split the data by the right grouping variable. If you find one, explain it; if not, show why it's safe.\n"
    ),
    list(
      `id` = "regression-drivers",
      `family` = "Relationships",
      `requires_any` = c("multivariate_numeric"),
      `template` = "Pick an outcome variable in {dataset} and model it. Which predictors genuinely matter, how big are their effects in real-world units, and what does the model get badly wrong?\n"
    ),
    list(
      `id` = "classification",
      `family` = "Prediction",
      `requires_all` = c("multivariate_numeric", "categorical"),
      `template` = "Train a classifier on {dataset} to predict one of its categorical labels. How accurate can you get with honest cross-validation, and which features carry the signal?\n"
    ),
    list(
      `id` = "market-basket",
      `family` = "Patterns",
      `requires_any` = c("transactions"),
      `template` = "Mine {dataset} for co-occurrence: which items, categories or behaviours appear together far more often than chance? Turn the strongest association rules into a plain-language insight.\n"
    ),
    list(
      `id` = "rfm-segmentation",
      `family` = "Patterns",
      `requires_any` = c("transactions"),
      `template` = "Segment the customers in {dataset} by recency, frequency and monetary value. Profile each segment and say what you would do differently for the top and bottom ones.\n"
    ),
    list(
      `id` = "benford",
      `family` = "Data quality",
      `requires_any` = c("transactions", "country_level", "events"),
      `template` = "Do the leading digits in {dataset} obey Benford's law? Test it, visualise the deviation, and explain what conformity — or non-conformity — actually implies here.\n"
    ),
    list(
      `id` = "network-asymmetry",
      `family` = "Networks",
      `requires_any` = c("network"),
      `template` = "Study the imbalances in {dataset}: which flows or relationships are strongly one-directional, and what does the pattern of asymmetry reveal?\n"
    ),
    list(
      `id` = "text-complexity",
      `family` = "Text",
      `requires_any` = c("text"),
      `template` = "Measure how the language in {dataset} has changed: sentence length, readability, vocabulary richness. Is it getting simpler — and when did the style shift most sharply?\n"
    ),
    list(
      `id` = "distinctive-words",
      `family` = "Text",
      `requires_any` = c("text"),
      `template` = "Split {dataset} into eras or groups and find each one's signature vocabulary (tf-idf or log-odds). What do the distinctive words say about how concerns have changed?\n"
    )
  ),
  `challenges` = list(
    list(
      `id` = "one-pipe",
      `name` = "One pipe to rule them all",
      `difficulty` = "mild",
      `description` = "Express the core data transformation as a single unbroken pipe chain, from raw data to plot-ready table.\n"
    ),
    list(
      `id` = "self-contained-chart",
      `name` = "The chart stands alone",
      `difficulty` = "mild",
      `description` = "Produce one chart so thoroughly annotated (title, subtitle, direct labels, source note) that it needs no surrounding text at all.\n"
    ),
    list(
      `id` = "colorblind-safe",
      `name` = "Colour with care",
      `difficulty` = "mild",
      `description` = "Use only a colourblind-safe palette (viridis or Okabe-Ito) and verify the result with a simulator before calling it done.\n"
    ),
    list(
      `id` = "hundred-lines",
      `name` = "100 lines, max",
      `difficulty` = "mild",
      `description` = "The entire analysis — import to final figure — in at most 100 lines of R, comments included.\n"
    ),
    list(
      `id` = "small-multiples",
      `name` = "Small multiples, no legends",
      `difficulty` = "mild",
      `description` = "Every comparison must be a faceted small-multiples chart with direct labelling — legends are banned.\n"
    ),
    list(
      `id` = "no-loops",
      `name` = "No loops",
      `difficulty` = "mild",
      `description` = "No for or while loops anywhere — vectorised operations and purrr/apply functions only.\n"
    ),
    list(
      `id` = "table-centrepiece",
      `name` = "The table is the chart",
      `difficulty` = "mild",
      `description` = "Make a beautifully formatted table (gt or reactable) the centrepiece deliverable instead of a plot.\n"
    ),
    list(
      `id` = "five-minute-story",
      `name` = "Tell it in five slides",
      `difficulty` = "mild",
      `description` = "Condense the whole project into five presentation slides (Quarto revealjs) a non-technical audience could follow.\n"
    ),
    list(
      `id` = "log-scale-defence",
      `name` = "Defend your axes",
      `difficulty` = "mild",
      `description` = "Somewhere a log scale, index (=100) rebasing, or per-capita adjustment changes the story. Show the naive version and the adjusted one, and argue for your choice.\n"
    ),
    list(
      `id` = "annotate-history",
      `name` = "Annotate the timeline",
      `difficulty` = "mild",
      `description` = "Overlay the real-world events that explain the shape of your data — at least five dated annotations, each earning its place.\n"
    ),
    list(
      `id` = "one-hue",
      `name` = "Monochrome",
      `difficulty` = "mild",
      `description` = "One hue only. Encode every distinction through lightness, size, shape or position — never a second colour.\n"
    ),
    list(
      `id` = "readme-first",
      `name` = "Register your bets",
      `difficulty` = "mild",
      `description` = "Before touching the data, write down three predictions about what you will find. Publish them unedited next to what you actually found.\n"
    ),
    list(
      `id` = "base-r-only",
      `name` = "No tidyverse",
      `difficulty` = "medium",
      `description` = "Do the whole analysis and all plots in base R — no dplyr, no ggplot2. Rediscover aggregate(), tapply() and friends.\n"
    ),
    list(
      `id` = "interactive",
      `name` = "Make it interactive",
      `difficulty` = "medium",
      `description` = "Deliver the result as an interactive graphic (plotly, ggiraph or leaflet) with tooltips that genuinely add information.\n"
    ),
    list(
      `id` = "quarto-dashboard",
      `name` = "Ship a dashboard",
      `difficulty` = "medium",
      `description` = "Present the findings as a Quarto dashboard with at least three coordinated panels.\n"
    ),
    list(
      `id` = "second-dataset",
      `name` = "Bring a friend",
      `difficulty` = "medium",
      `description` = "Join in a second dataset from this generator's own index and make the combination essential to the answer.\n"
    ),
    list(
      `id` = "sensitivity-analysis",
      `name` = "Stress-test it",
      `difficulty` = "medium",
      `description` = "Identify the three most consequential analytical choices you made and show how the headline result moves when each is varied.\n"
    ),
    list(
      `id` = "art-mode",
      `name` = "Data art",
      `difficulty` = "medium",
      `description` = "Alongside the serious analysis, render the same data as a purely aesthetic generative-art piece.\n"
    ),
    list(
      `id` = "shiny-app",
      `name` = "Make it an app",
      `difficulty` = "medium",
      `description` = "Wrap the analysis in a small Shiny app with at least one input that meaningfully changes what the user sees.\n"
    ),
    list(
      `id` = "animate-it",
      `name` = "Set it in motion",
      `difficulty` = "medium",
      `description` = "The key chart must be animated (gganimate) — and the motion must encode information, not decoration.\n"
    ),
    list(
      `id` = "api-fresh",
      `name` = "No stale data",
      `difficulty` = "medium",
      `description` = "The script must pull the data live from the source (API or URL) on every run — no downloaded files committed to the project.\n"
    ),
    list(
      `id` = "data-quality-gate",
      `name` = "Guard the gate",
      `difficulty` = "medium",
      `description` = "Add an explicit validation stage (pointblank or hand-rolled assertions) that checks at least eight expectations about the raw data before any analysis runs.\n"
    ),
    list(
      `id` = "lie-detector",
      `name` = "Lie, then confess",
      `difficulty` = "medium",
      `description` = "Build the most misleading chart you can from this data without faking a single number. Then show the honest version and annotate every trick.\n"
    ),
    list(
      `id` = "duckdb-sql",
      `name` = "Speak SQL",
      `difficulty` = "medium",
      `description` = "All heavy lifting happens in DuckDB via SQL queries from R — dplyr may only touch the final, aggregated result.\n"
    ),
    list(
      `id` = "data-table",
      `name` = "Speak data.table",
      `difficulty` = "spicy",
      `description` = "Use data.table for every transformation instead of your usual tools, idiomatically (no dplyr translations).\n"
    ),
    list(
      `id` = "package-it",
      `name` = "Package it",
      `difficulty` = "spicy",
      `description` = "Wrap the core logic as functions in a minimal R package with roxygen docs and at least three testthat tests.\n"
    ),
    list(
      `id` = "publication-style",
      `name` = "Newsroom style",
      `difficulty` = "spicy",
      `description` = "Style the final graphic like The Economist, FT or BBC — typography, grid, annotations and all — using a theme you build yourself.\n"
    ),
    list(
      `id` = "targets-pipeline",
      `name` = "Reproducible pipeline",
      `difficulty` = "spicy",
      `description` = "Orchestrate the analysis with the {targets} package so a single tar_make() rebuilds everything from scratch.\n"
    ),
    list(
      `id` = "webr-publish",
      `name` = "Publish it in webR",
      `difficulty` = "spicy",
      `description` = "Publish the analysis so it runs in the reader's browser via webR or shinylive — just like this generator does.\n"
    ),
    list(
      `id` = "model-bake-off",
      `name` = "Model bake-off",
      `difficulty` = "spicy",
      `description` = "Fit at least three different model classes with tidymodels, compare them with honest resampled metrics, and declare a winner you can defend.\n"
    ),
    list(
      `id` = "go-bayesian",
      `name` = "Go Bayesian",
      `difficulty` = "spicy",
      `description` = "Estimate the headline quantity with a Bayesian model (brms or rstanarm), show the full posterior, and explain your priors out loud.\n"
    ),
    list(
      `id` = "memory-diet",
      `name` = "Memory diet",
      `difficulty` = "spicy",
      `description` = "Pretend the data is 100x bigger: process it in chunks or via arrow/duckdb streaming, never holding the full raw dataset in RAM.\n"
    ),
    list(
      `id` = "one-command-repro",
      `name` = "One-command reproduction",
      `difficulty` = "spicy",
      `description` = "A stranger must be able to clone the repo and rebuild every result with a single command — renv lockfile, pinned versions, no manual steps.\n"
    ),
    list(
      `id` = "ci-render",
      `name` = "Robot in the loop",
      `difficulty` = "spicy",
      `description` = "A GitHub Action must re-run the analysis and re-render the report on every push, failing loudly if anything breaks.\n"
    ),
    list(
      `id` = "stone-age-r",
      `name` = "Stone-age R",
      `difficulty` = "extra-spicy",
      `description` = "Zero packages. Not one library() call — download, wrangling, statistics and graphics in what ships with base R alone.\n"
    ),
    list(
      `id` = "live-dashboard",
      `name` = "Keep it alive",
      `difficulty` = "extra-spicy",
      `description` = "Deploy a dashboard that refreshes itself on a schedule (GitHub Actions cron re-render to Pages counts) and is still up a month from now.\n"
    ),
    list(
      `id` = "bilingual-pipeline",
      `name` = "Bilingual pipeline",
      `difficulty` = "extra-spicy",
      `description` = "Rebuild the core pipeline a second time in another language (Python, SQL or Julia) and prove the two implementations agree to the last digit.\n"
    ),
    list(
      `id` = "tweet-sized",
      `name` = "Tweet-sized analysis",
      `difficulty` = "extra-spicy",
      `description` = "After the full analysis, compress the core computation into 280 characters of R that still produces the headline number and a plot.\n"
    ),
    list(
      `id` = "teach-it",
      `name` = "Teach it back",
      `difficulty` = "extra-spicy",
      `description` = "Turn the project into a self-guided tutorial (learnr or a literate Quarto walkthrough) that a beginner could follow to reproduce every step — exercises and wrong-turn warnings included.\n"
    ),
    list(
      `id` = "full-simulation",
      `name` = "Build the twin",
      `difficulty` = "extra-spicy",
      `description` = "Write a generative simulation of the process behind this data, calibrate it until simulated data is hard to tell from the real thing, then use it to answer a what-if the data alone cannot.\n"
    )
  )
)
