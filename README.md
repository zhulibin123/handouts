# README.md

A `README.md` file is a very useful component of any project repository. As you can see, it is automatically rendered on GitHub, where it acts as a simple "homepage" for your project.

## About

The purpose of this repository is to distribute handouts during a SESYNC training event. The content changes between short courses, but it typically includes worksheets for different tutorials and any necessary data.

Most trainees will fork this repository during a short course. Following a short course, the content will be archived as a zip file. To get the handouts from a past short course: navigate to [releases](../../releases), select your course by its starting date, and download `handouts.zip`. The zip does not contain a git repository—only the worksheets and necessary data.

## Data

The following files may be found in the `data/` directory, depending on the course.

---

`plots.csv`, `animals.csv`, `species.csv`, `portal.xlsx`, `portal.sqlite`

The Portal Project Teaching Database is a simplified version of the Portal
Project Database designed for teaching. It provides a real world example of
life-history, population, and ecological data, with sufficient complexity to
teach many aspects of data analysis and management, but with many complexities
removed to allow students to focus on the core ideas and skills being taught.

The database is currently available in csv, xlsx, and sqlite.

Use of this dataset should cite: http://dx.doi.org/10.6084/m9.figshare.1314459

This database is not designed for research as it intentionally removes some of
the real-world complexities. The [original database is published at Ecological
Archives](http://esapubs.org/archive/ecol/E090/118/) and this version of the
database should be used for research purposes.

----

`nlcd_agg.*`, `nlcd_proj.*`

A portion of the [National Land Cover Database](http://www.mrlc.gov/nlcd2011.php) 
that has been cropped and reduced to a lower resolution in order to speed up processing
time for this tutorial. The *nlcd_agg* raster is in the original Albers equal-area
projection, whereas the *nlcd_proj* raster has been reprojected to Web Mercator
for use with the `leaflet` package.

----

`cb_500k_maryland/*`

Maryland county boundaries extracted from the US Census [county boundaries
shapefile](http://www2.census.gov/geo/tiger/GENZ2014/shp/cb_2014_us_county_500k.zip).

---

`huc250k/*`

1:250,000-scale Hydrologic Units of the United States published by the U.S. Geological Survey as a [shapefile with associated metadata](https://water.usgs.gov/GIS/metadata/usgswrd/XML/huc250k.xml).

---
